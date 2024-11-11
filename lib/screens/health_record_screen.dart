import 'package:flutter/material.dart';

class HealthRecordScreen extends StatelessWidget {
  const HealthRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Health Record'),
      ),
      // Set the background color to #FFFFFFF (white)
      backgroundColor: const Color(0xFFFFFFFF), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Cow ID'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Vaccination Date'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Treatment Details'),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              width: 300,
              decoration: BoxDecoration(
                // Set the button color to #66BB6A
                color: const Color(0xFF66BB6A), 
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  // Handle submission logic here
                  Navigator.of(context).pop(); // Navigation logic or save logic
                },
                child: const Text(
                  'Save Record',
                  // Set the button text color to #FFEB3B
                  style: TextStyle(fontSize: 20, color: Color(0xFFFFEB3B)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
