import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../layouts/pages_layout.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().loadFinancial();
    });
  }

  // Format IDR (Rp 15.000)
  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  // Format Singkat (15 jt)
  String _formatCurrencyShort(double value) {
    if (value.abs() >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)} M';
    } else if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)} jt';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)} rb';
    }
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final data = controller.financialData;
    final isLoading = controller.isFinancialLoading;

    if (isLoading) {
      return const PageLayout(
        title: 'Keuangan',
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return const PageLayout(
        title: 'Keuangan',
        body: Center(child: Text("Data keuangan tidak tersedia")),
      );
    }

    // --- MAPPING DATA FOR CHARTS ---

    // 1. Pemasukan Per Bulan
    final List<Map<String, dynamic>> chartPemasukanBulan = data.incomePerMonth.entries.map((e) {
      return {
        'bulan': e.key, // Misal: "November"
        'value': e.value,
        'label': _formatCurrencyShort(e.value),
        'color': Colors.greenAccent,
      };
    }).toList();

    // 2. Pengeluaran Per Bulan
    final List<Map<String, dynamic>> chartPengeluaranBulan = data.expensePerMonth.entries.map((e) {
      return {
        'bulan': e.key,
        'value': e.value,
        'label': _formatCurrencyShort(e.value),
        'color': Colors.redAccent,
      };
    }).toList();

    // 3. Pemasukan Per Kategori
    final List<Map<String, dynamic>> chartPemasukanKategori = data.incomePerCategory.entries.map((e) {
      return {
        'kategori': e.key, // ID Kategori (butuh mapping nama jika ada)
        'value': e.value,
        'color': Colors.greenAccent, // Bisa dibuat random color generator
      };
    }).toList();

    // 4. Pengeluaran Per Kategori
    final List<Map<String, dynamic>> chartPengeluaranKategori = data.expensePerCategory.entries.map((e) {
      return {
        'kategori': e.key, 
        'value': e.value,
        'color': Colors.orangeAccent,
      };
    }).toList();


    return PageLayout(
      title: 'Keuangan',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // --- Section Card Statistik Utama ---
            DoubleHeaderCardWidget(
              leftIcon: Icons.arrow_upward,
              leftTitle: 'Total Pemasukan',
              leftValue: _formatCurrencyShort(data.totalIncome),
              rightIcon: Icons.arrow_downward,
              rightTitle: 'Total Pengeluaran',
              rightValue: _formatCurrencyShort(data.totalExpense),
            ),

            const SizedBox(height: 16),

            DoubleHeaderCardWidget(
              leftIcon: Icons.account_balance_wallet,
              leftTitle: 'Saldo Akhir',
              leftValue: _formatCurrencyShort(data.totalCash),
              rightIcon: Icons.receipt_long,
              rightTitle: 'Jumlah Transaksi',
              rightValue: '${data.transactions}',
            ),

            const SizedBox(height: 24),
            const Divider(),

            // Section Bar Chart - Pemasukan per Bulan 
            const SizedBox(height: 12),
            if (chartPemasukanBulan.isNotEmpty)
              BarChartWidget(
                icon: Icons.arrow_upward,
                title: 'Pemasukan per Bulan',
                data: chartPemasukanBulan,
                formatAxisLabel: (value) => _formatCurrencyShort(value),
              )
            else 
              const Center(child: Text("Belum ada data pemasukan bulanan")),

            const SizedBox(height: 24),
            const Divider(),

            // Section Bar Chart - Pengeluaran per Bulan 
            const SizedBox(height: 12),
            if (chartPengeluaranBulan.isNotEmpty)
              BarChartWidget(
                icon: Icons.arrow_downward,
                title: 'Pengeluaran per Bulan',
                data: chartPengeluaranBulan,
                formatAxisLabel: (value) => _formatCurrencyShort(value),
              )
            else
              const Center(child: Text("Belum ada data pengeluaran bulanan")),

            // --- Doughnut Chart - Pemasukan Kategori ---
            if (chartPemasukanKategori.isNotEmpty) ...[
               const SizedBox(height: 24),
               const Divider(),
               DoughnutChartWidget(
                 icon: Icons.arrow_upward,
                 title: 'Pemasukan per Kategori',
                 data: chartPemasukanKategori,
               ),
            ],

            // --- Pie Chart - Pengeluaran Kategori ---
            if (chartPengeluaranKategori.isNotEmpty) ...[
               const SizedBox(height: 24),
               const Divider(),
               PieChartWidget(
                 icon: Icons.arrow_downward,
                 title: 'Pengeluaran Per Kategori',
                 data: chartPengeluaranKategori,
               ),
            ],
          ],
        ),
      ),
    );
  }
}