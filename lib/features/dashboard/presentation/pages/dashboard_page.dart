import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// --- Widget Imports (Pastikan path import sesuai struktur project Anda) ---
import '../../../../layouts/pages_layout.dart';
import '../../../../widgets/header_card/double_header_card_widget.dart';
import '../../../../widgets/chart/doughnut_chart_widget.dart';
import '../../../../widgets/chart/bar_chart_widget.dart';
import '../../../../widgets/chart/pie_chart_widget.dart';
import '../../../../widgets/card/quick_access_widget.dart';
import '../../../../widgets/card/recent_activity_widget.dart';

// Controller
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
    // Load data awal dengan cache
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().loadDashboard();
    });
  }

  // Fungsi Refresh (Force Load)
  Future<void> _handleRefresh() async {
    await context.read<DashboardController>().loadDashboard(force: true);
  }

  // Helper Format Rupiah Singkat (Rp 5jt, Rp 100rb)
  String _formatCurrencyShort(double value) {
    if (value.abs() >= 1000000000)
      return 'Rp ${(value / 1000000000).toStringAsFixed(1)} M';
    if (value.abs() >= 1000000)
      return 'Rp ${(value / 1000000).toStringAsFixed(1)} jt';
    if (value.abs() >= 1000)
      return 'Rp ${(value / 1000).toStringAsFixed(0)} rb';
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  // Helper Format Angka
  String _formatNumber(int value) {
    return NumberFormat.decimalPattern('id').format(value);
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            "Belum ada data statistik",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // --- Widget: Error State ---
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            const Text(
              "Gagal Memuat Data",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text("Coba Lagi"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final data = controller.data;
    final isLoading = controller.isLoading;

    final List<Map<String, dynamic>> quickAccess = [
      {
        'icon': Icons.account_balance_wallet,
        'label': 'Keuangan',
        'color': Colors.green.shade100,
        'route': '/keuangan',
      },
      {
        'icon': Icons.event,
        'label': 'Kegiatan',
        'color': Colors.orange.shade100,
        'route': '/kegiatan',
      },
      {
        'icon': Icons.people,
        'label': 'Penduduk',
        'color': Colors.blue.shade100,
        'route': '/kependudukan',
      },
    ];

    return PageLayout(
      title: 'Dashboard',
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.errorMessage != null
          ? _buildErrorState(controller.errorMessage!)
          : (data == null)
          ? _buildErrorState("Data kosong")
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              color: Colors.blue,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Double Header Card
                    DoubleHeaderCardWidget(
                      leftIcon: Icons.people_alt_rounded,
                      leftTitle: 'Penduduk',
                      leftValue: _formatNumber(data.population.total),
                      rightIcon: Icons.home_work_rounded,
                      rightTitle: 'Keluarga',
                      rightValue: _formatNumber(data.totalFamilies),
                    ),
                    const SizedBox(height: 12),

                    DoubleHeaderCardWidget(
                      leftIcon: Icons.event_available_rounded,
                      leftTitle: 'Kegiatan',
                      leftValue: _formatNumber(data.activityStats.total),
                      rightIcon: Icons.account_balance_wallet_rounded,
                      rightTitle: 'Kas Warga',
                      rightValue: _formatCurrencyShort(data.cash.totalCash),
                    ),

                    const SizedBox(height: 24),
                    const Divider(thickness: 0.5),

                    // 2. CHART SECTION

                    // A. Gender Chart
                    Builder(
                      builder: (_) {
                        if (data.population.total == 0) {
                          return _buildEmptyChartPlaceholder(
                            "Distribusi Gender",
                            Icons.wc,
                          );
                        }
                        return DoughnutChartWidget(
                          icon: Icons.wc,
                          title: 'Gender',
                          data: [
                            {
                              'kategori': 'Laki-laki',
                              'value': data.population.male.toDouble(),
                              'color': Colors.blueAccent,
                            },
                            {
                              'kategori': 'Perempuan',
                              'value': data.population.female.toDouble(),
                              'color': Colors.pinkAccent,
                            },
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // B. Keuangan Chart
                    Builder(
                      builder: (_) {
                        if (data.cash.income == 0 && data.cash.expense == 0) {
                          return _buildEmptyChartPlaceholder(
                            "Statistik Keuangan",
                            Icons.bar_chart_rounded,
                          );
                        }
                        return BarChartWidget(
                          icon: Icons.bar_chart_rounded,
                          title: 'Pemasukan vs Pengeluaran',
                          data: [
                            {
                              'bulan': 'Masuk',
                              'value': data.cash.income,
                              'color': Colors.green,
                            },
                            {
                              'bulan': 'Keluar',
                              'value': data.cash.expense,
                              'color': Colors.redAccent,
                            },
                          ],
                          formatAxisLabel: (val) => _formatCurrencyShort(val),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // C. Status Kegiatan
                    Builder(
                      builder: (_) {
                        if (data.activityStats.total == 0) {
                          return _buildEmptyChartPlaceholder(
                            "Status Kegiatan",
                            Icons.event_note,
                          );
                        }
                        return PieChartWidget(
                          icon: Icons.event_note,
                          title: 'Status Kegiatan',
                          data: [
                            {
                              'kategori': 'Selesai',
                              'value': data.activityStats.completed.toDouble(),
                              'color': Colors.green,
                            },
                            {
                              'kategori': 'Berjalan',
                              'value': data.activityStats.ongoing.toDouble(),
                              'color': Colors.orange,
                            },
                            {
                              'kategori': 'Nanti',
                              'value': data.activityStats.upcoming.toDouble(),
                              'color': Colors.blue,
                            },
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // 3. Kegiatan Terbaru
                    if (data.newActivities.isNotEmpty)
                      RecentActivityWidget(
                        title: 'Kegiatan Terbaru',
                        icon: Icons.new_releases_rounded,
                        iconColor: Colors.orange,
                        labelColor: Colors.deepOrange,
                        activities: data.newActivities
                            .map(
                              (e) => {
                                'judul': e,
                                'tanggal': 'Baru ditambahkan',
                                'status': 'New',
                              },
                            )
                            .toList(),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.grey),
                            SizedBox(width: 12),
                            Text(
                              "Belum ada kegiatan baru",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // 4. Quick Access
                    QuickAccessWidget(
                      title: 'Akses Cepat',
                      icon: Icons.bolt_rounded,
                      quickAccess: quickAccess,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}
