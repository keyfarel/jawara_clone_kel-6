import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/layouts/pages_layout.dart';
import '../../../../widgets/header_card/double_header_card_widget.dart';
import '../../../../widgets/chart/bar_chart_widget.dart';
import '../../../../widgets/chart/pie_chart_widget.dart';
import '../../../../widgets/chart/doughnut_chart_widget.dart';

import '../../controllers/dashboard_controller.dart';

class KeuanganPage extends StatefulWidget {
  const KeuanganPage({super.key});

  @override
  State<KeuanganPage> createState() => _KeuanganPageState();
}

class _KeuanganPageState extends State<KeuanganPage> {
  @override
  void initState() {
    super.initState();
    // Load data awal dengan cache
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().loadFinancial();
    });
  }

  // Fungsi Refresh
  Future<void> _handleRefresh() async {
    // Paksa load ulang data keuangan (abaikan cache)
    // Anda mungkin perlu update controller agar loadFinancial mendukung parameter 'force' juga
    // Jika belum, panggil loadFinancial biasa (tapi sebaiknya update controller)
    await context.read<DashboardController>().loadFinancial();
  }

  // Format IDR Singkat (Rp 15jt, Rp 500rb)
  String _formatCurrencyShort(double value) {
    double absVal = value.abs();
    if (absVal >= 1000000000)
      return 'Rp ${(value / 1000000000).toStringAsFixed(1)} M';
    if (absVal >= 1000000)
      return 'Rp ${(value / 1000000).toStringAsFixed(1)} jt';
    if (absVal >= 1000) return 'Rp ${(value / 1000).toStringAsFixed(0)} rb';
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
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
            "Belum ada data transaksi",
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
              "Cek koneksi internet Anda.",
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

  // --- Widget: Empty State (Data Kosong) ---
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: Colors.blue.shade200,
            ),
            const SizedBox(height: 24),
            const Text(
              "Belum Ada Data Keuangan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Data pemasukan dan pengeluaran akan muncul di sini.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text("Muat Ulang"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final data = controller.financialData;
    final isLoading = controller.isFinancialLoading;

    return PageLayout(
      title: 'Keuangan',
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (data == null)
          ? _buildEmptyState() // Tampilkan Empty State jika data null
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              color: Colors.blue,
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(), // Agar bisa di-pull refresh meski konten sedikit
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // --- 1. Statistik Utama ---
                    DoubleHeaderCardWidget(
                      leftIcon: Icons.arrow_upward_rounded,
                      leftTitle: 'Pemasukan',
                      leftValue: _formatCurrencyShort(data.totalIncome),
                      rightIcon: Icons.arrow_downward_rounded,
                      rightTitle: 'Pengeluaran',
                      rightValue: _formatCurrencyShort(data.totalExpense),
                    ),

                    const SizedBox(height: 16),

                    DoubleHeaderCardWidget(
                      leftIcon: Icons.account_balance_wallet_rounded,
                      leftTitle: 'Saldo Akhir',
                      leftValue: _formatCurrencyShort(data.totalCash),
                      rightIcon: Icons.receipt_long_rounded,
                      rightTitle: 'Transaksi',
                      rightValue: '${data.transactions}',
                    ),

                    const SizedBox(height: 24),
                    const Divider(thickness: 0.5),

                    // --- 2. Chart Pemasukan per Bulan ---
                    const SizedBox(height: 12),
                    Builder(
                      builder: (_) {
                        if (data.incomePerMonth.isEmpty) {
                          return _buildEmptyChartPlaceholder(
                            "Pemasukan Bulanan",
                            Icons.calendar_month,
                          );
                        }
                        return BarChartWidget(
                          icon: Icons.trending_up_rounded,
                          title: 'Pemasukan per Bulan',
                          data: data.incomePerMonth.entries
                              .map(
                                (e) => {
                                  'bulan': e.key,
                                  'value': e.value,
                                  'label': _formatCurrencyShort(e.value),
                                  'color': Colors.greenAccent.shade700,
                                },
                              )
                              .toList(),
                          formatAxisLabel: (val) => _formatCurrencyShort(val),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    const Divider(thickness: 0.5),

                    // --- 3. Chart Pengeluaran per Bulan ---
                    const SizedBox(height: 12),
                    Builder(
                      builder: (_) {
                        if (data.expensePerMonth.isEmpty) {
                          return _buildEmptyChartPlaceholder(
                            "Pengeluaran Bulanan",
                            Icons.calendar_month,
                          );
                        }
                        return BarChartWidget(
                          icon: Icons.trending_down_rounded,
                          title: 'Pengeluaran per Bulan',
                          data: data.expensePerMonth.entries
                              .map(
                                (e) => {
                                  'bulan': e.key,
                                  'value': e.value,
                                  'label': _formatCurrencyShort(e.value),
                                  'color': Colors.redAccent.shade700,
                                },
                              )
                              .toList(),
                          formatAxisLabel: (val) => _formatCurrencyShort(val),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    const Divider(thickness: 0.5),

                    // --- 4. Doughnut Chart: Pemasukan Kategori ---
                    const SizedBox(height: 12),
                    Builder(
                      builder: (_) {
                        if (data.incomePerCategory.isEmpty) {
                          return _buildEmptyChartPlaceholder(
                            "Kategori Pemasukan",
                            Icons.pie_chart_outline,
                          );
                        }
                        return DoughnutChartWidget(
                          icon: Icons.category_rounded,
                          title: 'Kategori Pemasukan',
                          data: data.incomePerCategory.entries
                              .map(
                                (e) => {
                                  'kategori': e
                                      .key, // Nama Kategori (ID jika API kirim ID)
                                  'value': e.value,
                                  'color': Colors
                                      .greenAccent, // Anda bisa tambah logic warna random
                                },
                              )
                              .toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    const Divider(thickness: 0.5),

                    // --- 5. Pie Chart: Pengeluaran Kategori ---
                    const SizedBox(height: 12),
                    Builder(
                      builder: (_) {
                        if (data.expensePerCategory.isEmpty) {
                          return _buildEmptyChartPlaceholder(
                            "Kategori Pengeluaran",
                            Icons.pie_chart,
                          );
                        }
                        return PieChartWidget(
                          icon: Icons.category_outlined,
                          title: 'Kategori Pengeluaran',
                          data: data.expensePerCategory.entries
                              .map(
                                (e) => {
                                  'kategori': e.key,
                                  'value': e.value,
                                  'color': Colors.orangeAccent,
                                },
                              )
                              .toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}
