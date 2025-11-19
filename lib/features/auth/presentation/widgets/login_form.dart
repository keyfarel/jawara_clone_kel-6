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

  // 1. Tambahkan variable state untuk visibilitas password
  bool _isPasswordVisible = false;

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

  // 2. Update fungsi ini agar menerima parameter opsional suffixIcon
  InputDecoration _inputDecoration(String label, String? error, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      errorText: error,
      filled: true,
      fillColor: Colors.grey.shade100,
      labelStyle: const TextStyle(color: primaryColor),
      suffixIcon: suffixIcon, // Tambahkan properti ini
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
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
        TextField(
          controller: email,
          cursorColor: primaryColor,
          decoration: _inputDecoration('Email', emailError),
        ),
        const SizedBox(height: 16),
        
        // 3. Update TextField Password
        TextField(
          controller: password,
          // Jika visible = true, maka obscureText = false (teks terlihat)
          obscureText: !_isPasswordVisible, 
          cursorColor: primaryColor,
          decoration: _inputDecoration(
            'Password', 
            passwordError,
            // Tambahkan tombol mata disini
            suffixIcon: IconButton(
              icon: Icon(
                // Logika Icon: Jika terlihat -> Mata biasa. Jika tersembunyi -> Mata silang.
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