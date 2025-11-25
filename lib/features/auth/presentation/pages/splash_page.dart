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
  // Kita inisialisasi variabel dengan Text panjang agar kelihatan kalau UI muncul
  String _debugStatus = "1. Menunggu Frame UI Selesai...";

  @override
  void initState() {
    super.initState();
    
    // PENTING: Jangan panggil setState atau logic berat langsung di sini.
    // Gunakan addPostFrameCallback agar dijalankan SETELAH UI tampil.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCheck();
    });
  }

  // Fungsi wrapper agar kode lebih rapi
  void _startCheck() async {
    _updateStatus('2. Frame Selesai. InitState OK.');
    _checkSession();
  }

  void _updateStatus(String message) {
    print(message); 
    // Cek mounted agar tidak error jika user keluar aplikasi tiba-tiba
    if (mounted) {
      setState(() {
        _debugStatus += "\n$message";
      });
    }
  }

  void _checkSession() async {
    try {
      _updateStatus('3. Mencari Provider AuthService...');
      // Ambil provider
      final authService = Provider.of<AuthService>(context, listen: false);
      
      _updateStatus('4. Provider Ditemukan. Delay 1 detik...');
      await Future.delayed(const Duration(seconds: 1)); // Delay diperlama biar terbaca

      _updateStatus('5. Memanggil authService.checkAutoLogin()...');
      final isLoggedIn = await authService.checkAutoLogin();

      _updateStatus('6. Hasil Login: $isLoggedIn');

      if (!mounted) return;

      // Tambah delay lagi sebelum pindah halaman
      _updateStatus('7. Tunggu sebentar sebelum navigasi...');
      await Future.delayed(const Duration(seconds: 2)); 

      if (isLoggedIn) {
        _updateStatus('➡️ PINDAH KE DASHBOARD');
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else {
        _updateStatus('➡️ PINDAH KE LOGIN');
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      _updateStatus('❌ ERROR FATAL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pastikan background putih
      body: SingleChildScrollView( // Pakai scroll biar kalau log panjang tidak error overflow
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50), // Jarak aman dari atas
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                const Text(
                  "DEBUG MODE",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                // Kotak Log
                Container(
                  width: double.infinity, // Lebar penuh
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Warna abu-abu muda
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    _debugStatus,
                    textAlign: TextAlign.left, // Rata kiri agar mudah dibaca
                    style: const TextStyle(
                      fontFamily: 'monospace', 
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5 // Jarak antar baris
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}