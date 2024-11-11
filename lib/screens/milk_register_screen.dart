import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_dairy/milk/milk_summary_screen.dart';
import 'package:smart_dairy/milk/new_milk_screen.dart';


class MilkRegisterScreen extends StatefulWidget {
  const MilkRegisterScreen({super.key});

  @override
  _MilkRegisterScreenState createState() => _MilkRegisterScreenState();
}

class _MilkRegisterScreenState extends State<MilkRegisterScreen> {
  String selectedPeriod = 'Week'; // Default selection
  String selectedTimeFrame = 'Oct 6, 2024 - Oct 12, 2024'; // Default week
  final List<String> weeks = [
    'Oct 6, 2024 - Oct 12, 2024',
    'Sep 29, 2024 - Oct 5, 2024',
    'Sep 22, 2024 - Sep 28, 2024',
  ];

  final List<String> months = [
    'October 2024',
    'September 2024',
    'August 2024',
  ];

  final List<String> years = [
    '2024',
    '2023',
    '2022',
  ];

  final Map<String, List<double>> milkProductionData = {
    'Oct 6, 2024 - Oct 12, 2024': [30, 45, 35, 60, 55, 65, 70],
    'Sep 29, 2024 - Oct 5, 2024': [25, 40, 50, 55, 60, 65, 80],
    'Sep 22, 2024 - Sep 28, 2024': [28, 38, 42, 52, 58, 68, 78],
    'October 2024': [230, 250, 260, 280],
    'September 2024': [220, 240, 260, 270],
    'August 2024': [200, 220, 250, 260],
    '2024': [1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100],
    '2023': [900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000],
    '2022': [800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900],
  };

  List<double> realTimeData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Milk Records"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Dropdown for selecting period (week, month, year)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedPeriod,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  underline: Container(
                    height: 2,
                    color: Colors.tealAccent[400],
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPeriod = newValue!;
                      // Reset the selected timeframe when period changes
                      selectedTimeFrame = selectedPeriod == 'Week'
                          ? weeks.first
                          : selectedPeriod == 'Month'
                              ? months.first
                              : years.first;

                      // Clear real-time data when the period changes
                      realTimeData.clear();
                    });
                  },
                  items: ['Week', 'Month', 'Year']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: selectedTimeFrame,
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  underline: Container(
                    height: 2,
                    color: Colors.tealAccent[400],
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTimeFrame = newValue!;
                      // Clear real-time data when the timeframe changes
                      realTimeData.clear();
                    });
                  },
                  items: selectedPeriod == 'Week'
                      ? weeks.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()
                      : selectedPeriod == 'Month'
                          ? months.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                          : years.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Milk Produced (Litres)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // Bar chart for milk production
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MilkProductionBarChart(
                milkProduction: milkProductionData[selectedTimeFrame]!,
                selectedPeriod: selectedPeriod,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewMilkScreen()), // Navigate to milk record screen
          );
        },
        backgroundColor: Colors.tealAccent[400],
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MilkProductionBarChart extends StatelessWidget {
  final List<double> milkProduction;
  final String selectedPeriod;

  const MilkProductionBarChart({
    super.key,
    required this.milkProduction,
    required this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: List.generate(
          milkProduction.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: milkProduction[index],
                color: Colors.teal,
                width: 15,
              ),
            ],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 100, // Adjusted for realistic milk production range
              getTitlesWidget: (value, _) {
                return Text(
                  '${value.toInt()}L',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false, // Hide right Y-axis titles
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                if (selectedPeriod == 'Week') {
                  const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                } else if (selectedPeriod == 'Month') {
                  const weeksInMonth = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
                  return Text(
                    weeksInMonth[value.toInt()],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                } else {
                  const months = [
                    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                  ];
                  return Text(
                    months[value.toInt()],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                }
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipMargin: 8, // Add margin for better visibility
            // Remove tooltipBgColor and set the background color of the tooltip in the style
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY} Litres',
                const TextStyle(color: Colors.white, backgroundColor: Colors.teal), // Set background color here
              );
            },
          ),
        ),
      ),
    );
  }
}
