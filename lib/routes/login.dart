import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';

import '../page/loginGradient.dart';
import '../page/glassgradient.dart';
import '../services/parichay_auth.dart';
import '../services/secure_storage_service.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late AppLinks _appLinks;
  late ParichayPKCEHelper _pkceHelper;

  @override
  void initState() {
    super.initState();

    _pkceHelper = ParichayPKCEHelper();

    _appLinks = AppLinks();

    // Listen for redirect URI
    _appLinks.uriLinkStream.listen((Uri uri) async {
      print("🔗 Deep link received: $uri");

      if (uri.scheme == "com.vidyakosh" && uri.host == "callback") {
        final code = uri.queryParameters['code'];
        print("Extracted code: $code");

        if (code == null) throw Exception("Authorization code not found");

        // Exchange code for token
        try {
          final tokenData = await ParichayAuth.getToken(
            code: code,
            codeVerifier: _pkceHelper.codeVerifier,
          );

          final accessToken = tokenData['access_token'];
          final refreshToken = tokenData['refresh_token'];
          print("Access Token : $accessToken");
          print("refresh Token : $refreshToken");

          if (accessToken == null || refreshToken == null) {
            throw Exception("Access or refresh token missing");
          }

          await SecureStorageService.saveTokens(
            accessToken: accessToken!,
            refreshToken: refreshToken!,
          );

          print("Tokens saved securely");
          final userDetails = await ParichayAuth.getUserDetails(accessToken);
          print("User Details: $userDetails");

          // ✅ Proceed to next screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful!")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } catch (e) {
          print("❌ Token exchange failed: $e");
        }
      }
    });
  }

  // Launch Parichay login
  Future<void> _loginWithParichay() async {
    final authUrl = ParichayAuth.buildAuthUrl(_pkceHelper.codeChallenge);

    print("Launching AUTH URL: $authUrl");

    // Open in browser
    await launchUrl(Uri.parse(authUrl), mode: LaunchMode.externalApplication);
  }

  // Dummy login
  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    if (emailController.text == "test@nic.in" &&
        passwordController.text == "12345") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradientPage(
        child: Column(
          children: [
            const SizedBox(height: 80),

            // Logo
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.1),
              ),
              child: Image.asset(
                "images/nicBlacklogo.png",
                height: 60,
                color: Colors.white.withOpacity(0.9),
                colorBlendMode: BlendMode.modulate,
              ),
            ),

            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Email / Password Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (v) =>
                              v!.isEmpty ? "Please enter email" : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (v) =>
                              v!.isEmpty ? "Please enter password" : null,
                            ),
                            const SizedBox(height: 30),

                            // Login button
                            SizedBox(
                              width: 200,
                              child: GlassButton(
                                text: "Login",
                                onPressed: _handleLogin,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          Expanded(
                              child: Divider(color: Colors.white, thickness: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text("OR",
                                style: TextStyle(color: Colors.white)),
                          ),
                          Expanded(
                              child: Divider(color: Colors.white, thickness: 1)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Parichay Login Button
                      SizedBox(
                        width: 220,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Image.asset(
                            "images/nicBlacklogo.png",
                            height: 24,
                          ),
                          label: const Text(
                            "Login with Parichay",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: _loginWithParichay,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
