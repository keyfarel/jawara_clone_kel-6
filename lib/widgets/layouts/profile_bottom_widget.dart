import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/features/auth/data/auth_service.dart';
import 'package:myapp/core/routes/app_routes.dart';

class ProfileBottomWidget extends StatelessWidget {
  final BuildContext rootContext;

  const ProfileBottomWidget({
    super.key,
    required this.rootContext,
  });

  void _handleLogout() async {
    // 1. Tutup Bottom Sheet terlebih dahulu
    Navigator.pop(rootContext); 

    // 2. Panggil fungsi logout dari AuthService
    // listen: false karena kita hanya menjalankan fungsi, tidak memantau perubahan state UI
    await Provider.of<AuthService>(rootContext, listen: false).logout();

    // 3. Arahkan kembali ke halaman Login & Hapus riwayat navigasi (agar tidak bisa di-back)
    if (rootContext.mounted) {
      Navigator.of(rootContext).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indikator geser (optional visual)
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Info User
          const Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 30, color: Colors.white),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Admin Jawara",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "admin1@gmail.com",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          
          // Tombol Logout
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.logout, color: Colors.red.shade700),
            ),
            title: Text(
              "Keluar Aplikasi",
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text("Hapus sesi dan kembali ke login"),
            onTap: _handleLogout,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}