import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Dairy',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const CowRegisterScreen(),
    );
  }
}

class CowRegisterScreen extends StatefulWidget {
  const CowRegisterScreen({super.key});

  @override
  _CowRegisterScreenState createState() => _CowRegisterScreenState();
}

class _CowRegisterScreenState extends State<CowRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _healthController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _registerCow() async {
    if (_formKey.currentState!.validate()) {
      final cow = Cow(
        name: _nameController.text,
        breed: _breedController.text,
        age: int.tryParse(_ageController.text) ?? 0,
        healthStatus: _healthController.text,
        weight: double.tryParse(_weightController.text) ?? 0.0,
      );

      await FirestoreService().registerCow(cow);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cow registered successfully!')),
      );

      // Clear the text fields after registration
      _nameController.clear();
      _breedController.clear();
      _ageController.clear();
      _healthController.clear();
      _weightController.clear();
    }
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
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
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cow Registration"),
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
                      label: 'Cow Name',
                      controller: _nameController,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter the cow name' : null,
                    ),
                    _buildTextField(
                      label: 'Breed',
                      controller: _breedController,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter the breed' : null,
                    ),
                    _buildTextField(
                      label: 'Age (Years)',
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter the age' : null,
                    ),
                    _buildTextField(
                      label: 'Health Status',
                      controller: _healthController,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter the health status' : null,
                    ),
                    _buildTextField(
                      label: 'Weight (kg)',
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter the weight' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _registerCow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66BB6A),
                        textStyle: const TextStyle(
                          color: Color(0xFFFFEB3B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Register Cow'),
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
}

class Cow {
  final String name;
  final String breed;
  final int age;
  final String healthStatus;
  final double weight;

  Cow({
    required this.name,
    required this.breed,
    required this.age,
    required this.healthStatus,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'breed': breed,
      'age': age,
      'healthStatus': healthStatus,
      'weight': weight,
    };
  }
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registerCow(Cow cow) async {
    await _db.collection('cows').add(cow.toMap());
  }
}
