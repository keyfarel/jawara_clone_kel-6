import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../routes/app_routes.dart';
import '../../data/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  @override
  void initState() {
    super.initState();
    // Jalankan logic setelah frame pertama selesai dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
  }

  void _checkSession() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      // Kita gunakan Future.wait agar dua proses jalan berbarengan:
      // 1. Cek Auto Login (Database/API)
      // 2. Delay minimal 2 detik (Agar logo sempat terlihat / branding)
      final results = await Future.wait([
        authService.checkAutoLogin(),             // index 0
        Future.delayed(const Duration(seconds: 2)), // index 1 (hanya timer)
      ]);

      // Ambil hasil dari checkAutoLogin (index 0)
      final bool isLoggedIn = results[0] as bool;

      if (!mounted) return;

      // Navigasi sesuai status login
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      // Jika error fatal, arahkan ke login saja atau tampilkan dialog error
      print("Error di Splash: $e"); // Log di console saja, jangan di UI
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- AREA LOGO ---
            // Ganti Icon di bawah ini dengan Image.asset jika punya logo
            // Contoh: Image.asset('assets/images/logo_jawara.png', width: 150),
            const Icon(
              Icons.home_work_rounded, // Placeholder logo (bisa diganti)
              size: 100,
              color: Colors.blue,
            ),
            
            const SizedBox(height: 20),
            
            // Text Judul Aplikasi (Opsional)
            const Text(
              "JAWARA",
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                letterSpacing: 2
              ),
            ),

            const SizedBox(height: 50),

            // Loading Indicator standar
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}