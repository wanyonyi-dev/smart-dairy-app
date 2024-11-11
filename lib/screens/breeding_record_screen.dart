import 'package:flutter/material.dart';

class BreedingRecordScreen extends StatefulWidget {
  const BreedingRecordScreen({super.key});

  @override
  _BreedingRecordScreenState createState() => _BreedingRecordScreenState();
}

class _BreedingRecordScreenState extends State<BreedingRecordScreen> {
  DateTime? inseminationDate;
  String? selectedBreed;
  final _formKey = GlobalKey<FormState>();

  final List<String> breeds = [
    'Holstein (Friesian)',
    'Jersey',
    'Guernsey',
    'Ayrshire',
    'Brown Swiss',
    'Red Poll',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Breeding Record'),
        backgroundColor: const Color(0xFF66BB6A), // App bar color
      ),
      backgroundColor: const Color(0xFFFFFFFF), // Background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                inputStyle("Cow ID/Name"),
                // Date Picker for Artificial Insemination Date
                _buildDateField(),
                // Dropdown for breed selection
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select Breed",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  items: breeds.map((breed) {
                    return DropdownMenuItem(value: breed, child: Text(breed));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBreed = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please select a breed";
                    }
                    return null;
                  },
                ),
                inputStyle("Semen Company"),
                inputStyle("Bull Name"),
                inputStyle("Tag No"),
                inputStyle("Lactation No"),
                const SizedBox(height: 20),
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF66BB6A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle submission logic here
                        Navigator.of(context).pop(); // Navigation logic
                      }
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 20, color: Color(0xFFFFEB3B)), // Button text color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build a date field
  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        readOnly: true, // Make the TextField read-only
        decoration: InputDecoration(
          labelText: "Insemination Date",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(),
          ),
          contentPadding: const EdgeInsets.all(10),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        controller: TextEditingController(
          text: inseminationDate == null
              ? ''
              : "${inseminationDate!.toLocal()}".split(' ')[0],
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: inseminationDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            setState(() {
              inseminationDate = pickedDate;
            });
          }
        },
        validator: (value) {
          if (inseminationDate == null) {
            return "Please select an insemination date";
          }
          return null;
        },
      ),
    );
  }

  // Define the inputStyle method within the BreedingRecordScreen class
  Widget inputStyle(String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(),
          ),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }
}
