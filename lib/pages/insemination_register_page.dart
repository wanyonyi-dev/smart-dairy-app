// lib/pages/insemination_register_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/insemination_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InseminationRegisterPage extends StatefulWidget {
  const InseminationRegisterPage({super.key});

  @override
  _InseminationRegisterPageState createState() => _InseminationRegisterPageState();
}

class _InseminationRegisterPageState extends State<InseminationRegisterPage> {
  // List of insemination records fetched from Firestore
  final List<InseminationRecord> _inseminationRecords = [];

  // List of cow breeds
  final List<String> breeds = ['Holstein', 'Jersey', 'Guernsey', 'Ayrshire'];
  String? selectedBreed;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cowIdController = TextEditingController();
  final TextEditingController _semenBatchController = TextEditingController();
  final TextEditingController _technicianController = TextEditingController();
  final TextEditingController _inseminationDateController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _semenCompanyController = TextEditingController();
  final TextEditingController _bullNameController = TextEditingController();
  final TextEditingController _tagNoController = TextEditingController();
  final TextEditingController _lactationNoController = TextEditingController();

  // Firestore collection reference
  final CollectionReference _inseminationRecordsCollection =
      FirebaseFirestore.instance.collection('inseminationRecords');

  @override
  void initState() {
    super.initState();
    _fetchRecordsFromFirestore(); // Fetch records on page load
  }

  // Fetch records from Firestore
  Future<void> _fetchRecordsFromFirestore() async {
    QuerySnapshot querySnapshot = await _inseminationRecordsCollection.get();
    setState(() {
      _inseminationRecords.clear();
      _inseminationRecords.addAll(querySnapshot.docs.map((doc) {
        return InseminationRecord.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }));
    });
  }

  // Save or update record to Firestore
  Future<void> _saveRecordToFirestore({InseminationRecord? record}) async {
    try {
      DateTime inseminationDate = DateFormat('yyyy-MM-dd').parse(_inseminationDateController.text);

      if (record == null) {
        // Create new record
        await _inseminationRecordsCollection.add({
          'cowId': _cowIdController.text,
          'inseminationDate': inseminationDate,
          'semenBatch': _semenBatchController.text,
          'technician': _technicianController.text,
          'remarks': _remarksController.text.isNotEmpty ? _remarksController.text : null,
          'semenCompany': _semenCompanyController.text,
          'bullName': _bullNameController.text,
          'tagNo': _tagNoController.text,
          'lactationNo': _lactationNoController.text,
          'breed': selectedBreed, // Save the selected breed
        });
      } else {
        // Update existing record
        await _inseminationRecordsCollection.doc(record.id).update({
          'cowId': _cowIdController.text,
          'inseminationDate': inseminationDate,
          'semenBatch': _semenBatchController.text,
          'technician': _technicianController.text,
          'remarks': _remarksController.text.isNotEmpty ? _remarksController.text : null,
          'semenCompany': _semenCompanyController.text,
          'bullName': _bullNameController.text,
          'tagNo': _tagNoController.text,
          'lactationNo': _lactationNoController.text,
          'breed': selectedBreed, // Update the selected breed
        });
      }

      await _fetchRecordsFromFirestore(); // Refresh list
    } catch (e) {
      print("Error saving record: $e");
      // Optionally show a message to the user
    }
  }

  // Show dialog to add or edit record
  void _showRecordDialog({InseminationRecord? record}) {
    if (record != null) {
      // Populate fields for editing
      _cowIdController.text = record.cowId;
      _inseminationDateController.text = DateFormat('yyyy-MM-dd').format(record.inseminationDate);
      _semenBatchController.text = record.semenBatch;
      _technicianController.text = record.technician;
      _remarksController.text = record.remarks ?? '';
      _semenCompanyController.text = record.semenCompany ?? '';
      _bullNameController.text = record.bullName ?? '';
      _tagNoController.text = record.tagNo ?? '';
      _lactationNoController.text = record.lactationNo ?? '';
      selectedBreed = record.breed; // Populate selected breed
    } else {
      // Clear fields if adding new record
      _clearForm();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(record != null ? "Edit Insemination Record" : "Add Insemination Record"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  inputStyle("Cow ID", _cowIdController),
                  DropdownButtonFormField<String>(
                    value: selectedBreed,
                    decoration: InputDecoration(
                      labelText: "Select Breed",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    items: breeds.map((breed) {
                      return DropdownMenuItem(value: breed, child: Text(breed));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBreed = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please select a breed";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _inseminationDateController,
                    decoration: InputDecoration(
                      labelText: 'Insemination Date',
                      hintText: 'YYYY-MM-DD',
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: record != null ? record.inseminationDate : DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _inseminationDateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select Insemination Date';
                      }
                      return null;
                    },
                  ),
                  inputStyle("Semen Batch", _semenBatchController),
                  inputStyle("Semen Company", _semenCompanyController),
                  inputStyle("Bull Name", _bullNameController),
                  inputStyle("Tag No", _tagNoController),
                  inputStyle("Lactation No", _lactationNoController),
                  inputStyle("Technician", _technicianController),
                  TextFormField(
                    controller: _remarksController,
                    decoration: InputDecoration(
                      labelText: 'Remarks (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
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
                backgroundColor: const Color(0xFF4CAF50), // Pasture green button color
                foregroundColor: const Color(0xFFFFEB3B), // Soft yellow text color
              ),
              child: Text(record != null ? "Update" : "Add"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveRecordToFirestore(record: record);
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

  // Clear form fields
  void _clearForm() {
    _cowIdController.clear();
    _semenBatchController.clear();
    _inseminationDateController.clear();
    _remarksController.clear();
    _semenCompanyController.clear();
    _bullNameController.clear();
    _tagNoController.clear();
    _lactationNoController.clear();
    _technicianController.clear();
    selectedBreed = null; // Reset selected breed
  }

  @override
  void dispose() {
    // Dispose controllers
    _cowIdController.dispose();
    _semenBatchController.dispose();
    _inseminationDateController.dispose();
    _remarksController.dispose();
    _semenCompanyController.dispose();
    _bullNameController.dispose();
    _tagNoController.dispose();
    _lactationNoController.dispose();
    _technicianController.dispose();
    super.dispose();
  }

  // Widget to style input fields
  Widget inputStyle(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insemination Records"),
      ),
      body: ListView.builder(
        itemCount: _inseminationRecords.length,
        itemBuilder: (context, index) {
          final record = _inseminationRecords[index];
          return Card(
            child: ListTile(
              title: Text("Cow ID: ${record.cowId}"),
              subtitle: Text("Date: ${DateFormat('yyyy-MM-dd').format(record.inseminationDate)}"),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showRecordDialog(record: record);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRecordDialog(),
        tooltip: 'Add Record',
        child: const Icon(Icons.add),
      ),
    );
  }
}
