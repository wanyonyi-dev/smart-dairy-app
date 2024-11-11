import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MilkProductionScreen extends StatefulWidget {
  const MilkProductionScreen({super.key});

  @override
  _MilkProductionScreenState createState() => _MilkProductionScreenState();
}

class _MilkProductionScreenState extends State<MilkProductionScreen> {
  String selectedWeek = 'Oct 6, 2024 - Oct 12, 2024'; // Default week
  final List<String> weeks = [
    'Oct 6, 2024 - Oct 12, 2024',
    'Sep 29, 2024 - Oct 5, 2024',
    'Sep 22, 2024 - Sep 28, 2024',
    // Add more weeks if needed
  ];

  // Example data for each week
  final Map<String, List<double>> milkProductionData = {
    'Oct 6, 2024 - Oct 12, 2024': [10, 20, 15, 30, 25, 35, 40],
    'Sep 29, 2024 - Oct 5, 2024': [5, 10, 20, 25, 30, 35, 50],
    'Sep 22, 2024 - Sep 28, 2024': [8, 18, 12, 22, 28, 38, 48],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Milk Production"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for week selection
            DropdownButton<String>(
              value: selectedWeek,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              underline: Container(
                height: 2,
                color: Colors.tealAccent[400],
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedWeek = newValue!;
                });
              },
              items: weeks.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Milk Produced (Litres)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: MilkProductionChart(
                milkProduction: milkProductionData[selectedWeek]!,
              ), // Bar chart widget
            ),
            const SizedBox(height: 16),
            Text(
              'Total: ${milkProductionData[selectedWeek]!.reduce((a, b) => a + b)} Litres',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class MilkProductionChart extends StatelessWidget {
  final List<double> milkProduction;

  const MilkProductionChart({super.key, required this.milkProduction});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 50, // Set maximum Y scale to 50
        barGroups: milkProduction
            .asMap()
            .entries
            .map((entry) => makeGroupData(entry.key, entry.value))
            .toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles( // Customize left axis titles
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10, // Show intervals of 10L
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text('${value.toInt()}L');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Sun');
                  case 1:
                    return const Text('Mon');
                  case 2:
                    return const Text('Tue');
                  case 3:
                    return const Text('Wed');
                  case 4:
                    return const Text('Thu');
                  case 5:
                    return const Text('Fri');
                  case 6:
                    return const Text('Sat');
                  default:
                    return const Text('');
                }
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(enabled: true),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blue,
          width: 16,
          borderRadius: BorderRadius.zero, // Regular bars without rounded corners
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MilkProductionScreen(),
  ));
}
