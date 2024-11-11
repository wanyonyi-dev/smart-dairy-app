import 'package:flutter/material.dart'; 
import 'package:smart_dairy/health/deworming_record_page.dart';
import 'package:smart_dairy/health/health_record_summary_page.dart';
import 'package:smart_dairy/health/treatment_record_page.dart';
import 'package:smart_dairy/health/vaccination_record_page.dart';

class HealthRecordsDashboard extends StatelessWidget {
  const HealthRecordsDashboard({super.key});

  
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
                "Health Record Dashboard",
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TreatmentRecordsPage()));
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
                                    "assets/treatment.png",
                                    width: 64.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.pets, size: 64, color: Colors.grey);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "Treatment",
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const VaccinationRecordsPage()));
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
                                    "assets/vaccination.png",
                                    width: 64.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.local_drink, size: 64, color: Colors.grey);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "Vaccination",
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DewormingRecordsPage()));
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
                                    "assets/deworm.png",
                                    width: 64.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.health_and_safety, size: 64, color: Colors.grey);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    "Deworming",
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthRecordsSummaryPage()));
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
                                    "Health Records",
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
