import 'package:flutter/material.dart';
import 'package:myapp/widgets/chart/doughnut_chart_widget.dart';
import 'package:myapp/widgets/header_card/double_header_card_widget.dart';
import '../../../layouts/pages_layout.dart';

class KependudukanPage extends StatelessWidget {
  const KependudukanPage({super.key});

  @override
  Widget build(BuildContext context) {

    // --- Data Dummy ---
    final String totalKeluarga = '10';
    final String totalPenduduk = '13';

    final List<Map<String, dynamic>> statusPenduduk = [
      {'kategori': 'Aktif', 'value': 85, 'color': Colors.greenAccent},
      {'kategori': 'Nonaktif', 'value': 15, 'color': Colors.redAccent},
    ];

    final List<Map<String, dynamic>> jenisKelamin = [
      {'kategori': 'Laki-laki', 'value': 85, 'color': Colors.blueAccent},
      {'kategori': 'Perempuan', 'value': 15, 'color': Colors.pinkAccent},
    ];

    final List<Map<String, dynamic>> pekerjaanPenduduk = [
      {'kategori': 'Lainnya', 'value': 50, 'color': Colors.grey},
      {'kategori': 'Pelajar', 'value': 50, 'color': Colors.orangeAccent},
    ];

    final List<Map<String, dynamic>> peranKeluarga = [
      {'kategori': 'Kepala Keluarga', 'value': 77, 'color': Colors.blueGrey},
      {'kategori': 'Anak', 'value': 15, 'color': Colors.lightBlueAccent},
      {'kategori': 'Anggota Lain', 'value': 8, 'color': Colors.cyan},
    ];

    final List<Map<String, dynamic>> agama = [
      {'kategori': 'Islam', 'value': 75, 'color': Colors.greenAccent},
      {'kategori': 'Katolik', 'value': 25, 'color': Colors.purpleAccent},
    ];

    final List<Map<String, dynamic>> pendidikan = [
      {'kategori': 'Sarjana/Diploma', 'value': 75, 'color': Colors.indigoAccent},
      {'kategori': 'SD', 'value': 25, 'color': Colors.lightGreen},
    ];

    return PageLayout(
      title: 'Kependudukan',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // --- TODO: Section Card Statistik Utama (Total Keluarga & Total Penduduk) ---
            DoubleHeaderCardWidget(
              leftIcon: Icons.group,
              leftTitle: 'Total Keluarga',
              leftValue: totalKeluarga,
              rightIcon: Icons.person,
              rightTitle: 'Total Penduduk',
              rightValue: totalPenduduk,
            ),

            const SizedBox(height: 24),
            const Divider(),

            // --- Section Doughnut Chart - Status Penduduk ---
            DoughnutChartWidget(
              icon: Icons.info,
              title: 'Status Penduduk',
              data: statusPenduduk,
            ),

            const SizedBox(height: 24),
            const Divider(),

            // --- Section Doughnut Chart - Jenis Kelamin ---
            DoughnutChartWidget(
              icon: Icons.wc,
              title: 'Jenis Kelamin',
              data: jenisKelamin,
            ),

            const SizedBox(height: 24),
            const Divider(),

            // --- Section Pie Chart - Pekerjaan Penduduk ---
            DoughnutChartWidget(
              icon: Icons.work,
              title: 'Pekerjaan Penduduk',
              data: pekerjaanPenduduk,
            ),

            const SizedBox(height: 24),
            const Divider(),

            // --- Section Pie Chart - Peran dalam Keluarga ---
            DoughnutChartWidget(
              icon: Icons.family_restroom,
              title: 'Peran dalam Keluarga',
              data: peranKeluarga,
            ),

            const SizedBox(height: 24),
            const Divider(),

            // --- Section Pie Chart - Agama ---
            DoughnutChartWidget(
              icon: Icons.account_balance,
              title: 'Agama',
              data: agama,
            ),

            const SizedBox(height: 24),
            const Divider(),

            // --- Section Pie Chart - Pendidikan ---
            DoughnutChartWidget(
              icon: Icons.school,
              title: 'Pendidikan',
              data: pendidikan,
            ),
          ],
        ),
      ),
    );
  }
}