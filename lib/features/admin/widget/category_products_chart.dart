import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> data;

  const CategoryProductsChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final maxY = data.isEmpty
        ? 10
        : data
                  .map((e) => e.earning)
                  .reduce((a, b) => a > b ? a : b)
                  .toDouble() +
              10;

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY.toDouble(),
          barGroups: List.generate(data.length, (index) {
            final sale = data[index];
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: sale.earning.toDouble(),
                  color: Colors.blue,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length)
                    return const SizedBox();
                  return Text(
                    data[index].label,
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
