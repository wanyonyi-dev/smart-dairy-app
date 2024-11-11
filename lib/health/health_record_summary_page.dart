import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthRecordsSummaryPage extends StatefulWidget {
  const HealthRecordsSummaryPage({super.key});

  @override
  _HealthRecordsSummaryPageState createState() => _HealthRecordsSummaryPageState();
}

class _HealthRecordsSummaryPageState extends State<HealthRecordsSummaryPage> {
  int totalVaccinations = 0;
  int totalTreatments = 0;
  int totalDewormed = 0;

  @override
  void initState() {
    super.initState();
    _fetchRecords(); // Fetch records when the page is initialized
  }

  // Fetch health records from Firestore
  Future<void> _fetchRecords() async {
    final snapshot = await FirebaseFirestore.instance.collection('health_records').get();
    int vaccinations = 0;
    int treatments = 0;
    int dewormed = 0;

    for (var doc in snapshot.docs) {
      vaccinations += (doc['vaccinations'] ?? 0) as int; // Cast to int
      treatments += (doc['treatments'] ?? 0) as int; // Cast to int
      dewormed += (doc['dewormed'] ?? 0) as int; // Cast to int
    }

    setState(() {
      totalVaccinations = vaccinations;
      totalTreatments = treatments;
      totalDewormed = dewormed;
    });
  }

  // Save health records to Firestore
  Future<void> _saveRecord() async {
    await FirebaseFirestore.instance.collection('health_records').add({
      'vaccinations': totalVaccinations + 1, // Example of incrementing the total
      'treatments': totalTreatments,
      'dewormed': totalDewormed,
      'timestamp': FieldValue.serverTimestamp(), // Store a timestamp for record keeping
    });

    // Refresh the records after saving
    _fetchRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Records Summary"),
        backgroundColor: const Color(0xFF66BB6A), // App bar color
      ),
      body: Container(
        color: const Color(0xFFFFFFFF), // Background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Summary for Date Range",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text("Vaccinations"),
              subtitle: Text("Total: $totalVaccinations Vaccinations"),
            ),
            ListTile(
              title: const Text("Treatments"),
              subtitle: Text("Total: $totalTreatments Treatments"),
            ),
            ListTile(
              title: const Text("Deworming"),
              subtitle: Text("Total: $totalDewormed Dewormed"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRecord, // Save the record when the button is pressed
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFFFFEB3B), 
                backgroundColor: const Color(0xFF66BB6A), // Button text color
              ),
              child: const Text("Save Record"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle download/export functionality
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFFFFEB3B), 
                backgroundColor: const Color(0xFF66BB6A), // Button text color
              ),
              child: const Text("Download Report"),
            ),
          ],
        ),
      ),
    );
  }
}
