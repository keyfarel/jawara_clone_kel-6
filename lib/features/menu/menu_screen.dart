import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Menu Item
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Channel', 'icon': Icons.payment, 'color': Colors.orange},
      {'title': 'Pengguna', 'icon': Icons.manage_accounts, 'color': Colors.blue},
      {'title': 'Log Aktifitas', 'icon': Icons.history, 'color': Colors.grey},
      {'title': 'Mutasi', 'icon': Icons.swap_horiz, 'color': Colors.purple},
      {'title': 'Aspirasi', 'icon': Icons.chat_bubble_outline, 'color': Colors.teal},
      {'title': 'Broadcast', 'icon': Icons.campaign, 'color': Colors.red},
      {'title': 'Laporan', 'icon': Icons.summarize, 'color': Colors.green},
      {'title': 'Rumah', 'icon': Icons.home_work, 'color': Colors.indigo},
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Menu Aplikasi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        actions: [
          // Profil akses cepat
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
               // Panggil BottomSheet ProfileWidget lama Anda disini
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Bagian Header Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text("Akses fitur manajemen lainnya melalui menu di bawah ini."),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          const Text("Manajemen Utama", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          // Grid Menu
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 kolom agar pas di HP
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return _buildMenuCard(
                title: item['title'],
                icon: item['icon'],
                color: item['color'],
                onTap: () {
                  // Navigasi ke halaman detail
                  // Navigator.pushNamed(context, '/channel');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Buka ${item['title']}")),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}