import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRecordScreen extends StatelessWidget {
  final TextEditingController cowIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController sessionController = TextEditingController();

  Future<void> saveRecord() async {
    await FirebaseFirestore.instance.collection('milk_records').add({
      'cowId': cowIdController.text,
      'amount': double.parse(amountController.text),
      'session': sessionController.text,
      'date': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Milk Record")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cowIdController,
              decoration: InputDecoration(labelText: 'Cow ID'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount (L)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: sessionController,
              decoration: InputDecoration(labelText: 'Milking Session (e.g., Morning)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveRecord();
                Navigator.pop(context);
              },
              child: const Text("Save Record"),
            ),
          ],
        ),
      ),
    );
  }
}
