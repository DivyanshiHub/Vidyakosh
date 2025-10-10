import 'package:flutter/material.dart';
import '../page/appBarGradient.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildGradientAppBar("Trainings"),
      body: const Center(
        child: Text("🎓 Trainings",
            style: TextStyle(fontSize: 22)),
      ),
    );
  }
}