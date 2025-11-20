import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'secure_storage_service.dart';

class LogoutService {
  static Future<void> logout(BuildContext context) async {
    try {
      // 1️⃣ Get stored token
      final accessToken = await SecureStorageService.getAccessToken();

      if (accessToken != null) {
        // 2️⃣ Revoke token on Parichay server (so access/refresh tokens become invalid)
        final revokeUrl = Uri.parse(
            "https://parichay.staging.nic.in/pnv1/salt/api/oauth2/revoke"
        );

        final revokeResponse = await http.get(
          revokeUrl,
          headers: {"Authorization": accessToken},
        );

        print("🔴 Parichay revoke response: ${revokeResponse.body}");
      }

      // 3️⃣ Clear local secure storage
      await SecureStorageService.clearTokens();
      print("🔴 Local tokens cleared");

      // 4️⃣ Clear Parichay SSO session (VERY IMPORTANT)
      final ssoLogoutUrl = Uri.parse(
          "https://parichay.staging.nic.in/pnv1/logout"
      );

      // 5️⃣ Navigate to Login page & clear history
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

    } catch (e) {
      print("❌ Logout failed: $e");
    }
  }
}
