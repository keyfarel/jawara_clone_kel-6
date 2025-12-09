import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../layouts/pages_layout.dart';
import '../../../../widgets/header_card/double_header_card_widget.dart';
import '../../../../widgets/chart/doughnut_chart_widget.dart';
import '../../../../widgets/chart/pie_chart_widget.dart';
import '../../../../widgets/chart/bar_chart_widget.dart';

import '../../controllers/dashboard_controller.dart';

class KegiatanPage extends StatefulWidget {
  const KegiatanPage({super.key});

  @override
  State<KegiatanPage> createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().loadActivity();
    });
  }

  // Helper Warna Random
  Color _getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final data = controller.activityData;
    final isLoading = controller.isActivityLoading;

    if (isLoading) {
      return const PageLayout(title: 'Kegiatan', body: Center(child: CircularProgressIndicator()));
    }

    if (data == null) {
      return const PageLayout(title: 'Kegiatan', body: Center(child: Text("Data kegiatan tidak tersedia")));
    }

    // --- MAPPING DATA FOR CHARTS ---

    // 1. Distribusi Waktu (Pie Chart) - Dari field terpisah di Model
    final List<Map<String, dynamic>> kegiatanWaktuData = [
      {
        'kategori': 'Selesai',
        'value': data.completeActivities,
        'color': Colors.green,
      },
      {
        'kategori': 'Berlangsung',
        'value': data.ongoingActivities,
        'color': Colors.orangeAccent,
      },
      {
        'kategori': 'Akan Datang',
        'value': data.upcomingActivities,
        'color': Colors.blueAccent,
      },
      {
        'kategori': 'Dibatalkan',
        'value': data.cancelledActivities,
        'color': Colors.redAccent,
      },
    ].where((e) => (e['value'] as int) > 0).toList(); // Hanya tampilkan yang > 0

    // 2. Jenis Kegiatan (Doughnut Chart) - Dari Map
    final List<Map<String, dynamic>> jenisKegiatanData = data.typeOfActivity.entries.map((e) {
      return {
        'kategori': e.key,
        'value': e.value,
        'color': _getRandomColor(),
      };
    }).toList();

    // 3. Kegiatan per Bulan (Bar Chart) - Dari Map
    // Sort bulan jika perlu (API biasanya return key string "November", sorting manual agak tricky kalau API tidak kirim index bulan)
    // Asumsi: API mengirim bulan secara urut atau kita tampilkan apa adanya.
    final List<Map<String, dynamic>> barChartData = data.activitiesPerMonth.entries.map((e) {
      return {
        'bulan': e.key.substring(0, 3), // Ambil 3 huruf (Nov)
        'value': e.value,
        'color': Colors.indigoAccent,
      };
    }).toList();


    return PageLayout(
      title: 'Kegiatan',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // --- Card Statistik Utama ---
            DoubleHeaderCardWidget(
              leftIcon: Icons.event_available,
              leftTitle: 'Total Kegiatan',
              leftValue: '${data.totalActivities}',
              rightIcon: Icons.play_circle_fill,
              rightTitle: 'Sedang Berlangsung',
              rightValue: '${data.ongoingActivities}',
            ),

            const SizedBox(height: 16),

            DoubleHeaderCardWidget(
              leftIcon: Icons.check_circle,
              leftTitle: 'Kegiatan Selesai',
              leftValue: '${data.completeActivities}',
              rightIcon: Icons.update,
              rightTitle: 'Akan Datang',
              rightValue: '${data.upcomingActivities}',
            ),

            const SizedBox(height: 24),
            const Divider(),

            // 🔹 Pie Chart - Status Waktu
            if (kegiatanWaktuData.isNotEmpty) ...[
              const SizedBox(height: 12),
              PieChartWidget(
                icon: Icons.access_time,
                title: 'Status Pelaksanaan',
                data: kegiatanWaktuData,
              ),
              const SizedBox(height: 24),
              const Divider(),
            ],

            // 🔹 Doughnut Chart - Jenis Kegiatan
            if (jenisKegiatanData.isNotEmpty) ...[
              const SizedBox(height: 12),
              DoughnutChartWidget(
                icon: Icons.category,
                title: 'Jenis Kegiatan',
                data: jenisKegiatanData,
              ),
              const SizedBox(height: 24),
              const Divider(),
            ],

            // 🔹 Bar Chart - Per Bulan
            if (barChartData.isNotEmpty) ...[
              const SizedBox(height: 12),
              BarChartWidget(
                icon: Icons.bar_chart,
                title: 'Kegiatan per Bulan',
                data: barChartData,
              ),
            ] else 
               const Center(child: Padding(
                 padding: EdgeInsets.all(16.0),
                 child: Text("Belum ada data bulanan"),
               )),
               
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}