import 'package:flutter/material.dart';

class RegisterLoginRedirect extends StatelessWidget {
  const RegisterLoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Sudah punya akun? "),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Text("Masuk", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        ),
      ],
    );
  }
}
