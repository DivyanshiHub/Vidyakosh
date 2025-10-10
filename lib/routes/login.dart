import 'package:flutter/material.dart';
import '../page/loginGradient.dart';
import '../page/glassgradient.dart';
import 'home.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import '../services/parichay_auth.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // ----------------- PARICHAY LOGIN FUNCTION -----------------
  Future<void> _loginWithParichay() async {
    try {
      final helper = ParichayPKCEHelper();
      final authUrl = ParichayAuth.buildAuthUrl(helper.codeChallenge);

      print("Redirecting to: $authUrl");

      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: "com.vidyakosh", // Same as AndroidManifest scheme
      );

      final code = Uri.parse(result).queryParameters['code'];
      print("Authorization code: $code");

      // ✅ In the future: Send `code` + `helper.codeVerifier` to backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Parichay login success! Code: $code")),
      );

      // For now, after mock success, navigate to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      print("Login failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login with Parichay failed")),
      );
    }
  }

  void _handleLogin() {
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      // 🔑 Dummy credentials
      if (email == "test@nic.in" && password == "12345") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradientPage(
        child: Column(
          children: [
            const SizedBox(height: 80), // Push logo towards top
            // ✅ Logo section
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "images/nicBlacklogo.png",
                height: 60,
                fit: BoxFit.contain,
                color: Colors.white.withOpacity(0.9),
                colorBlendMode: BlendMode.modulate,
              ),
            ),

            // ✅ Expanded Form Section
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key :_formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black54,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
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
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please enter email";
                          }
                          return null;
                        },
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
                        validator: (value){
                          if(value!.isEmpty){
                            return "Please enter password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 200,
                        child: GlassButton(
                          text: "Login",
                          onPressed: _handleLogin,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ✅ OR Divider
                      Row(
                        children: const [
                          Expanded(child: Divider(color: Colors.white)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "OR",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: 220,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: Image.asset(
                            "images/nicBlacklogo.png",
                            height: 24,
                            color: Colors.black87,
                          ),
                          label: const Text(
                            "Login with Parichay",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          onPressed: _loginWithParichay,
                        ),
                      ),
                    ],
                  ),
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
