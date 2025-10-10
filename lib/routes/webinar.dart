import 'package:flutter/material.dart';

import '../page/appBarGradient.dart';

class WebinarPage extends StatelessWidget {
  const WebinarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildGradientAppBar("Webinar"),
      body: const Center(
        child: Text("📚 Welcome to Webinars!",
            style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
