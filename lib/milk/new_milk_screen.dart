import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_dairy/cow/cow_search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: NewMilkScreen(),
    routes: {
      '/cattleTag': (context) => CattleTagScreen(),
    },
  ));
}

class NewMilkScreen extends StatefulWidget {
  @override
  _NewMilkScreenState createState() => _NewMilkScreenState();
}

class _NewMilkScreenState extends State<NewMilkScreen> {
  bool isBulkMilk = true; // Flag to determine the milk type
  DateTime selectedDate = DateTime.now();
  TextEditingController amController = TextEditingController();
  TextEditingController noonController = TextEditingController();
  TextEditingController pmController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController cattleTagController = TextEditingController(); // Controller for cattle tag
  double totalMilkProduct = 0.0;

  @override
  void initState() {
    super.initState();
    amController.text = '';
    noonController.text = '';
    pmController.text = '';
  }

  void _updateTotalMilkProduct() {
    double am = double.tryParse(amController.text) ?? 0.0;
    double noon = double.tryParse(noonController.text) ?? 0.0;
    double pm = double.tryParse(pmController.text) ?? 0.0;

    setState(() {
      totalMilkProduct = am + noon + pm;
    });
  }

  Future<void> _saveRecord() async {
    if (isBulkMilk || (cattleTagController.text.isNotEmpty)) {
      try {
        await FirebaseFirestore.instance.collection('milkRecords').add({
          'isBulkMilk': isBulkMilk,
          'date': selectedDate,
          'am': double.tryParse(amController.text) ?? 0.0,
          'noon': double.tryParse(noonController.text) ?? 0.0,
          'pm': double.tryParse(pmController.text) ?? 0.0,
          'totalMilkProduct': totalMilkProduct,
          'cattleTag': isBulkMilk ? null : cattleTagController.text,
          'note': noteController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Record saved successfully!'),
          backgroundColor: Colors.green,
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save record: $e'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all required fields.'),
        backgroundColor: Colors.orange,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Milk"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Milk Type Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isBulkMilk ? Colors.white : Colors.black,
                      backgroundColor: isBulkMilk ? Colors.teal : Colors.grey[300],
                    ),
                    onPressed: () {
                      setState(() {
                        isBulkMilk = true;
                      });
                    },
                    child: Text("Bulk Milk"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: !isBulkMilk ? Colors.white : Colors.black,
                      backgroundColor: !isBulkMilk ? Colors.teal : Colors.grey[300],
                    ),
                    onPressed: () {
                      setState(() {
                        isBulkMilk = false;
                      });
                    },
                    child: Text("Individual Milk"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Date Picker
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  controller: TextEditingController(
                    text: DateFormat('dd-MM-yyyy').format(selectedDate),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Cattle Tag No Field (shown only for Individual Milk)
            if (!isBulkMilk)
              GestureDetector(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => CowSearchPage()));
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: cattleTagController,
                    decoration: InputDecoration(
                      labelText: "Cattle Tag No",
                      prefixIcon: Icon(Icons.tag),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),

            // Milk Input Fields (AM, Noon, PM)
            Row(
              children: [
                Expanded(
                  child: _buildMilkInputField("AM", amController),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildMilkInputField("Noon", noonController),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildMilkInputField("PM", pmController),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Total Milk Product (Read-only)
            _buildReadOnlyField("Total Milk Product", totalMilkProduct.toStringAsFixed(2)),

            SizedBox(height: 20),

            // Total Used (Read-only)
            _buildReadOnlyField("Total Used", "0.0"),

            SizedBox(height: 20),

            // Note Field
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: "Note",
                prefixIcon: Icon(Icons.edit),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            Spacer(),

            // Save Button
            ElevatedButton(
              onPressed: _saveRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
              ),
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilkInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter amount', // Set hint text
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        prefixIcon: Icon(Icons.local_drink),
      ),
      onChanged: (value) {
        _updateTotalMilkProduct(); // Update total whenever input changes
      },
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        prefixIcon: Icon(Icons.local_drink),
        suffixText: value,
      ),
    );
  }
}

class CattleTagScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cattle Tag List"),
      ),
      body: Center(
        child: Text("Display cattle tags here"),
      ),
    );
  }
}
