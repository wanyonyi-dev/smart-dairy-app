import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CowHealthScreen extends StatefulWidget {
  @override
  _CowHealthScreenState createState() => _CowHealthScreenState();
}

class _CowHealthScreenState extends State<CowHealthScreen> {
  final TextEditingController cowIdController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();

  Future<void> addHealthCondition() async {
    await FirebaseFirestore.instance.collection('cow_health').add({
      'cowId': cowIdController.text,
      'condition': conditionController.text,
      'date': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cow Health Logs")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cowIdController,
              decoration: InputDecoration(labelText: 'Cow ID'),
            ),
            TextField(
              controller: conditionController,
              decoration: InputDecoration(labelText: 'Health Condition'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addHealthCondition();
                Navigator.pop(context);
              },
              child: const Text("Add Condition"),
            ),
          ],
        ),
      ),
    );
  }
}
