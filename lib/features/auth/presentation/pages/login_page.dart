import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/login_controller.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<LoginFormState>();

  static const Color primaryColor = Color(0xFF1976D2);

  void _handleLogin(BuildContext context) async {
    final controller = context.read<LoginController>();

    if (!_formKey.currentState!.validate()) return;

    final email = _formKey.currentState!.email.text.trim();
    final password = _formKey.currentState!.password.text;

    final result = await controller.login(email, password);

    if (result['status'] == 'success') {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LoginController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // 🔵 Branding section
              Column(
                children: const [
                  Icon(
                    Icons.school_rounded,
                    size: 80,
                    color: primaryColor,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Jawara Pintar",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 🟦 Card container modern
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    LoginForm(key: _formKey),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: controller.isLoading
                            ? null
                            : () => _handleLogin(context),
                        child: controller.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🟦 Bottom text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
