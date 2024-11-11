import 'package:flutter/material.dart';
import 'package:smart_dairy/cow/add_cattle_screen.dart';
import 'package:smart_dairy/money/transaction_page.dart';
import 'package:smart_dairy/screens/breeding_register_screen.dart';
import 'package:smart_dairy/screens/financial_register_screen.dart';
import 'package:smart_dairy/health/health_record_dashboard.dart';
import 'package:smart_dairy/screens/milk_register_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_dairy/screens/cow_register_screen.dart';


void main() {
  runApp(
    const MaterialApp(
      home: DashboardScreen(),
    ),
  );
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Updated background color to white
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: Colors.black, size: 50.0), // Updated icon color to black
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
                "Dashboard options",
                style: TextStyle(
                    color: Colors.black, // Updated text color to black
                    fontSize: 28.0,
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
                    // Breeding Card
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BreedingRegisterScreen()));
                      },
                      child: SizedBox(
                        width: 120.0,
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
                                    "assets/breeding.png",
                                    width: 64.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.pets, size: 64, color: Colors.grey);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "Breeding",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  const Text(
                                    "",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Milk Card
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MilkRegisterScreen()));
                      },
                      child: SizedBox(
                        width: 120.0,
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
                                    "assets/milk.png",
                                    width: 64.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.local_drink, size: 64, color: Colors.grey);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "Milk",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  const Text(
                                    "",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Health Card
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthRecordsDashboard()));
                      },
                      child: SizedBox(
                        width: 120.0,
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
                                    "assets/health.png",
                                    width: 64.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.health_and_safety, size: 64, color: Colors.grey);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "Health",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  const Text(
                                    "",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Financial Card
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionPage()));
                      },
                      child: SizedBox(
                        width: 120.0,
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
                                    "assets/financial.png",
                                    width: 64.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.monetization_on, size: 64, color: Colors.grey);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "Financial",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  const Text(
                                    "",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                       InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddCattleScreen()));
                      },
                      child: SizedBox(
                        width: 120.0,
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
                                    "assets/financial.png",
                                    width: 64.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.monetization_on, size: 64, color: Colors.grey);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "Manage Cattle",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  const Text(
                                    "",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w100),
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
          ],
        ),
      ),
    );
  }
}

