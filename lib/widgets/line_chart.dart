import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SparkLineChart extends StatefulWidget {
  final List<FlSpot> spots;
  const SparkLineChart({super.key, required this.spots});

  @override
  State<SparkLineChart> createState() => _SparkLineChartState();
}

class _SparkLineChartState extends State<SparkLineChart> {
  List<FlSpot> get spots => widget.spots;

  FlSpot? getMaxValue(List<FlSpot> spots) {
    return spots.reduce(
        (currentMax, spot) => spot.y > currentMax.y ? spot : currentMax);
  }

  FlSpot? getMinValue(List<FlSpot> spots) {
    return spots.reduce(
        (currentMin, spot) => spot.y < currentMin.y ? spot : currentMin);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minX = spots.first.x;
    final maxX = spots.last.x;
    final minY = getMinValue(spots)!.y;
    final maxY = getMaxValue(spots)!.y;
    return LineChart(
      LineChartData(
        backgroundColor: theme.scaffoldBackgroundColor,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: theme.highlightColor,
            isCurved: true,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            gradient: LinearGradient(
              colors: [
                theme.highlightColor.withOpacity(.7),
                theme.highlightColor,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  theme.highlightColor.withOpacity(0.4),
                  theme.highlightColor.withOpacity(0.01),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          )
        ],
        titlesData: FlTitlesData(
          // Disable the top titles
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          // Disable the right titles
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 70,
              getTitlesWidget: (double value, TitleMeta meta) {
                String text;
                if (value == minY) {
                  text = '${minY.toStringAsFixed(2)} €';
                } else if (value == maxY) {
                  text = '${maxY.toStringAsFixed(2)} €';
                } else {
                  text = '';
                }
                return Text(text,
                    style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 70,
              getTitlesWidget: (double value, TitleMeta meta) {
                String text;
                if (value == minX || value == maxX) {
                  text = DateFormat.MMMd().format(
                      DateTime.fromMillisecondsSinceEpoch(value.toInt()));
                } else {
                  text = '';
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(text,
                      style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12)),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
            show: false,
            getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.shade200,
                  strokeWidth: 1,
                ),
            getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.grey.shade200,
                  strokeWidth: 1,
                )),
        borderData: FlBorderData(
            show: false, border: Border.all(color: Colors.grey.shade200)),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: theme.cardColor,
            tooltipRoundedRadius: 8,
            tooltipBorder: BorderSide(color: theme.highlightColor),
            fitInsideHorizontally: true,
            fitInsideVertically: false,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                final dateTime =
                    DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt());
                final formattedDate =
                    DateFormat.yMd().format(dateTime); // Format the date
                return LineTooltipItem(
                  '$formattedDate\n${touchedSpot.y.toStringAsFixed(2)} €',
                  TextStyle(
                    color: theme.primaryColor,
                  ),
                );
              }).toList();
            },
          ),
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(color: Colors.grey.withOpacity(.8), strokeWidth: 2),
                const FlDotData(show: true),
              );
            }).toList();
          },
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) {
            // Your callback logic here
          },
          handleBuiltInTouches: true,
        ),
      ),
    );
  }
}
