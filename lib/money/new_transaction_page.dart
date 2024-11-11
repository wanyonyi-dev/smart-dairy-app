import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this import
import 'package:smart_dairy/money/expense_category.dart';
import 'package:smart_dairy/money/income_category_page.dart'; // Adjust the import as needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction App',
      home: NewTransactionPage(),
    );
  }
}

class NewTransactionPage extends StatefulWidget {
  @override
  _NewTransactionPageState createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController totalEarnController = TextEditingController();
  final TextEditingController receiptNoController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  String? selectedType;
  String transactionMode = 'Income'; // Default to Income mode
  List<String> incomeTypes = ['Milk Sales', 'Cattle Sale', 'Category Income', 'Other (Specify)'];
  List<String> expenseTypes = ['Category Expense', 'Other (Specify)'];

  @override
  void initState() {
    super.initState();
    dateController.text = '25-10-2024'; // Default date
  }

  void _navigateToCategoryPage(BuildContext context) async {
    final selectedCategory = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => transactionMode == 'Income' 
            ? IncomeCategoryPage() 
            : ExpenseCategoryPage(),
      ),
    );

    if (selectedCategory != null) {
      setState(() {
        categoryController.text = selectedCategory;
      });
    }
  }

  void _setTransactionMode(String mode) {
    setState(() {
      transactionMode = mode;
      selectedType = null;
      categoryController.clear();
    });
  }

  Future<void> _saveTransaction() async {
    if (totalEarnController.text.isEmpty || selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields.')),
      );
      return; // Exit if fields are not valid
    }

    // Prepare the transaction data
    Map<String, dynamic> transactionData = {
      'date': dateController.text,
      'totalEarn': double.tryParse(totalEarnController.text) ?? 0.0,
      'receiptNo': receiptNoController.text,
      'note': noteController.text,
      'type': transactionMode,
      'category': categoryController.text,
      'transactionType': selectedType,
    };

    // Save to Firestore
    try {
      await FirebaseFirestore.instance.collection('transactions').add(transactionData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction saved successfully!')),
      );
      // Optionally, clear fields or navigate back
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving transaction: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> types = transactionMode == 'Income' ? incomeTypes : expenseTypes;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Transaction'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _setTransactionMode('Income'),
                    child: Text('Income'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: transactionMode == 'Income' ? Colors.white : Colors.black, 
                      backgroundColor: transactionMode == 'Income' ? Colors.teal : Colors.grey[300],
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _setTransactionMode('Expense'),
                    child: Text('Expense'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: transactionMode == 'Expense' ? Colors.white : Colors.black, 
                      backgroundColor: transactionMode == 'Expense' ? Colors.teal : Colors.grey[300],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Date of ${transactionMode}*'),
              SizedBox(height: 5),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () {
                  // Open date picker if needed
                },
              ),
              SizedBox(height: 16),
              Text('${transactionMode} Type*'),
              SizedBox(height: 5),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_balance_wallet),
                  border: OutlineInputBorder(),
                ),
                value: selectedType,
                hint: Text('- Select ${transactionMode} Type -'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue;
                    if (newValue != 'Category Income' && newValue != 'Category Expense') {
                      categoryController.clear();
                    }
                  });
                },
                items: types.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              if (selectedType == 'Category Income' || selectedType == 'Category Expense') ...[
                Text('Select Category*'),
                SizedBox(height: 5),
                TextField(
                  controller: categoryController,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                    hintText: 'Click to select category',
                  ),
                  onTap: () {
                    _navigateToCategoryPage(context);
                  },
                ),
                SizedBox(height: 16),
              ],
              Text('Total ${transactionMode == 'Income' ? 'Earned' : 'Spent'}*'),
              SizedBox(height: 5),
              TextField(
                controller: totalEarnController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                  hintText: '0.0',
                ),
              ),
              SizedBox(height: 16),
              Text('Receipt No'),
              SizedBox(height: 5),
              TextField(
                controller: receiptNoController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.receipt),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('Note'),
              SizedBox(height: 5),
              TextField(
                controller: noteController,
                maxLines: 2,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveTransaction, // Call save method here
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Expense Category Screen
class ExpenseCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Category'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by Category name',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/expense_category_icon.png', height: 100), // Replace with your image
                    Text('Click on the add button to add Expense Category'),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Handle adding new expense category logic here
                Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseCategory()));
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
