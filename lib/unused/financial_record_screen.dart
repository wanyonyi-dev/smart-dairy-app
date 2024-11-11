// lib/screens/financial_record_screen.dart

import 'package:flutter/material.dart';

class FinancialRecordScreen extends StatelessWidget {
  final Function(String, String, double) onSave;

  const FinancialRecordScreen({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String category = categoryController.text;
                final String description = descriptionController.text;
                final double? amount = double.tryParse(amountController.text);

                if (category.isNotEmpty && description.isNotEmpty && amount != null) {
                  onSave(category, description, amount); // Call the onSave function
                }
              },
              child: const Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
