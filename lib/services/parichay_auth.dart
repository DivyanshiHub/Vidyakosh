import 'package:pkce/pkce.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ParichayPKCEHelper {
  late String codeVerifier;
  late String codeChallenge;

  ParichayPKCEHelper() {
    final pkcePair = PkcePair.generate();
    codeVerifier = pkcePair.codeVerifier;
    codeChallenge = pkcePair.codeChallenge;
  }
}

class ParichayAuth {
  static const String parichayBaseUrl = "https://parichay.staging.nic.in"; // Use staging
  static const String redirectUri = "com.vidyakosh://callback"; // placeholder custom scheme
  static const String clientId = "Ghl9YBlfC2reXvevQZB6hokgzqPunIik"; // placeholder
  static const String clientSecret = "PcOakkVRK3cjs49KHWHacdSTBzRu1hMn";

  static String buildAuthUrl(String codeChallenge) {
    final scope = "user_details";
    final state = "xyz123"; // random string to verify later
    final responseType = "code";
    final codeChallengeMethod = "S256";

    return "$parichayBaseUrl/pnv1/oauth2/authorize"
        "?response_type=$responseType"
        "&client_id=$clientId"
        "&redirect_uri=$redirectUri"
        "&scope=$scope"
        "&code_challenge=$codeChallenge"
        "&code_challenge_method=$codeChallengeMethod"
        "&state=$state";
  }

  // ✅ Add helper to exchange authorization code for tokens
  static Map<String, dynamic> buildTokenRequestBody({
    required String code,
    required String codeVerifier,
  }) {
    return {
      "client_id": clientId,
      "client_secret": clientSecret,
      "code_verifier": codeVerifier,
      "grant_type": "authorization_code",
      "redirect_uri": redirectUri,
      "code": code,
    };
  }

  /// 🔹 STEP 3: Exchange Authorization Code for Access Token
  static Future<Map<String, dynamic>> getToken({
    required String code,
    required String codeVerifier,
  }) async {
    final url = Uri.parse("$parichayBaseUrl/pnv1/salt/api/oauth2/token");

    final body = buildTokenRequestBody(code: code, codeVerifier: codeVerifier);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Access Token: ${data['access_token']}");
      return data;
    } else {
      print("❌ Token API failed: ${response.statusCode} ${response.body}");
      throw Exception("Failed to get access token");
    }
  }

  /// 🔹 STEP 4: Get User Details using Access Token
  static Future<Map<String, dynamic>> getUserDetails(String accessToken) async {
    final url = Uri.parse("$parichayBaseUrl/pnv1/salt/api/oauth2/userdetails");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("✅ User Details: $data");
      return data;
    } else {
      print("❌ User Details fetch failed: ${response.statusCode} ${response.body}");
      throw Exception("Failed to fetch user details");
    }
  }
}

