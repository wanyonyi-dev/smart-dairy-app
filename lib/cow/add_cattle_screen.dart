import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCattleScreen extends StatefulWidget {
  @override
  _AddCattleScreenState createState() => _AddCattleScreenState();
}

class _AddCattleScreenState extends State<AddCattleScreen> {
  bool isMale = true;
  TextEditingController earTagController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController weightController = TextEditingController(text: '0.0');
  TextEditingController noteController = TextEditingController();
  DateTime dateOfBirth = DateTime.now();
  DateTime dateOfEntry = DateTime.now();
  String selectedCattleObtained = '';
  String selectedBreed = '';
  String motherTagNo = '';
  String fatherTagNo = '';
  String selectedGroup = '';
  String selectedCattleStage = '';
  String selectedCattleStatus = '';
  String selectedCattleGeneralStatus = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Cattle"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Gender Toggle Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isMale ? Colors.white : Colors.black,
                      backgroundColor: isMale ? Colors.teal : Colors.grey[300],
                    ),
                    onPressed: () {
                      setState(() {
                        isMale = true;
                      });
                    },
                    child: Text("Male"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: !isMale ? Colors.white : Colors.black,
                      backgroundColor: !isMale ? Colors.teal : Colors.grey[300],
                    ),
                    onPressed: () {
                      setState(() {
                        isMale = false;
                      });
                    },
                    child: Text("Female"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Ear Tag Number Input
            _buildTextInputField("Ear Tag Number", earTagController, true),

            SizedBox(height: 20),

            // Select How Cattle was Obtained
            _buildDropdownField(
              "Select how cattle was obtained",
              selectedCattleObtained,
              ["Bought", "Born on Farm", "Gifted"],
              (newValue) {
                setState(() {
                  selectedCattleObtained = newValue!;
                });
              },
            ),

            SizedBox(height: 20),

            // Cattle's Breed (Optional)
            _buildDropdownField(
              "Cattle's Breed (Optional)",
              selectedBreed,
              ["Holstein", "Jersey", "Angus", "Other"],
              (newValue) {
                setState(() {
                  selectedBreed = newValue!;
                });
              },
            ),

            SizedBox(height: 20),

            // Name Input
            _buildTextInputField("Name", nameController, false),

            if (!isMale) ...[
              SizedBox(height: 20),

              // Cattle Stage Dropdown
              _buildDropdownField(
                "Cattle Stage",
                selectedCattleStage,
                ["Calf", "Weaner", "Heifer", "Cow"],
                (newValue) {
                  setState(() {
                    selectedCattleStage = newValue!;
                  });
                },
              ),

              SizedBox(height: 20),

              // Cattle Status Dropdown
              _buildDropdownField(
                "Cattle Status",
                selectedCattleStatus,
                ["Pregnant", "Lactating", "Non Lactating", "Lactating and Pregnant"],
                (newValue) {
                  setState(() {
                    selectedCattleStatus = newValue!;
                  });
                },
              ),

              SizedBox(height: 20),

              // Cattle General Status Dropdown
              _buildDropdownField(
                "Cattle General Status",
                selectedCattleGeneralStatus,
                ["None", "Milking Cow", "Dry", "Barren", "Anoestrus"],
                (newValue) {
                  setState(() {
                    selectedCattleGeneralStatus = newValue!;
                  });
                },
              ),
            ],

            SizedBox(height: 20),

            // Weight Input
            _buildTextInputField("Weight (kg)", weightController, false, keyboardType: TextInputType.number),

            SizedBox(height: 20),

            // Date of Birth Picker
            _buildDatePicker("Date of Birth", dateOfBirth, (pickedDate) {
              setState(() {
                dateOfBirth = pickedDate;
              });
            }),

            SizedBox(height: 20),

            // Date of Entry on the Farm Picker
            _buildDatePicker("Date of entry on the farm", dateOfEntry, (pickedDate) {
              setState(() {
                dateOfEntry = pickedDate;
              });
            }),

            SizedBox(height: 20),

            // Mother Tag Number Input
            _buildTextInputField("Mother Tag No", TextEditingController(text: motherTagNo), false),

            SizedBox(height: 20),

            // Father Tag Number Input
            _buildTextInputField("Father Tag No", TextEditingController(text: fatherTagNo), false),

            SizedBox(height: 20),

            // Cattle's Group (Optional)
            _buildDropdownField(
              "Cattle's Group (Optional)",
              selectedGroup,
              ["Group A", "Group B", "Group C"],
              (newValue) {
                setState(() {
                  selectedGroup = newValue!;
                });
              },
            ),

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

            SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: () async {
                // Prepare the data to be saved
                Map<String, dynamic> cattleData = {
                  'earTagNumber': earTagController.text,
                  'name': nameController.text,
                  'weight': double.tryParse(weightController.text) ?? 0.0,
                  'dateOfBirth': dateOfBirth,
                  'dateOfEntry': dateOfEntry,
                  'gender': isMale ? 'Male' : 'Female',
                  'cattleObtained': selectedCattleObtained,
                  'breed': selectedBreed,
                  'motherTagNo': motherTagNo,
                  'fatherTagNo': fatherTagNo,
                  'group': selectedGroup,
                  'stage': selectedCattleStage,
                  'status': selectedCattleStatus,
                  'generalStatus': selectedCattleGeneralStatus,
                  'note': noteController.text,
                };

                // Save to Firestore
                try {
                  await FirebaseFirestore.instance.collection('cattle').add(cattleData);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cattle record saved successfully!')),
                  );
                  // Optionally, you can navigate back after saving
                  Navigator.pop(context);
                } catch (e) {
                  // Handle errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving record: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInputField(String label, TextEditingController controller, bool isRequired, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label + (isRequired ? " *" : ""),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdownField(String label, String selectedValue, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue.isEmpty ? null : selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePicker(String label, DateTime selectedDate, Function(DateTime) onDateChanged) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                onDateChanged(pickedDate);
              }
            },
            child: Text(
              "$label: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
