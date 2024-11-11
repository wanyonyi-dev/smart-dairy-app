import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthRecord {
  final String cowId;
  final String cowName;
  final String condition; // Description of the health condition
  final DateTime date; // Date of the health record

  HealthRecord({
    required this.cowId,
    required this.cowName,
    required this.condition,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'cowId': cowId,
      'cowName': cowName,
      'condition': condition,
      'date': date.toIso8601String(),
    };
  }

  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      cowId: map['cowId'],
      cowName: map['cowName'],
      condition: map['condition'],
      date: DateTime.parse(map['date']),
    );
  }
}

class HealthRecordScreen extends StatefulWidget {
  const HealthRecordScreen({Key? key}) : super(key: key);

  @override
  _HealthRecordScreenState createState() => _HealthRecordScreenState();
}

class _HealthRecordScreenState extends State<HealthRecordScreen> {
  final TextEditingController _cowIdController = TextEditingController();
  final TextEditingController _cowNameController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  
  final CollectionReference _healthCollection = FirebaseFirestore.instance.collection('healthRecords');

  void _addHealthRecord() async {
    final String cowId = _cowIdController.text;
    final String cowName = _cowNameController.text;
    final String condition = _conditionController.text;

    if (cowId.isNotEmpty && cowName.isNotEmpty && condition.isNotEmpty) {
      final healthRecord = HealthRecord(
        cowId: cowId,
        cowName: cowName,
        condition: condition,
        date: DateTime.now(),
      );

      await _healthCollection.add(healthRecord.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Health record added successfully!')),
      );

      _cowIdController.clear();
      _cowNameController.clear();
      _conditionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record Cow Health"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cowIdController,
              decoration: const InputDecoration(labelText: 'Cow ID'),
            ),
            TextField(
              controller: _cowNameController,
              decoration: const InputDecoration(labelText: 'Cow Name'),
            ),
            TextField(
              controller: _conditionController,
              decoration: const InputDecoration(labelText: 'Health Condition'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addHealthRecord,
              child: const Text('Add Health Record'),
            ),
          ],
        ),
      ),
    );
  }
}
