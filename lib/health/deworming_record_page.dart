import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DewormingRecordsPage extends StatefulWidget {
  const DewormingRecordsPage({super.key});

  @override
  _DewormingRecordsPageState createState() => _DewormingRecordsPageState();
}

class _DewormingRecordsPageState extends State<DewormingRecordsPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedAnimal;
  DateTime? dewormingDate;
  String? dewormerType;
  double? dosage;
  DateTime? nextDewormingDue;
  String? vetName;
  String? notes;

  final TextEditingController _dewormingDateController = TextEditingController();
  final TextEditingController _nextDewormingDueController = TextEditingController();

  @override
  void dispose() {
    _dewormingDateController.dispose();
    _nextDewormingDueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deworming Records"),
        backgroundColor: const Color(0xFF66BB6A),
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Select Animal",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                items: ['Cow 1', 'Cow 2', 'Cow 3'].map((animal) {
                  return DropdownMenuItem(value: animal, child: Text(animal));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAnimal = value;
                  });
                },
                validator: (value) => value == null ? 'Please select an animal' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                controller: _dewormingDateController,
                decoration: InputDecoration(
                  labelText: "Deworming Date",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dewormingDate = pickedDate;
                      _dewormingDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty ? 'Please select the deworming date' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Dewormer Type",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onSaved: (value) {
                  dewormerType = value;
                },
                validator: (value) => value == null || value.isEmpty ? 'Please enter the dewormer type' : null,
                style: const TextStyle(fontSize: 16.0),
                maxLines: 1,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Dosage",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  dosage = double.tryParse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the dosage';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid dosage';
                  }
                  return null;
                },
                style: const TextStyle(fontSize: 16.0),
                maxLines: 1,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                controller: _nextDewormingDueController,
                decoration: InputDecoration(
                  labelText: "Next Deworming Due",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      nextDewormingDue = pickedDate;
                      _nextDewormingDueController.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty ? 'Please select the next deworming due date' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Vet/Officer Name",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onSaved: (value) {
                  vetName = value;
                },
                validator: (value) => value == null || value.isEmpty ? 'Please enter the vet/officer name' : null,
                style: const TextStyle(fontSize: 16.0),
                maxLines: 1,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Notes",
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onSaved: (value) {
                  notes = value;
                },
                style: const TextStyle(fontSize: 16.0),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    try {
                      // Create an instance of the DewormingRecordService
                      DewormingRecordService dewormingRecordService = DewormingRecordService();

                      // Add deworming record to Firestore
                      await dewormingRecordService.addDewormingRecord(
                        animalId: selectedAnimal!,
                        dewormingDate: dewormingDate!,
                        dewormerType: dewormerType!,
                        dosage: dosage!,
                        nextDewormingDue: nextDewormingDue!,
                        vetName: vetName!,
                        notes: notes!,
                      );

                      // Show a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Deworming record saved successfully!")),
                      );

                      // Optionally, clear the form or navigate to another screen
                      _formKey.currentState!.reset();
                      _dewormingDateController.clear();
                      _nextDewormingDueController.clear();
                      setState(() {
                        selectedAnimal = null;
                        dewormingDate = null;
                        dewormerType = null;
                        dosage = null;
                        nextDewormingDue = null;
                        vetName = null;
                        notes = null;
                      });
                    } catch (error) {
                      // Handle errors, e.g., if there's an issue saving the record
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error saving record: $error")),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFEB3B),
                  backgroundColor: const Color(0xFF66BB6A),
                ),
                child: const Text("Save Record"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DewormingRecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to add a deworming record
  Future<void> addDewormingRecord({
    required String animalId,
    required DateTime dewormingDate,
    required String dewormerType,
    required double dosage,
    required DateTime nextDewormingDue,
    required String vetName,
    required String notes,
  }) async {
    String userId = _auth.currentUser!.uid; // Get current user's UID

    await _firestore.collection('deworming_records').add({
      'user_id': userId, // Link to the user's UID
      'animal_id': animalId,
      'deworming_date': dewormingDate,
      'dewormer_type': dewormerType,
      'dosage': dosage,
      'next_deworming_due': nextDewormingDue,
      'vet_name': vetName,
      'notes': notes,
      'created_at': Timestamp.now(), // Store when the record was created
    });
  }
}
