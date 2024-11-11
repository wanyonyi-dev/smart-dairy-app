import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_dairy/screens/health_record_screen.dart';
// Include for charts

class HealthRegisterScreen extends StatefulWidget {
  const HealthRegisterScreen({super.key});

  @override
  _HealthRegisterScreenState createState() => _HealthRegisterScreenState();
}

class _HealthRegisterScreenState extends State<HealthRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Records"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Line chart section taking half the screen
          Expanded(
            flex: 1, // This takes half of the screen
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                sampleData(), // Use the sample data for the chart
              ),
            ),
          ),
          // Message when no records found
          const Expanded(
            flex: 1, // This takes the other half of the screen
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No records found",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HealthRecordScreen())); // Handle action for adding new calf
        },
        backgroundColor: Colors.tealAccent[400],
        child: const Icon(Icons.add),
      ),
    );
  }

  LineChartData sampleData() {
    return LineChartData(
      gridData: const FlGridData(show: false), // Disable grid lines
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
      titlesData: const FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 22),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 22),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(1, 1),
            FlSpot(2, 2.5),
            FlSpot(3, 1.5),
            FlSpot(4, 3),
            FlSpot(5, 2),
          ],
          isCurved: true,
          color: Colors.blueAccent, // Use 'color' for a single color
          dotData: const FlDotData(show: true),
        ),
      ],
    );
  }
}
