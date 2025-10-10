// lib/services/logout_service.dart
import 'package:flutter/material.dart';

class LogoutService {
  static void logout(BuildContext context) {
    // ✅ Example: Clear session, tokens, etc.
    // For now, we just navigate back to login page
    Navigator.pushReplacementNamed(context, '/login');

    // Later you can add shared_preferences or Firebase signOut here
  }
}
