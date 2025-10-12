import 'package:flutter/material.dart';

class LoginActionSection extends StatelessWidget {
  const LoginActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/kegiatan');
            },
            child: const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 24),

        // Link daftar
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Belum punya akun?', style: TextStyle(color: Colors.black54)),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                'Daftar',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
