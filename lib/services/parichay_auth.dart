import 'package:pkce/pkce.dart';
import 'dart:math';
import 'dart:convert';

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
  static const String clientId = "YOUR_CLIENT_ID"; // placeholder

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
}

