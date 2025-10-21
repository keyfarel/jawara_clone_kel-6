import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class ProfileBottomWidget extends StatelessWidget {
  final BuildContext rootContext;

  const ProfileBottomWidget({super.key, required this.rootContext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // penting: biar tinggi menyesuaikan isi
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              "Akun Admin",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Lihat Profil"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(rootContext).showSnackBar(
                  const SnackBar(content: Text("Menu Lihat Profil ditekan")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(const Duration(milliseconds: 200));

                if (rootContext.mounted) {
                  showDialog(
                    context: rootContext,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text("Konfirmasi Logout"),
                      content: const Text("Apakah Anda yakin ingin keluar?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text("Batal"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            Navigator.pushNamedAndRemoveUntil(
                              rootContext,
                              AppRoutes.login,
                              (route) => false,
                            );

                            ScaffoldMessenger.of(rootContext).showSnackBar(
                              const SnackBar(
                                content: Text("Logout berhasil"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
