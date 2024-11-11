import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeFormScreen extends StatelessWidget {
  final Function(String, String, double, DateTime) onSave;

  IncomeFormScreen({required this.onSave});

  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final CollectionReference _incomesCollection = FirebaseFirestore.instance.collection('incomes'); // Firestore collection reference

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Income"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Income Type Field
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: 'Income Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Circular border radius
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Description Field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Circular border radius
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Amount Field
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Circular border radius
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Date Field
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Circular border radius
                ),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  _dateController.text = pickedDate.toIso8601String().split('T').first;
                }
              },
            ),
            const SizedBox(height: 24.0),

            // Save Income Button
            ElevatedButton(
              onPressed: () async {
                final type = _typeController.text;
                final description = _descriptionController.text;
                final amount = double.tryParse(_amountController.text);
                final date = DateTime.tryParse(_dateController.text);

                // Input validation
                if (type.isNotEmpty && description.isNotEmpty && amount != null && amount > 0 && date != null) {
                  try {
                    // Save to Firestore
                    await _incomesCollection.add({
                      'type': type,
                      'description': description,
                      'amount': amount,
                      'date': date.toIso8601String(),
                    });

                    // Call the onSave function if needed
                    onSave(type, description, amount, date);

                    // Go back to the previous screen
                    Navigator.pop(context);
                  } catch (e) {
                    // Handle errors if needed
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: Text('Failed to save income: $e'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  // Show validation error
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Validation Error'),
                      content: const Text('Please enter valid data.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text("Save Income"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Matching the style of Expense record
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
