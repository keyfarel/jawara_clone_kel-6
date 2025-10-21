import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';
import '../../../widgets/header_card/double_header_card_widget.dart';
import '../../../widgets/chart/doughnut_chart_widget.dart';
import '../../../widgets/chart/pie_chart_widget.dart';
import '../../../widgets/chart/bar_chart_widget.dart';

class KegiatanPage extends StatelessWidget {
  const KegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data untuk doughnut chart
    final List<Map<String, dynamic>> kegiatanWaktuData = [
          {
            'kategori': 'Sudah Lewat',
            'value': 12,
            'color': Colors.redAccent,
          },
          {
            'kategori': 'Hari Ini',
            'value': 8,
            'color': Colors.orangeAccent,
          },
          {
            'kategori': 'Akan Datang',
            'value': 15,
            'color': Colors.blueAccent,
          },
    ];
    
    final List<Map<String, dynamic>> kegiatanData = [
      {
        'kategori': 'Komunitas & Sosial',
        'value': 12,
        'color': Colors.blueAccent,
      },
      {
        'kategori': 'Kebersihan & Keamanan',
        'value': 8,
        'color': Colors.green,
      },
      {
        'kategori': 'Keagamaan',
        'value': 15,
        'color': Colors.orange,
      },
      {
        'kategori': 'Pendidikan',
        'value': 10,
        'color': Colors.purple,
      },
      {
        'kategori': 'Kesehatan & Olahraga',
        'value': 7,
        'color': Colors.redAccent,
      },
      {
        'kategori': 'Lainnya',
        'value': 5,
        'color': Colors.grey,
      },
    ];

    // Data untuk bar chart (dummy)
    final List<Map<String, dynamic>> barChartData = [
      {'bulan': 'Jan', 'value': 8, 'color': Colors.blueAccent},
      {'bulan': 'Feb', 'value': 6, 'color': Colors.green},
      {'bulan': 'Mar', 'value': 10, 'color': Colors.orange},
      {'bulan': 'Apr', 'value': 12, 'color': Colors.purple},
      {'bulan': 'Mei', 'value': 7, 'color': Colors.redAccent},
      {'bulan': 'Jun', 'value': 11, 'color': Colors.teal},
      {'bulan': 'Jul', 'value': 9, 'color': Colors.cyan},
      {'bulan': 'Agu', 'value': 13, 'color': Colors.amber},
      {'bulan': 'Sep', 'value': 6, 'color': Colors.deepOrange},
      {'bulan': 'Okt', 'value': 10, 'color': Colors.indigo},
      {'bulan': 'Nov', 'value': 14, 'color': Colors.pinkAccent},
      {'bulan': 'Des', 'value': 9, 'color': Colors.lime},
    ];

    return PageLayout(
      title: 'Kegiatan',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 12),

            // --- Gunakan DoubleHeaderCardWidget ---
            const DoubleHeaderCardWidget(
              leftIcon: Icons.event_available,
              leftTitle: 'Total Kegiatan',
              leftValue: '57',
              rightIcon: Icons.play_circle_fill,
              rightTitle: 'Kegiatan Aktif',
              rightValue: '24',
            ),

            const SizedBox(height: 16),

            const DoubleHeaderCardWidget(
              leftIcon: Icons.check_circle,
              leftTitle: 'Kegiatan Selesai',
              leftValue: '33',
              rightIcon: Icons.pending_actions,
              rightTitle: 'Sedang Berlangsung',
              rightValue: '10',
            ),

            const SizedBox(height: 24),
            const Divider(),

            // 🔹 Section Pie Chart
            const SizedBox(height: 12),
            PieChartWidget(
              icon: Icons.event_available,
              title: 'Distribusi Jenis Kegiatan',
              data: kegiatanWaktuData,
            ),

            const SizedBox(height: 24),
            const Divider(),

            // 🔹 Section Doughnut Chart
            const SizedBox(height: 12),
            DoughnutChartWidget(
              icon: Icons.event_note,
              title: 'Distribusi Jenis Kegiatan',
              data: kegiatanData,
            ),

            const SizedBox(height: 24),
            const Divider(),

            // 🔹 Section Bar Chart
            const SizedBox(height: 12),
            BarChartWidget(
              icon: Icons.bar_chart,
              title: 'Kegiatan per Bulan (2025)',
              data: barChartData,
            ),
          ],
        ),
      ),
    );
  }
}