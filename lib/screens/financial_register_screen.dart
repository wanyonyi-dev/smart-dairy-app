import 'package:flutter/material.dart';
import 'package:smart_dairy/unused/expense_form_screen.dart';
import 'package:smart_dairy/unused/income_form_screen.dart';

class FinancialRegisterScreen extends StatefulWidget {
  const FinancialRegisterScreen({super.key});

  @override
  _FinancialRegisterScreenState createState() => _FinancialRegisterScreenState();
}

class _FinancialRegisterScreenState extends State<FinancialRegisterScreen> {
  final List<Map<String, dynamic>> _expenseRecords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Financial Records"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: _expenseRecords.isEmpty
                ? const Center(
                    child: Text(
                      "No records found",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _expenseRecords.length,
                    itemBuilder: (context, index) {
                      final record = _expenseRecords[index];
                      return ListTile(
                        title: Text(record['description']),
                        subtitle: Text('Category: ${record['category']} | Amount: \$${record['amount'].toStringAsFixed(2)}'),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRecordDialog();
        },
        backgroundColor: Colors.tealAccent[400],
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRecordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Record"),
          actions: [
            TextButton(
              child: const Text("Add Expense"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExpenseFormScreen(onSave: (category, description, amount) {
                    setState(() {
                      _expenseRecords.add({
                        'category': category,
                        'description': description,
                        'amount': amount,
                      });
                    });
                  })),
                );
              },
            ),
            TextButton(
              child: const Text("Add Income"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IncomeFormScreen(onSave: (type, description, amount, date) {
                    setState(() {
                      _expenseRecords.add({
                        'category': type,
                        'description': description,
                        'amount': amount,
                        'date': date.toIso8601String(),
                      });
                    });
                  })),
                );
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
