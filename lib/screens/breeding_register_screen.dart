import 'package:flutter/material.dart'; 
import 'package:smart_dairy/pages/breeding_records_page.dart';
import 'package:smart_dairy/pages/calving_register_page.dart';
import 'package:smart_dairy/pages/heat_register_page.dart';
import 'package:smart_dairy/pages/insemination_register_page.dart';

class BreedingRegisterScreen extends StatelessWidget {
  const BreedingRegisterScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Background color set to white (#FFFFFF)
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: Colors.black, size: 50.0), // Icon color set to black
                  Image.asset(
                    "assets/profile.png",
                    width: 64.0,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 64, color: Colors.grey);
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                "Breeding",
                style: TextStyle(
                    color: Colors.black, // Text color set to black
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: [
                    // Treatment Card
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HeatRegisterPage()));
                      },
                      child: SizedBox(
                        width: 140.0,
                        height: 160.0,
                        child: Card(
                          color: const Color(0xFFEFEFEF), // Light background for cards
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/heat.png",
                                    width: 64.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.pets, size: 64, color: Colors.grey);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "Heat Register",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Vaccination Card
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CalvingRegisterPage()));
                      },
                      child: SizedBox(
                        width: 140.0,
                        height: 160.0,
                        child: Card(
                          color: const Color(0xFFEFEFEF),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/calving.png",
                                    width: 64.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.local_drink, size: 64, color: Colors.grey);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "Calving Register",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Deworming Card
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const InseminationRegisterPage()));
                      },
                      child: SizedBox(
                        width: 140.0,
                        height: 160.0,
                        child: Card(
                          color: const Color(0xFFEFEFEF),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/insemination.png",
                                    width: 64.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.health_and_safety, size: 64, color: Colors.grey);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "Insemination",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Health Records Summary Card
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BreedingRecordsPage()));
                      },
                      child: SizedBox(
                        width: 140.0,
                        height: 160.0,
                        child: Card(
                          color: const Color(0xFFEFEFEF),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/summary.png",
                                    width: 64.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.monetization_on, size: 64, color: Colors.grey);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "Breeding Records",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66BB6A), // Button color set to #66BB6A
                ),
                onPressed: () {},
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Color(0xFFFFEB3B), // Button text color set to #FFEB3B
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
