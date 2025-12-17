import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  static const Color primaryColor = Color(0xFF1976D2);

  final email = TextEditingController();
  final password = TextEditingController();

  String? emailError;
  String? passwordError;

  bool _isPasswordVisible = false;

  // Fungsi validasi tetap dipanggil dari Parent (LoginPage)
  bool validate() {
    setState(() {
      if (email.text.trim().isEmpty) {
        emailError = "Email tidak boleh kosong";
      } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
          .hasMatch(email.text.trim())) {
        emailError = "Format email tidak valid";
      } else {
        emailError = null;
      }

      if (password.text.isEmpty) {
        passwordError = "Password tidak boleh kosong";
      } else if (password.text.length < 6) {
        passwordError = "Password minimal 6 karakter";
      } else {
        passwordError = null;
      }
    });

    return emailError == null && passwordError == null;
  }

  InputDecoration _inputDecoration(String label, String? error, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      errorText: error, // Error akan hilang jika variabel error di-set null
      filled: true,
      fillColor: Colors.grey.shade100,
      labelStyle: const TextStyle(color: primaryColor),
      suffixIcon: suffixIcon,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      errorBorder: OutlineInputBorder( // Style border saat error
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder( // Style border saat error & fokus
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- EMAIL TEXTFIELD ---
        TextField(
          controller: email,
          cursorColor: primaryColor,
          keyboardType: TextInputType.emailAddress,
          // LOGIKA BARU: Hilangkan error saat mengetik
          onChanged: (value) {
            if (emailError != null) {
              setState(() {
                emailError = null;
              });
            }
          },
          decoration: _inputDecoration('Email', emailError),
        ),
        
        const SizedBox(height: 16),
        
        // --- PASSWORD TEXTFIELD ---
        TextField(
          controller: password,
          obscureText: !_isPasswordVisible,
          cursorColor: primaryColor,
          // LOGIKA BARU: Hilangkan error saat mengetik
          onChanged: (value) {
            if (passwordError != null) {
              setState(() {
                passwordError = null;
              });
            }
          },
          decoration: _inputDecoration(
            'Password',
            passwordError,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}