import 'package:flutter/material.dart';

class RegisterSubmitSection extends StatelessWidget {
  const RegisterSubmitSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700),
        child: const Text("Buat Akun", style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
