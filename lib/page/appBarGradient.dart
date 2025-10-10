import 'package:flutter/material.dart';

AppBar buildGradientAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    centerTitle: false,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFB71C1C), // deep red
            Color(0xFF212121), // dark grey
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    backgroundColor: Colors.transparent, // let gradient show
    elevation: 0,
  );
}
