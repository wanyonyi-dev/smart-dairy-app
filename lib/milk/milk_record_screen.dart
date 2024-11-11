import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MilkRecord {
  final String cowId;
  final String cowName;
  final String session; // Morning, Afternoon, Evening
  final double amount; // Amount of milk produced
  final DateTime date; // Date of the record
  final List<String>? healthConditions; // List of health condition IDs or descriptions

  MilkRecord({
    required this.cowId,
    required this.cowName,
    required this.session,
    required this.amount,
    required this.date,
    this.healthConditions,
  });

  Map<String, dynamic> toMap() {
    return {
      'cowId': cowId,
      'cowName': cowName,
      'session': session,
      'amount': amount,
      'date': date.toIso8601String(),
      'healthConditions': healthConditions,
    };
  }

  factory MilkRecord.fromMap(Map<String, dynamic> map) {
    return MilkRecord(
      cowId: map['cowId'],
      cowName: map['cowName'],
      session: map['session'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      healthConditions: List<String>.from(map['healthConditions'] ?? []),
    );
  }
}

class MilkRecordScreen extends StatefulWidget {
  const MilkRecordScreen({Key? key}) : super(key: key);

  @override
  _MilkRecordScreenState createState() => _MilkRecordScreenState();
}

class _MilkRecordScreenState extends State<MilkRecordScreen> {
  final TextEditingController _cowIdController = TextEditingController();
  final TextEditingController _cowNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  
  String _selectedSession = 'Morning';

  final CollectionReference _milkCollection = FirebaseFirestore.instance.collection('milkRecords');

  void _addMilkRecord() async {
    final String cowId = _cowIdController.text;
    final String cowName = _cowNameController.text;
    final double amount = double.tryParse(_amountController.text) ?? 0.0;

    if (cowId.isNotEmpty && cowName.isNotEmpty && amount > 0) {
      final milkRecord = MilkRecord(
        cowId: cowId,
        cowName: cowName,
        session: _selectedSession,
        amount: amount,
        date: DateTime.now(),
      );

      await _milkCollection.add(milkRecord.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Milk record added successfully!')),
      );

      _cowIdController.clear();
      _cowNameController.clear();
      _amountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record Milk Production"),
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
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount (Litres)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _selectedSession,
              items: const [
                DropdownMenuItem(value: 'Morning', child: Text('Morning')),
                DropdownMenuItem(value: 'Afternoon', child: Text('Afternoon')),
                DropdownMenuItem(value: 'Evening', child: Text('Evening')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSession = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMilkRecord,
              child: const Text('Add Milk Record'),
            ),
          ],
        ),
      ),
    );
  }
}
