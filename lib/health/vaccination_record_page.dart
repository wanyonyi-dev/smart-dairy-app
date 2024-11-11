import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VaccinationRecordsPage extends StatefulWidget {
  const VaccinationRecordsPage({super.key});

  @override
  _VaccinationRecordsPageState createState() => _VaccinationRecordsPageState();
}

class _VaccinationRecordsPageState extends State<VaccinationRecordsPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedAnimal;
  DateTime? vaccinationDate;
  String? vaccineType;
  double? dosage;
  DateTime? nextVaccinationDue;
  String? vetName;
  String? notes;

  final TextEditingController _vaccinationDateController = TextEditingController();
  final TextEditingController _nextVaccinationDueController = TextEditingController();

  @override
  void dispose() {
    _vaccinationDateController.dispose();
    _nextVaccinationDueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vaccination Records"),
        backgroundColor: const Color(0xFF66BB6A), // AppBar color
      ),
      body: Container(
        color: const Color(0xFFFFFFFF), // Background color
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Select Animal",
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Circular border radius
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
              const SizedBox(height: 16.0), // Spacing between fields
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Vaccine Type",
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Circular border radius
                  ),
                ),
                onSaved: (value) {
                  vaccineType = value;
                },
                style: const TextStyle(fontSize: 16.0), // Text field text size
                maxLines: 1,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the vaccine type'
                    : null,
              ),
              const SizedBox(height: 16.0), // Spacing between fields
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Dosage",
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Circular border radius
                  ),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  dosage = double.tryParse(value!);
                },
                style: const TextStyle(fontSize: 16.0), // Text field text size
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the dosage';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid dosage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Spacing between fields
              // Vaccination Date Text Field
              TextFormField(
                readOnly: true, // Make the TextField read-only
                decoration: InputDecoration(
                  labelText: "Vaccination Date",
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Circular border radius
                  ),
                  suffixIcon: const Icon(Icons.calendar_today), // Calendar icon
                ),
                controller: _vaccinationDateController,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: vaccinationDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      vaccinationDate = pickedDate;
                      _vaccinationDateController.text =
                          "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                validator: (value) {
                  if (vaccinationDate == null) {
                    return "Please select a vaccination date";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Spacing between fields
              // Next Vaccination Due Text Field
              TextFormField(
                readOnly: true, // Make the TextField read-only
                decoration: InputDecoration(
                  labelText: "Next Vaccination Due",
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Circular border radius
                  ),
                  suffixIcon: const Icon(Icons.calendar_today), // Calendar icon
                ),
                controller: _nextVaccinationDueController,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: nextVaccinationDue ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      nextVaccinationDue = pickedDate;
                      _nextVaccinationDueController.text =
                          "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                validator: (value) {
                  if (nextVaccinationDue == null) {
                    return "Please select a next vaccination due date";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Spacing between fields
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Vet/Officer Name",
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Circular border radius
                  ),
                ),
                onSaved: (value) {
                  vetName = value;
                },
                style: const TextStyle(fontSize: 16.0), // Text field text size
                maxLines: 1,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the vet/officer name'
                    : null,
              ),
              const SizedBox(height: 16.0), // Spacing between fields
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Notes",
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Circular border radius
                  ),
                ),
                onSaved: (value) {
                  notes = value;
                },
                style: const TextStyle(fontSize: 16.0), // Text field text size
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    try {
                      // Create an instance of the VaccinationRecordService to save the record
                      await VaccinationRecordService().addVaccinationRecord(
                        selectedAnimal: selectedAnimal!,
                        vaccinationDate: vaccinationDate!,
                        vaccineType: vaccineType!,
                        dosage: dosage!,
                        nextVaccinationDue: nextVaccinationDue!,
                        vetName: vetName!,
                        notes: notes ?? '',
                      );

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Record saved successfully!")),
                      );

                      // Clear the form
                      _formKey.currentState!.reset();
                      _vaccinationDateController.clear();
                      _nextVaccinationDueController.clear();
                      setState(() {
                        selectedAnimal = null;
                        vaccinationDate = null;
                        nextVaccinationDue = null;
                        vaccineType = null;
                        dosage = null;
                        vetName = null;
                        notes = null;
                      });
                    } catch (e) {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error saving record: $e")),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFEB3B), // Button text color
                  backgroundColor: const Color(0xFF66BB6A), // Button background color
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

class VaccinationRecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addVaccinationRecord({
    required String selectedAnimal,
    required DateTime vaccinationDate,
    required String vaccineType,
    required double dosage,
    required DateTime nextVaccinationDue,
    required String vetName,
    required String notes,
  }) async {
    String userId = _auth.currentUser!.uid; // Get current user's UID

    await _firestore.collection('vaccination_records').add({
      'user_id': userId, // Link to the user's UID
      'animal_id': selectedAnimal,
      'vaccination_date': vaccinationDate,
      'vaccine_type': vaccineType,
      'dosage': dosage,
      'next_vaccination_due': nextVaccinationDue,
      'vet_name': vetName,
      'notes': notes,
      'created_at': Timestamp.now(), // Store when the record was created
    });
  }
}
