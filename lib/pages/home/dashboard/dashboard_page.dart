// file: home_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';
import '../../../widgets/header_card/double_header_card_widget.dart';
import '../../../widgets/chart/doughnut_chart_widget.dart';
import '../../../widgets/chart/bar_chart_widget.dart';
import '../../../widgets/chart/pie_chart_widget.dart';
import '../../../widgets/card/quick_access_widget.dart';
import '../../../widgets/card/recent_activity_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Data Dummy ---
    const totalPenduduk = '1.523';
    const totalKeluarga = '412';
    const totalKegiatan = '24';
    const saldoKas = '49,8 jt';

    final List<Map<String, dynamic>> jenisKelamin = [
      {'kategori': 'Laki-laki', 'value': 800, 'color': Colors.blueAccent},
      {'kategori': 'Perempuan', 'value': 723, 'color': Colors.pinkAccent},
    ];

    final List<Map<String, dynamic>> pemasukanVsPengeluaran = [
      {'bulan': 'masuk', 'value': 50, 'color': Colors.greenAccent},
      {'bulan': 'keluar', 'value': 15, 'color': Colors.redAccent},
    ];

    final List<Map<String, dynamic>> statusKegiatan = [
      {'kategori': 'Selesai', 'value': 12, 'color': Colors.green},
      {'kategori': 'Berlangsung', 'value': 6, 'color': Colors.orange},
      {'kategori': 'Akan Datang', 'value': 6, 'color': Colors.blueAccent},
    ];

    final List<Map<String, String>> kegiatanTerbaru = [
      {'judul': 'Rapat Bulanan RW', 'tanggal': '21 Okt 2025', 'status': 'Selesai'},
      {'judul': 'Kerja Bakti Lingkungan', 'tanggal': '27 Okt 2025', 'status': 'Akan Datang'},
      {'judul': 'Donor Darah Warga', 'tanggal': '5 Nov 2025', 'status': 'Berlangsung'},
    ];

    // --- Tombol Navigasi Cepat ---
    final List<Map<String, dynamic>> quickAccess = [
      {
        'icon': Icons.account_balance_wallet,
        'label': 'Lihat Keuangan',
        'color': Colors.greenAccent.shade100,
        'route': '/keuangan',
      },
      {
        'icon': Icons.event,
        'label': 'Kelola Kegiatan',
        'color': Colors.orangeAccent.shade100,
        'route': '/kegiatan',
      },
      {
        'icon': Icons.people,
        'label': 'Data Kependudukan',
        'color': Colors.blueAccent.shade100,
        'route': '/kependudukan',
      },
    ];

    return PageLayout(
      title: 'Dashboard',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Statistik Utama ---
            const SizedBox(height: 12),
            const DoubleHeaderCardWidget(
              leftIcon: Icons.people,
              leftTitle: 'Total Penduduk',
              leftValue: totalPenduduk,
              rightIcon: Icons.family_restroom,
              rightTitle: 'Total Keluarga',
              rightValue: totalKeluarga,
            ),

            const SizedBox(height: 16),
            const DoubleHeaderCardWidget(
              leftIcon: Icons.event_available,
              leftTitle: 'Total Kegiatan',
              leftValue: totalKegiatan,
              rightIcon: Icons.account_balance_wallet,
              rightTitle: 'Saldo Kas',
              rightValue: saldoKas,
            ),

            const SizedBox(height: 24),
            const Divider(),

            // --- Grafik Mini ---
            const SizedBox(height: 12),
            DoughnutChartWidget(
              icon: Icons.wc,
              title: 'Distribusi Jenis Kelamin',
              data: jenisKelamin,
            ),

            const SizedBox(height: 24),
            const Divider(),

            BarChartWidget(
              icon: Icons.bar_chart,
              title: 'Pemasukan vs Pengeluaran',
              data: pemasukanVsPengeluaran,
              formatAxisLabel: (value) => '${value.toStringAsFixed(0)} jt',
            ),

            const SizedBox(height: 24),
            const Divider(),

            PieChartWidget(
              icon: Icons.event_note,
              title: 'Status Kegiatan',
              data: statusKegiatan,
            ),

            const SizedBox(height: 24),
            const Divider(),

            // --- Daftar Kegiatan Terbaru ---
            RecentActivityWidget(
              title: 'Kegiatan Terbaru',
              icon: Icons.new_releases,
              iconColor: Colors.blueAccent,
              labelColor: Colors.indigo, // warna label bisa diatur di sini
              activities: kegiatanTerbaru,
            ),

            const SizedBox(height: 24),
            const Divider(),

            // Quick Akses 
            QuickAccessWidget(
              title: 'Navigasi Cepat',
              icon: Icons.flash_on,
              quickAccess: quickAccess,
            ),


            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
