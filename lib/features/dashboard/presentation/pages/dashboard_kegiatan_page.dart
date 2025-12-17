import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/layouts/pages_layout.dart';
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

  // Fungsi Refresh
  Future<void> _handleRefresh() async {
    // Pastikan controller mendukung force refresh atau panggil ulang
    await context.read<DashboardController>().loadActivity(force: true);
  }

  // Helper Warna Random (Opsional, tapi lebih baik warna statis yang cantik)
  Color _getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  // --- Widget: Placeholder Chart Kosong ---
  Widget _buildEmptyChartPlaceholder(String title, IconData icon) {
    return Container(
      height: 250,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
            child: Icon(icon, size: 32, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text("Belum ada data statistik", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        ],
      ),
    );
  }

  // --- Widget: Empty State (Halaman Kosong) ---
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_rounded, size: 80, color: Colors.orange.shade200),
            const SizedBox(height: 24),
            const Text("Belum Ada Data Kegiatan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "Statistik kegiatan warga akan muncul di sini.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text("Muat Ulang"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final data = controller.activityData;
    final isLoading = controller.isActivityLoading;

    // --- Loading State ---
    if (isLoading) {
      return const PageLayout(
        title: 'Kegiatan',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // --- Empty Data State ---
    if (data == null) {
      return PageLayout(title: 'Kegiatan', body: _buildEmptyState());
    }

    // --- MAPPING DATA FOR CHARTS ---

    // 1. Distribusi Waktu (Pie Chart)
    final List<Map<String, dynamic>> kegiatanWaktuData = [
      {'kategori': 'Selesai', 'value': data.completeActivities, 'color': Colors.green},
      {'kategori': 'Berlangsung', 'value': data.ongoingActivities, 'color': Colors.orange},
      {'kategori': 'Akan Datang', 'value': data.upcomingActivities, 'color': Colors.blue},
      {'kategori': 'Dibatalkan', 'value': data.cancelledActivities, 'color': Colors.red},
    ].where((e) => (e['value'] as int) > 0).toList();

    // 2. Jenis Kegiatan (Doughnut Chart)
    final List<Map<String, dynamic>> jenisKegiatanData = data.typeOfActivity.entries.map((e) {
      return {
        'kategori': e.key,
        'value': e.value,
        'color': Colors.indigoAccent, // Atau random color
      };
    }).toList();

    // 3. Kegiatan per Bulan (Bar Chart)
    final List<Map<String, dynamic>> barChartData = data.activitiesPerMonth.entries.map((e) {
      return {
        'bulan': e.key.length > 3 ? e.key.substring(0, 3) : e.key,
        'value': e.value,
        'color': Colors.blueAccent,
      };
    }).toList();


    return PageLayout(
      title: 'Kegiatan',
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Colors.blue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Agar bisa di-pull refresh
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // --- Card Statistik Utama ---
              DoubleHeaderCardWidget(
                leftIcon: Icons.event_available_rounded,
                leftTitle: 'Total Kegiatan',
                leftValue: '${data.totalActivities}',
                rightIcon: Icons.play_circle_fill_rounded,
                rightTitle: 'Berlangsung',
                rightValue: '${data.ongoingActivities}',
              ),

              const SizedBox(height: 16),

              DoubleHeaderCardWidget(
                leftIcon: Icons.check_circle_rounded,
                leftTitle: 'Selesai',
                leftValue: '${data.completeActivities}',
                rightIcon: Icons.calendar_month_rounded,
                rightTitle: 'Akan Datang',
                rightValue: '${data.upcomingActivities}',
              ),

              const SizedBox(height: 24),
              const Divider(thickness: 0.5),

              // 🔹 Pie Chart - Status Pelaksanaan
              const SizedBox(height: 12),
              Builder(builder: (_) {
                if (kegiatanWaktuData.isEmpty) {
                  return _buildEmptyChartPlaceholder("Status Pelaksanaan", Icons.access_time_filled);
                }
                return PieChartWidget(
                  icon: Icons.access_time_filled_rounded,
                  title: 'Status Pelaksanaan',
                  data: kegiatanWaktuData,
                );
              }),

              const SizedBox(height: 24),
              const Divider(thickness: 0.5),

              // 🔹 Doughnut Chart - Jenis Kegiatan
              const SizedBox(height: 12),
              Builder(builder: (_) {
                if (jenisKegiatanData.isEmpty) {
                  return _buildEmptyChartPlaceholder("Jenis Kegiatan", Icons.category_rounded);
                }
                return DoughnutChartWidget(
                  icon: Icons.category_rounded,
                  title: 'Jenis Kegiatan',
                  data: jenisKegiatanData,
                );
              }),

              const SizedBox(height: 24),
              const Divider(thickness: 0.5),

              // 🔹 Bar Chart - Per Bulan
              const SizedBox(height: 12),
              Builder(builder: (_) {
                if (barChartData.isEmpty) {
                  return _buildEmptyChartPlaceholder("Kegiatan per Bulan", Icons.bar_chart_rounded);
                }
                return BarChartWidget(
                  icon: Icons.bar_chart_rounded,
                  title: 'Kegiatan per Bulan',
                  data: barChartData,
                );
              }),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}