import 'package:flutter/material.dart';
import '../page/appBarGradient.dart';

class IgotPage extends StatelessWidget {
  const IgotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildGradientAppBar("Igot"),
      body: const Center(
        child: Text("📚 Welcome to our IGot Courses!",
            style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

