import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../page/appBarGradient.dart';

class CoursePage extends StatelessWidget {
  final int completedCourses = 2; // Example: user has completed 2
  final int totalCourses = 5;    // Example: total allocated = 5

  @override
  Widget build(BuildContext context) {
    final double progressPercent = (completedCourses / totalCourses) * 100;

    return Scaffold(
      appBar: buildGradientAppBar("Courses Completed"
        // title: const Text("Courses Completed"),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
        // backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$completedCourses of $totalCourses Courses Completed",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 Donut Chart
            // 🔹 Donut Chart with percentage in the center
            SizedBox(
              height: 220,
              width: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 70, // 🔹 donut effect
                      sections: [
                        PieChartSectionData(
                          value: completedCourses.toDouble(),
                          color: Colors.green,
                          title: '',
                          radius: 60,
                        ),
                        PieChartSectionData(
                          value: (totalCourses - completedCourses).toDouble(),
                          color: Colors.grey.shade300,
                          title: '',
                          radius: 60,
                        ),
                      ],
                    ),
                  ),
                  // ✅ Percentage text overlay in center
                  Text(
                    "${progressPercent.toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
