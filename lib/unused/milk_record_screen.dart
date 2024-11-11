import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class MilkRecordScreen extends StatefulWidget {
  const MilkRecordScreen({super.key});

  @override
  _MilkRecordScreenState createState() => _MilkRecordScreenState();
}

class _MilkRecordScreenState extends State<MilkRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  String? cowId;
  DateTime? milkingDate;
  double? milkQuantity;
  String? milkingSession;
  String? milkerName;
  String? storageMethod;
  String? healthNotes;
  String? remarks;

  // Reference to Firestore
  final CollectionReference _milkRecordsCollection =
      FirebaseFirestore.instance.collection('milk_records');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Milk Record"),
        backgroundColor: const Color(0xFF66BB6A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(
                      label: "Cow ID",
                      onSaved: (value) {
                        cowId = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the cow ID";
                        }
                        return null;
                      },
                    ),
                    _buildDateField(
                      label: "Milking Date",
                      hintText: "Select Milking Date",
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: milkingDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            milkingDate = pickedDate;
                          });
                        }
                      },
                    ),
                    _buildTextField(
                      label: "Milk Quantity (Liters)",
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        milkQuantity = double.tryParse(value!);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || double.tryParse(value) == null) {
                          return "Please enter a valid quantity";
                        }
                        return null;
                      },
                    ),
                    _buildDropdownField(
                      label: "Milking Session",
                      items: ['Morning', 'Afternoon', 'Evening'],
                      onChanged: (value) {
                        setState(() {
                          milkingSession = value;
                        });
                      },
                    ),
                    _buildTextField(
                      label: "Milker's Name",
                      onSaved: (value) {
                        milkerName = value;
                      },
                    ),
                    _buildTextField(
                      label: "Storage Method",
                      onSaved: (value) {
                        storageMethod = value;
                      },
                    ),
                    _buildTextField(
                      label: "Health Notes",
                      maxLines: 4,
                      onSaved: (value) {
                        healthNotes = value;
                      },
                    ),
                    _buildTextField(
                      label: "Remarks",
                      maxLines: 2,
                      onSaved: (value) {
                        remarks = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _saveRecord();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66BB6A),
                        textStyle: const TextStyle(
                          color: Color(0xFFFFEB3B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text("Save Record"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
    );
  }

  Future<void> _saveRecord() async {
    await _milkRecordsCollection.add({
      'cowId': cowId,
      'milkingDate': milkingDate?.toIso8601String(),
      'milkQuantity': milkQuantity,
      'milkingSession': milkingSession,
      'milkerName': milkerName,
      'storageMethod': storageMethod,
      'healthNotes': healthNotes,
      'remarks': remarks,
    });

    // Reset form and state
    _formKey.currentState?.reset();
    setState(() {
      cowId = null;
      milkingDate = null;
      milkQuantity = null;
      milkingSession = null;
      milkerName = null;
      storageMethod = null;
      healthNotes = null;
      remarks = null;
    });
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    void Function(String?)? onSaved,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String hintText,
    required GestureTapCallback onTap,
  }) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: onTap,
        validator: (value) {
          if (milkingDate == null) {
            return "Please select a milking date";
          }
          return null;
        },
        controller: TextEditingController(
          text: milkingDate != null ? milkingDate!.toLocal().toString().split(' ')[0] : '',
        ),
      ),
    );
  }
}
