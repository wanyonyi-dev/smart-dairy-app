import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TreatmentRecordsPage extends StatefulWidget {
  const TreatmentRecordsPage({super.key});

  @override
  _TreatmentRecordsPageState createState() => _TreatmentRecordsPageState();
}

class _TreatmentRecordsPageState extends State<TreatmentRecordsPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedAnimal;
  DateTime? treatmentDate;
  String? condition;
  String? treatment;
  double? dosage;
  String? vetName;
  DateTime? followUpDate;
  String? recoveryStatus;
  String? notes;

  final TextEditingController _treatmentDateController = TextEditingController();
  final TextEditingController _followUpDateController = TextEditingController();

  @override
  void dispose() {
    _treatmentDateController.dispose();
    _followUpDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Treatment Records"),
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
                  labelText: "Condition/Diagnosis",
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Circular border radius
                  ),
                ),
                onSaved: (value) {
                  condition = value;
                },
                style: const TextStyle(fontSize: 16.0), // Text field text size
                maxLines: 1,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the condition/diagnosis'
                    : null,
              ),
              const SizedBox(height: 16.0), // Spacing between fields
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Treatment Administered",
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Circular border radius
                  ),
                ),
                onSaved: (value) {
                  treatment = value;
                },
                style: const TextStyle(fontSize: 16.0), // Text field text size
                maxLines: 1,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the treatment administered'
                    : null,
              ),
              const SizedBox(height: 16.0), // Spacing between fields
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Dosage/Medication",
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
              // Treatment Date Text Field
              TextFormField(
                readOnly: true, // Make the TextField read-only
                decoration: InputDecoration(
                  labelText: "Treatment Date",
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Circular border radius
                  ),
                  suffixIcon: const Icon(Icons.calendar_today), // Calendar icon
                ),
                controller: _treatmentDateController,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: treatmentDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      treatmentDate = pickedDate;
                      _treatmentDateController.text =
                          "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                validator: (value) {
                  if (treatmentDate == null) {
                    return "Please select a treatment date";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Spacing between fields
              // Follow-Up Date Text Field
              TextFormField(
                readOnly: true, // Make the TextField read-only
                decoration: InputDecoration(
                  labelText: "Follow-Up Date",
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Circular border radius
                  ),
                  suffixIcon: const Icon(Icons.calendar_today), // Calendar icon
                ),
                controller: _followUpDateController,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: followUpDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      followUpDate = pickedDate;
                      _followUpDateController.text =
                          "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                validator: (value) {
                  if (followUpDate == null) {
                    return "Please select a follow-up date";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Spacing between fields
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Recovery Status",
                  labelStyle: const TextStyle(color: Colors.black), // Label color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Circular border radius
                  ),
                ),
                items: ['Recovered', 'In Progress', 'Critical'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    recoveryStatus = value;
                  });
                },
                validator: (value) => value == null ? 'Please select recovery status' : null,
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
                      // Create an instance of the TreatmentRecordService to save the record
                      await TreatmentRecordService().addTreatmentRecord(
                        selectedAnimal: selectedAnimal!,
                        treatmentDate: treatmentDate!,
                        condition: condition!,
                        treatment: treatment!,
                        dosage: dosage!,
                        followUpDate: followUpDate!,
                        recoveryStatus: recoveryStatus!,
                        vetName: vetName!,
                        notes: notes ?? '',
                      );

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Record saved successfully!")),
                      );

                      // Clear the form
                      _formKey.currentState!.reset();
                      _treatmentDateController.clear();
                      _followUpDateController.clear();
                      setState(() {
                        selectedAnimal = null;
                        treatmentDate = null;
                        followUpDate = null;
                        condition = null;
                        treatment = null;
                        dosage = null;
                        vetName = null;
                        recoveryStatus = null;
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

class TreatmentRecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addTreatmentRecord({
    required String selectedAnimal,
    required DateTime treatmentDate,
    required String condition,
    required String treatment,
    required double dosage,
    required DateTime followUpDate,
    required String recoveryStatus,
    required String vetName,
    required String notes,
  }) async {
    String userId = _auth.currentUser!.uid; // Get current user's UID

    await _firestore.collection('treatment_records').add({
      'user_id': userId, // Link to the user's UID
      'animal_id': selectedAnimal,
      'treatment_date': treatmentDate,
      'condition': condition,
      'treatment': treatment,
      'dosage': dosage,
      'follow_up_date': followUpDate,
      'recovery_status': recoveryStatus,
      'vet_name': vetName,
      'notes': notes,
      'created_at': Timestamp.now(), // Store when the record was created
    });
  }
}
