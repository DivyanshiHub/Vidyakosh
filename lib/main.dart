import 'package:flutter/material.dart';
import 'package:vidyakosh/routes/home.dart';
import 'routes/login.dart';

/*void main() {
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
}*/


import 'services/secure_storage_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await SecureStorageService.getAccessToken();
  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },

      // ✅ Decide the start page
      initialRoute: isLoggedIn ? '/home' : '/login',
      // home: isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}

