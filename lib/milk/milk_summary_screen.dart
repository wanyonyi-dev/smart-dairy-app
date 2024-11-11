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

class MilkSummaryScreen extends StatefulWidget {
  const MilkSummaryScreen({Key? key}) : super(key: key);

  @override
  _MilkSummaryScreenState createState() => _MilkSummaryScreenState();
}

class _MilkSummaryScreenState extends State<MilkSummaryScreen> {
  List<MilkRecord> _milkRecords = [];
  List<HealthRecord> _healthRecords = [];
  double _totalMilk = 0;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    final milkSnapshot = await FirebaseFirestore.instance.collection('milkRecords').get();
    final healthSnapshot = await FirebaseFirestore.instance.collection('healthRecords').get();

    setState(() {
      _milkRecords = milkSnapshot.docs
          .map((doc) => MilkRecord.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      _healthRecords = healthSnapshot.docs
          .map((doc) => HealthRecord.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      _totalMilk = _milkRecords.fold(0, (sum, record) => sum + record.amount);
    });
  }

  List<HealthRecord> _getHealthRecordsForCow(String cowName) {
    return _healthRecords.where((record) => record.cowName == cowName).toList();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> sessionTotals = {};
    
    for (var record in _milkRecords) {
      sessionTotals[record.session] = (sessionTotals[record.session] ?? 0) + record.amount;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Milk Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Total Milk: $_totalMilk Litres',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: sessionTotals.length,
                itemBuilder: (context, index) {
                  String session = sessionTotals.keys.elementAt(index);
                  return ListTile(
                    title: Text(session),
                    subtitle: Text('${sessionTotals[session]} Litres'),
                    trailing: Text(
                      _getHealthRecordsForCow(session).isNotEmpty
                          ? 'Health Issues: ${_getHealthRecordsForCow(session).map((e) => e.condition).join(', ')}'
                          : 'No Health Issues',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
