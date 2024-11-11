import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/heat_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HeatRegisterPage extends StatefulWidget {
  const HeatRegisterPage({super.key});

  @override
  _HeatRegisterPageState createState() => _HeatRegisterPageState();
}

class _HeatRegisterPageState extends State<HeatRegisterPage> {
  final List<HeatRecord> _heatRecords = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cowIdController = TextEditingController();
  final TextEditingController _dateOfHeatController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _heatSignsController = TextEditingController();
  final TextEditingController _inseminationDateController = TextEditingController();
  bool? _isPregnant;

  @override
  void initState() {
    super.initState();
    _fetchHeatRecords();
  }

  Future<void> _fetchHeatRecords() async {
    // Fetch records from Firestore and update _heatRecords list
    final querySnapshot = await FirebaseFirestore.instance.collection('heat_records').get();
    setState(() {
      _heatRecords.clear();
      for (var doc in querySnapshot.docs) {
        _heatRecords.add(HeatRecord.fromFirestore(doc));
      }
    });
  }

  Future<void> _saveRecordToFirestore(HeatRecord record, {String? docId}) async {
    final collection = FirebaseFirestore.instance.collection('heat_records');
    if (docId != null) {
      // Update existing record
      await collection.doc(docId).update(record.toFirestore());
    } else {
      // Add new record
      await collection.add(record.toFirestore());
    }
  }

  void _showRecordDialog({HeatRecord? record, int? index}) {
    if (record != null) {
      _cowIdController.text = record.cowId;
      _dateOfHeatController.text = DateFormat('yyyy-MM-dd').format(record.dateOfHeat);
      _durationController.text = record.duration.inHours.toString();
      _heatSignsController.text = record.heatSigns;
      _inseminationDateController.text = record.inseminationDate != null
          ? DateFormat('yyyy-MM-dd').format(record.inseminationDate!)
          : '';
      _isPregnant = record.isPregnant;
    } else {
      _clearForm();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFFFF), // White background color
          title: Text(record != null ? "Edit Heat Record" : "Add Heat Record"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _cowIdController,
                    labelText: 'Cow ID',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Cow ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    controller: _dateOfHeatController,
                    labelText: 'Date of Heat',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select Date of Heat';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _durationController,
                    labelText: 'Duration (in hours)',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter duration';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _heatSignsController,
                    labelText: 'Heat Signs',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please describe Heat Signs';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    controller: _inseminationDateController,
                    labelText: 'Insemination Date',
                  ),
                  const SizedBox(height: 16),
                  _buildPregnancyDropdown(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                _clearForm();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66BB6A), // Green button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Circular border radius
                ),
              ),
              child: Text(record != null ? "Update Record" : "Add Record"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  HeatRecord newRecord = HeatRecord(
                    id: record?.id ?? '', // Use existing ID if updating, or empty if new
                    cowId: _cowIdController.text,
                    dateOfHeat: DateFormat('yyyy-MM-dd').parse(_dateOfHeatController.text),
                    duration: Duration(hours: int.parse(_durationController.text)),
                    heatSigns: _heatSignsController.text,
                    inseminationDate: _inseminationDateController.text.isNotEmpty
                        ? DateFormat('yyyy-MM-dd').parse(_inseminationDateController.text)
                        : null,
                    isPregnant: _isPregnant,
                  );
                  if (record != null && index != null) {
                    // Update existing record
                    _saveRecordToFirestore(newRecord, docId: record.id);
                    setState(() {
                      _heatRecords[index] = newRecord;
                    });
                  } else {
                    // Add new record
                    _saveRecordToFirestore(newRecord);
                    setState(() {
                      _heatRecords.add(newRecord);
                    });
                  }
                  _clearForm();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Container _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }

  Container _buildDateField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        },
        validator: validator,
      ),
    );
  }

  Container _buildPregnancyDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<bool>(
        value: _isPregnant,
        decoration: InputDecoration(
          labelText: 'Pregnancy Status',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        items: const [
          DropdownMenuItem(value: true, child: Text('Pregnant')),
          DropdownMenuItem(value: false, child: Text('Not Pregnant')),
        ],
        onChanged: (value) {
          setState(() {
            _isPregnant = value;
          });
        },
      ),
    );
  }

  void _clearForm() {
    _cowIdController.clear();
    _dateOfHeatController.clear();
    _durationController.clear();
    _heatSignsController.clear();
    _inseminationDateController.clear();
    _isPregnant = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heat Register'),
      ),
      body: ListView.builder(
        itemCount: _heatRecords.length,
        itemBuilder: (context, index) {
          final record = _heatRecords[index];
          return ListTile(
            title: Text('Cow ID: ${record.cowId}'),
            subtitle: Text(
              'Date of Heat: ${DateFormat('yyyy-MM-dd').format(record.dateOfHeat)}\nDuration: ${record.duration.inHours} hours',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showRecordDialog(record: record, index: index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRecordDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
