import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseFormScreen extends StatelessWidget {
  final Function(String, String, double) onSave;

  ExpenseFormScreen({required this.onSave});

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final CollectionReference _expensesCollection = FirebaseFirestore.instance.collection('expenses'); // Firestore collection reference

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: const Color(0xFF66BB6A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              label: 'Category',
              controller: _categoryController,
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              label: 'Description',
              controller: _descriptionController,
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              label: 'Amount',
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                final category = _categoryController.text;
                final description = _descriptionController.text;
                final amount = double.tryParse(_amountController.text) ?? 0.0;

                // Input validation
                if (category.isNotEmpty && description.isNotEmpty && amount > 0.0) {
                  try {
                    // Save to Firestore
                    await _expensesCollection.add({
                      'category': category,
                      'description': description,
                      'amount': amount,
                      'timestamp': FieldValue.serverTimestamp(), // Optional: Use server timestamp
                    });

                    // Call the onSave function if needed
                    onSave(category, description, amount);

                    // Go back to the previous screen
                    Navigator.pop(context);
                  } catch (e) {
                    // Handle errors if needed
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: Text('Failed to save expense: $e'),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66BB6A),
                textStyle: const TextStyle(
                  color: Color(0xFFFFEB3B),
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text("Save Expense"),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a consistent TextField style
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
