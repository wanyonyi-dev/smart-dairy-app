import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../models/calving_record.dart';

class CalvingRegisterPage extends StatefulWidget {
  const CalvingRegisterPage({super.key});

  @override
  _CalvingRegisterPageState createState() => _CalvingRegisterPageState();
}

class _CalvingRegisterPageState extends State<CalvingRegisterPage> {
  // Reference to Firestore collection
  final CollectionReference _calvingCollection = FirebaseFirestore.instance.collection('calving_records');

  // List to hold calving records
  final List<CalvingRecord> _calvingRecords = [];

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cowIdController = TextEditingController();
  final TextEditingController _calfIdController = TextEditingController();
  final TextEditingController _calvingDateController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  String? _calvingOutcome;
  int? _editIndex;

  @override
  void initState() {
    super.initState();
    _fetchCalvingRecords(); // Fetch records on initialization
  }

  @override
  void dispose() {
    // Dispose controllers
    _cowIdController.dispose();
    _calfIdController.dispose();
    _calvingDateController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  // Clear the form fields
  void _clearForm() {
    _cowIdController.clear();
    _calfIdController.clear();
    _calvingDateController.clear();
    _remarksController.clear();
    _calvingOutcome = null;
    _editIndex = null;
  }

  // Fetch calving records from Firestore
  Future<void> _fetchCalvingRecords() async {
    QuerySnapshot snapshot = await _calvingCollection.get();
    setState(() {
      _calvingRecords.clear(); // Clear existing records
      for (var doc in snapshot.docs) {
        _calvingRecords.add(CalvingRecord(
          id: doc.id, // Set document ID
          cowId: doc['cowId'],
          calvingDate: (doc['calvingDate'] as Timestamp).toDate(),
          calfId: doc['calfId'],
          calvingOutcome: doc['calvingOutcome'],
          remarks: doc['remarks'],
        ));
      }
    });
  }

  // Function to add or edit a calving record
  Future<void> _saveCalvingRecord({bool isEdit = false}) async {
    if (_formKey.currentState!.validate()) {
      CalvingRecord record = CalvingRecord(
        cowId: _cowIdController.text,
        calvingDate: DateFormat('yyyy-MM-dd').parse(_calvingDateController.text),
        calfId: _calfIdController.text,
        calvingOutcome: _calvingOutcome!,
        remarks: _remarksController.text.isNotEmpty ? _remarksController.text : null,
      );

      if (isEdit) {
        // Update existing record in Firestore
        await _calvingCollection.doc(_calvingRecords[_editIndex!].id).update({
          'cowId': record.cowId,
          'calvingDate': record.calvingDate,
          'calfId': record.calfId,
          'calvingOutcome': record.calvingOutcome,
          'remarks': record.remarks,
        });
        setState(() {
          _calvingRecords[_editIndex!] = record; // Update local list
        });
      } else {
        // Add new record to Firestore
        DocumentReference docRef = await _calvingCollection.add({
          'cowId': record.cowId,
          'calvingDate': record.calvingDate,
          'calfId': record.calfId,
          'calvingOutcome': record.calvingOutcome,
          'remarks': record.remarks,
        });
        setState(() {
          // Add the generated ID from Firestore to the local list
          record.id = docRef.id;
          _calvingRecords.add(record);
        });
      }

      _clearForm();
      Navigator.of(context).pop();
    }
  }

  // Show dialog to add or edit a record
  void _showRecordDialog({bool isEdit = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Calving Record" : "Add Calving Record"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildCowIdField(),
                  const SizedBox(height: 10.0), // Spacing between fields
                  _buildCalvingDateField(),
                  const SizedBox(height: 10.0), // Spacing between fields
                  _buildCalfIdField(),
                  const SizedBox(height: 10.0), // Spacing between fields
                  _buildCalvingOutcomeDropdown(),
                  const SizedBox(height: 10.0), // Spacing between fields
                  _buildRemarksField(),
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
                backgroundColor: const Color(0xFF66BB6A), // Green button background
                foregroundColor: const Color(0xFFFFFFFF), // White button text
              ),
              onPressed: () => _saveCalvingRecord(isEdit: isEdit),
              child: Text(isEdit ? "Update" : "Add"),
            ),
          ],
        );
      },
    );
  }

  // Function to edit a record
  void _editRecord(int index) {
    setState(() {
      _editIndex = index;
      _cowIdController.text = _calvingRecords[index].cowId;
      _calvingDateController.text = DateFormat('yyyy-MM-dd').format(_calvingRecords[index].calvingDate);
      _calfIdController.text = _calvingRecords[index].calfId;
      _calvingOutcome = _calvingRecords[index].calvingOutcome;
      _remarksController.text = _calvingRecords[index].remarks ?? '';
    });
    _showRecordDialog(isEdit: true);
  }

  // Helper widget for Cow ID field
  Widget _buildCowIdField() {
    return TextFormField(
      controller: _cowIdController,
      decoration: InputDecoration(
        labelText: 'Cow ID',
        labelStyle: const TextStyle(color: Color(0xFF66BB6A)), // Green label text color
        hintText: 'Enter Cow ID', // Added hint text
        hintStyle: const TextStyle(color: Colors.grey), // Hint text in gray
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0), // Circular border radius
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Cow ID';
        }
        return null;
      },
    );
  }

  // Helper widget for Calving Date field
  Widget _buildCalvingDateField() {
    return TextFormField(
      controller: _calvingDateController,
      decoration: InputDecoration(
        labelText: 'Calving Date',
        labelStyle: const TextStyle(color: Color(0xFF66BB6A)), // Green label text color
        hintText: 'YYYY-MM-DD',
        hintStyle: const TextStyle(color: Colors.grey), // Hint text in gray
        suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF66BB6A)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0), // Circular border radius
        ),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            _calvingDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select Calving Date';
        }
        return null;
      },
    );
  }

  // Helper widget for Calf ID field
  Widget _buildCalfIdField() {
    return TextFormField(
      controller: _calfIdController,
      decoration: InputDecoration(
        labelText: 'Calf ID',
        labelStyle: const TextStyle(color: Color(0xFF66BB6A)), // Green label text color
        hintText: 'Enter Calf ID', // Added hint text
        hintStyle: const TextStyle(color: Colors.grey), // Hint text in gray
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0), // Circular border radius
        ),
      ),
    );
  }

  // Helper widget for Calving Outcome dropdown
  Widget _buildCalvingOutcomeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Calving Outcome',
        labelStyle: const TextStyle(color: Color(0xFF66BB6A)), // Green label text color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0), // Circular border radius
        ),
      ),
      value: _calvingOutcome,
      items: ['Successful', 'Stillbirth', 'Dystocia'].map((String outcome) {
        return DropdownMenuItem<String>(
          value: outcome,
          child: Text(outcome),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _calvingOutcome = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select Calving Outcome';
        }
        return null;
      },
    );
  }

  // Helper widget for Remarks field
  Widget _buildRemarksField() {
    return TextFormField(
      controller: _remarksController,
      decoration: InputDecoration(
        labelText: 'Remarks',
        labelStyle: const TextStyle(color: Color(0xFF66BB6A)), // Green label text color
        hintText: 'Enter any remarks (optional)', // Added hint text
        hintStyle: const TextStyle(color: Colors.grey), // Hint text in gray
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0), // Circular border radius
        ),
      ),
      maxLines: 3, // Allow multiple lines for remarks
    );
  }

  // Displaying the list of records
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calving Register'),
        backgroundColor: const Color(0xFF66BB6A), // Green app bar
      ),
      body: ListView.builder(
        itemCount: _calvingRecords.length,
        itemBuilder: (context, index) {
          final record = _calvingRecords[index];
          return ListTile(
            title: Text('Cow ID: ${record.cowId}, Calving Outcome: ${record.calvingOutcome}'),
            subtitle: Text('Calving Date: ${DateFormat('yyyy-MM-dd').format(record.calvingDate)}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editRecord(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF66BB6A), // Green button background
        onPressed: () => _showRecordDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
