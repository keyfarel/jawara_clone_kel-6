import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../features/menu/warga_list_screen.dart'; // Contoh halaman statis
import '../features/menu/menu_screen.dart'; // Halaman pengganti sidebar

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Daftar Halaman Utama
  final List<Widget> _pages = [
    const Center(child: Text("Dashboard Area")), // Placeholder Dashboard
    const WargaListScreen(), // Halaman Statis Contoh
    const Center(child: Text("Halaman Keuangan")), // Placeholder
    const Center(child: Text("Halaman Kegiatan")), // Placeholder
    const MenuScreen(), // PENGGANTI SIDEBAR (Semua fitur ada di sini)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Haptic feedback agar terasa seperti aplikasi native
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor: Colors.white,
          indicatorColor: Colors.blue.shade100,
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: Colors.blue),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people, color: Colors.blue),
              label: 'Warga',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet, color: Colors.blue),
              label: 'Keuangan',
            ),
            NavigationDestination(
              icon: Icon(Icons.event_outlined),
              selectedIcon: Icon(Icons.event, color: Colors.blue),
              label: 'Kegiatan',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view),
              selectedIcon: Icon(Icons.grid_view_rounded, color: Colors.blue),
              label: 'Menu',
            ),
          ],
        ),
      ),
    );
  }
}