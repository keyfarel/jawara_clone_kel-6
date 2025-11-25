import 'package:flutter/material.dart';

class RegisterFooter extends StatelessWidget {
  final Color primaryColor;
  final VoidCallback onLoginTap;

  const RegisterFooter({
    super.key, 
    required this.primaryColor,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sudah punya akun? ",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            GestureDetector(
              onTap: onLoginTap,
              child: Text(
                "Masuk disini",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}