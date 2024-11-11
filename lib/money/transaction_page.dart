import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_dairy/money/new_transaction_page.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isIncomeSelected = true;
  String timeFilter = 'All Time';
  String typeFilter = 'All Types';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Toggle buttons for Income and Expense with Filter Icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Income button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isIncomeSelected = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isIncomeSelected ? Colors.teal : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                        child: Text(
                          'Income',
                          style: TextStyle(
                            color: isIncomeSelected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Expense button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isIncomeSelected = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: !isIncomeSelected ? Colors.teal : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                        child: Text(
                          'Expense',
                          style: TextStyle(
                            color: !isIncomeSelected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Filter Icon
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterDialog();
                  },
                ),
              ],
            ),
          ),

          // Display transactions based on selection and filter
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('transactions')
                  .where('type', isEqualTo: isIncomeSelected ? 'Income' : 'Expense')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/transaction_placeholder.png',
                          width: 120,
                          height: 120,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Click on the add button to add Transaction',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                // Display list of transactions
                final transactions = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    var transaction = transactions[index];
                    return ListTile(
                      title: Text(transaction['description'] ?? 'No description available'),
                      subtitle: Text('${transaction['date']} - ${transaction['amount']}'),
                      leading: Icon(
                        isIncomeSelected ? Icons.attach_money : Icons.money_off,
                        color: isIncomeSelected ? Colors.green : Colors.red,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTransactionPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  // Function to show filter dialog
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter By',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  // Time Filter Dropdown
                  DropdownButton<String>(
                    value: timeFilter,
                    items: [
                      'All Time',
                      'Last 7 Days',
                      'Current Month',
                      'Previous Month',
                      'Last 3 Months',
                      'Last 6 Months',
                      'Last 12 Months',
                      'Previous Year',
                      'Last 3 Years'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        timeFilter = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  // Type Filter Dropdown
                  DropdownButton<String>(
                    value: typeFilter,
                    items: [
                      'All Types',
                      'Milk Sale',
                      'Cattle Sale',
                      'Category Income',
                      'Others'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        typeFilter = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  // Reset and Apply Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            timeFilter = 'All Time';
                            typeFilter = 'All Types';
                          });
                        },
                        child: Text('Reset'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close filter dialog
                          setState(() {}); // Apply the filters
                        },
                        child: Text('Apply'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
