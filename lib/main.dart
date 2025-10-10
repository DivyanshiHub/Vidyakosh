import 'package:flutter/material.dart';
import 'package:vidyakosh/routes/home.dart';
import 'routes/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      // // Set initial route to login
      // home: const LoginPage(),
      initialRoute: '/login',
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(), // ✅ must exist
      },
    );
  }
}
