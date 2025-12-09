import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // flutter pub add intl

// Widget Imports
import '../../../../layouts/pages_layout.dart';
import '../../../../widgets/header_card/double_header_card_widget.dart';
import '../../../../widgets/chart/doughnut_chart_widget.dart';
import '../../../../widgets/chart/bar_chart_widget.dart';
import '../../../../widgets/chart/pie_chart_widget.dart';
import '../../../../widgets/card/quick_access_widget.dart';
import '../../../../widgets/card/recent_activity_widget.dart';

// Controller Import
import '../../controllers/dashboard_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load data saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().loadDashboard();
    });
  }

  // Helper format uang (Rp 5jt)
  String _formatCurrencyShort(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)} M';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)} jt';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)} rb';
    }
    return value.toStringAsFixed(0);
  }

  // Helper format angka ribuan (1.500)
  String _formatNumber(num value) {
    return NumberFormat.decimalPattern('id').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final data = controller.data;
    final isLoading = controller.isLoading;

    // --- Tombol Navigasi Cepat (Static Navigation) ---
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.errorMessage != null
          ? Center(child: Text("Gagal memuat data: ${controller.errorMessage}"))
          : data == null
          ? const Center(child: Text("Tidak ada data dashboard"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Statistik Utama ---
                  const SizedBox(height: 12),
                  DoubleHeaderCardWidget(
                    leftIcon: Icons.people,
                    leftTitle: 'Total Penduduk',
                    leftValue: _formatNumber(data.population.total),
                    rightIcon: Icons.family_restroom,
                    rightTitle: 'Total Keluarga',
                    rightValue: _formatNumber(data.totalFamilies),
                  ),

                  const SizedBox(height: 16),
                  DoubleHeaderCardWidget(
                    leftIcon: Icons.event_available,
                    leftTitle: 'Total Kegiatan',
                    leftValue: _formatNumber(data.activityStats.total),
                    rightIcon: Icons.account_balance_wallet,
                    rightTitle: 'Saldo Kas',
                    rightValue: _formatCurrencyShort(data.cash.totalCash),
                  ),

                  const SizedBox(height: 24),
                  const Divider(),

                  // --- Grafik Mini (Data Mapping) ---
                  const SizedBox(height: 12),
                  DoughnutChartWidget(
                    icon: Icons.wc,
                    title: 'Distribusi Jenis Kelamin',
                    data: [
                      {
                        'kategori': 'Laki-laki',
                        'value': data.population.male,
                        'color': Colors.blueAccent,
                      },
                      {
                        'kategori': 'Perempuan',
                        'value': data.population.female,
                        'color': Colors.pinkAccent,
                      },
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),

                  BarChartWidget(
                    icon: Icons.bar_chart,
                    title: 'Pemasukan vs Pengeluaran',
                    data: [
                      {
                        'bulan': 'Masuk',
                        'value': data.cash.income,
                        'color': Colors.greenAccent,
                      },
                      {
                        'bulan': 'Keluar',
                        'value': data.cash.expense,
                        'color': Colors.redAccent,
                      },
                    ],
                    formatAxisLabel: (value) => _formatCurrencyShort(value),
                  ),

                  const SizedBox(height: 24),
                  const Divider(),

                  PieChartWidget(
                    icon: Icons.event_note,
                    title: 'Status Kegiatan',
                    data: [
                      {
                        'kategori': 'Selesai',
                        'value': data.activityStats.completed,
                        'color': Colors.green,
                      },
                      {
                        'kategori': 'Berlangsung',
                        'value': data.activityStats.ongoing,
                        'color': Colors.orange,
                      },
                      {
                        'kategori': 'Akan Datang',
                        'value': data.activityStats.upcoming,
                        'color': Colors.blueAccent,
                      },
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),

                  // --- Daftar Kegiatan Terbaru ---
                  // API hanya return List<String>, kita mapping ke format widget
                  RecentActivityWidget(
                    title: 'Kegiatan Terbaru (Baru Dibuat)',
                    icon: Icons.new_releases,
                    iconColor: Colors.blueAccent,
                    labelColor: Colors.indigo,
                    activities: data.newActivities.map((activityName) {
                      return {
                        'judul': activityName,
                        'tanggal':
                            'Info Detail Lihat Menu', // Placeholder karena API cuma kirim nama
                        'status': 'Baru',
                      };
                    }).toList(),
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
