import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart package
import 'package:smart_dairy/custom_fl_spot.dart'; // Import your custom FlSpot class

class FlChartWidget extends StatelessWidget {
  final List<CustomFlSpot> spots;

  const FlChartWidget({super.key, required this.spots});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true), // Show grid data
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 1:
                        return const Text('Day 1');
                      case 2:
                        return const Text('Day 2');
                      case 3:
                        return const Text('Day 3');
                      case 4:
                        return const Text('Day 4');
                      case 5:
                        return const Text('Day 5');
                      default:
                        return const Text('');
                    }
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.black, width: 1),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots.map((customSpot) => FlSpot(customSpot.x, customSpot.y)).toList(),
                isCurved: true,
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.blue], // Use gradient instead of colors
                ),
                barWidth: 3,
                belowBarData: BarAreaData(show: false),
                dotData: const FlDotData(show: true),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                // Replaced tooltipDecoration with tooltipBgColor
                // Set background color
                tooltipPadding: const EdgeInsets.all(8), // Padding for the tooltip
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      'Day: ${spot.x}\nProduction: ${spot.y} liters',
                      const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
