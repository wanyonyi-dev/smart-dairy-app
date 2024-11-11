// lib/pages/breeding_records_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BreedingRecordsPage extends StatefulWidget {
  const BreedingRecordsPage({super.key});

  @override
  _BreedingRecordsPageState createState() => _BreedingRecordsPageState();
}

class _BreedingRecordsPageState extends State<BreedingRecordsPage> {
  // Lists to hold fetched records
  List<Map<String, dynamic>> heatRecords = [];
  List<Map<String, dynamic>> calvingRecords = [];
  List<Map<String, dynamic>> inseminationRecords = [];

  @override
  void initState() {
    super.initState();
    _fetchRecords(); // Fetch records on initialization
  }

  // Fetch records from Firestore
  Future<void> _fetchRecords() async {
    // Fetch heat records
    final heatSnapshot = await FirebaseFirestore.instance.collection('heat_records').get();
    heatRecords = heatSnapshot.docs.map((doc) => {
      'cowId': doc['cowId'],
      'heatDate': (doc['heatDate'] as Timestamp).toDate().toString().split(' ')[0], // Format date
      'observations': doc['observations'],
    }).toList();

    // Fetch calving records
    final calvingSnapshot = await FirebaseFirestore.instance.collection('calving_records').get();
    calvingRecords = calvingSnapshot.docs.map((doc) => {
      'cowId': doc['cowId'],
      'calvingDate': (doc['calvingDate'] as Timestamp).toDate().toString().split(' ')[0], // Format date
      'calfGender': doc['calfGender'],
    }).toList();

    // Fetch insemination records
    final inseminationSnapshot = await FirebaseFirestore.instance.collection('insemination_records').get();
    inseminationRecords = inseminationSnapshot.docs.map((doc) => {
      'cowId': doc['cowId'],
      'inseminationDate': (doc['inseminationDate'] as Timestamp).toDate().toString().split(' ')[0], // Format date
      'semenBatch': doc['semenBatch'],
    }).toList();

    setState(() {}); // Refresh UI
  }

  // Generate a PDF file with breeding records
  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Breeding Records', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Heat Records:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Table.fromTextArray(
              headers: ['Cow ID', 'Heat Date', 'Observations'],
              data: heatRecords.map((record) {
                return [record['cowId'], record['heatDate'], record['observations']];
              }).toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Calving Records:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Table.fromTextArray(
              headers: ['Cow ID', 'Calving Date', 'Calf Gender'],
              data: calvingRecords.map((record) {
                return [record['cowId'], record['calvingDate'], record['calfGender']];
              }).toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Insemination Records:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Table.fromTextArray(
              headers: ['Cow ID', 'Insemination Date', 'Semen Batch'],
              data: inseminationRecords.map((record) {
                return [record['cowId'], record['inseminationDate'], record['semenBatch']];
              }).toList(),
            ),
          ],
        ),
      ),
    );

    // Get the directory to save the PDF
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/breeding_records.pdf");

    // Save the PDF file
    await file.writeAsBytes(await pdf.save());

    // Show a snackbar with the download location
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF generated and saved to ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breeding Records'),
        backgroundColor: const Color(0xFF66BB6A), // Green AppBar color
      ),
      body: Container(
        color: const Color(0xFFFFFFFF), // White background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            // Record download button
            ElevatedButton(
              onPressed: _generatePdf,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Button text color
                backgroundColor: const Color(0xFF66BB6A), // Green button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Rounded corners for the button
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0), // Button padding
              ),
              child: const Text(
                'Download Breeding Records as PDF',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16.0),
            // Display records
            Expanded(
              child: ListView(
                children: [
                  if (heatRecords.isNotEmpty) ...[
                    const Text('Heat Records:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ...heatRecords.map((record) => ListTile(
                      title: Text('Cow ID: ${record['cowId']}'),
                      subtitle: Text('Heat Date: ${record['heatDate']}, Observations: ${record['observations']}'),
                    )),
                  ],
                  if (calvingRecords.isNotEmpty) ...[
                    const Text('Calving Records:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ...calvingRecords.map((record) => ListTile(
                      title: Text('Cow ID: ${record['cowId']}'),
                      subtitle: Text('Calving Date: ${record['calvingDate']}, Calf Gender: ${record['calfGender']}'),
                    )),
                  ],
                  if (inseminationRecords.isNotEmpty) ...[
                    const Text('Insemination Records:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ...inseminationRecords.map((record) => ListTile(
                      title: Text('Cow ID: ${record['cowId']}'),
                      subtitle: Text('Insemination Date: ${record['inseminationDate']}, Semen Batch: ${record['semenBatch']}'),
                    )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}