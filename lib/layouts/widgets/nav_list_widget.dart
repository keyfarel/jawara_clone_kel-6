import 'package:flutter/material.dart';
import '../../models/nav_item.dart';

class NavListWidget extends StatefulWidget {
  const NavListWidget({super.key});

  @override
  State<NavListWidget> createState() => _NavListWidgetState();
}

class _NavListWidgetState extends State<NavListWidget>
    with TickerProviderStateMixin {
  final Map<int, bool> _expanded = {};
  final Map<int, AnimationController> _controllers = {};

  List<NavItem> get menuItems => const [
        NavItem(
          title: "Dashboard",
          icon: Icons.dashboard,
          children: ["Keuangan", "Kegiatan", "Kependudukan"],
        ),
        NavItem(
          title: "Data Warga & Rumah",
          icon: Icons.home,
          children: [
            "Warga - Daftar",
            "Warga - Tambah",
            "Keluarga",
            "Rumah - Daftar",
            "Rumah - Tambah",
          ],
        ),
        NavItem(
          title: "Pemasukan",
          icon: Icons.attach_money,
          children: [
            "Kategori Iuran",
            "Tagih Iuran",
            "Tagihan",
            "Pemasukan Lain - Daftar",
            "Pemasukan Lain - Tambah",
          ],
        ),
        NavItem(
          title: "Pengeluaran",
          icon: Icons.money_off,
          children: ["Daftar", "Tambah"],
        ),
        NavItem(
          title: "Laporan Keuangan",
          icon: Icons.bar_chart,
          children: ["Semua Pemasukan", "Semua Pengeluaran", "Cetak Laporan"],
        ),
        NavItem(
          title: "Kegiatan & Broadcast",
          icon: Icons.campaign,
          children: [
            "Kegiatan - Daftar",
            "Kegiatan - Tambah",
            "Broadcast - Daftar",
            "Broadcast - Tambah",
          ],
        ),
        NavItem(
          title: "Pesan Warga",
          icon: Icons.message,
          children: ["Informasi Aspirasi"],
        ),
        NavItem(
          title: "Penerimaan Warga",
          icon: Icons.people,
          children: ["Penerimaan Warga"],
        ),
        NavItem(
          title: "Mutasi Keluarga",
          icon: Icons.sync_alt,
          children: ["Daftar", "Tambah"],
        ),
        NavItem(
          title: "Log Aktifitas",
          icon: Icons.history,
          children: ["Semua Aktifitas"],
        ),
        NavItem(
          title: "Manajemen Pengguna",
          icon: Icons.manage_accounts,
          children: ["Daftar Pengguna", "Tambah Pengguna"],
        ),
        NavItem(
          title: "Channel Transfer",
          icon: Icons.send,
          children: ["Daftar Channel", "Tambah Channel"],
        ),
      ];

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double parentFontSize = 14;
    const double childFontSize = 13;
    const double iconSize = 18;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];

        // pastikan tiap index punya controller animasi sendiri
        _controllers.putIfAbsent(
          index,
          () => AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 200),
          ),
        );

        final controller = _controllers[index]!;
        final rotation =
            Tween<double>(begin: 0.0, end: 0.25).animate(controller); // 0.25 = 90°

        final isExpanded = _expanded[index] ?? false;

        if (item.children == null || item.children!.isEmpty) {
          return ListTile(
            dense: true,
            leading: Icon(item.icon ?? Icons.circle,
                size: iconSize, color: Colors.blue.shade700),
            title: Text(
              item.title,
              style: const TextStyle(
                fontSize: parentFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
            onTap: () => Navigator.pop(context),
          );
        } else {
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              key: Key(index.toString()),
              initiallyExpanded: isExpanded,
              onExpansionChanged: (value) {
                setState(() {
                  _expanded[index] = value;
                  if (value) {
                    controller.forward();
                  } else {
                    controller.reverse();
                  }
                });
              },
              leading: Icon(item.icon ?? Icons.folder,
                  size: iconSize, color: Colors.blue.shade700),
              title: Text(
                item.title,
                style: const TextStyle(
                  fontSize: parentFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Animasi rotasi ikon ">"
              trailing: RotationTransition(
                turns: rotation,
                child: Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: Colors.grey.shade600,
                ),
              ),
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding:
                  const EdgeInsets.only(left: 16.0, bottom: 4.0, right: 8.0),
              children: item.children!
                  .map(
                    (child) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 9.0, right: 12),
                          child: Container(
                            width: 1,
                            height: 32,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            dense: true,
                            visualDensity:
                                const VisualDensity(horizontal: 0, vertical: -3),
                            contentPadding:
                                const EdgeInsets.only(left: 4.0, right: 16.0),
                            title: Text(
                              child,
                              style: const TextStyle(
                                fontSize: childFontSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        }
      },
    );
  }
}
