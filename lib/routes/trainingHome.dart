import 'package:flutter/material.dart';
import '../page/appBarGradient.dart';

class TrainingsPage extends StatelessWidget {
  const TrainingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildGradientAppBar("Trainings Progress"),
      body: const Center(
        child: Text("📚 Welcome to our Trainings!",
            style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
