import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';
import '../../../widgets/header_card/double_header_card_widget.dart';
import '../../../widgets/chart/bar_chart_widget.dart';
import '../../../widgets/chart/pie_chart_widget.dart';
import '../../../widgets/chart/doughnut_chart_widget.dart';

class KeuanganPage extends StatelessWidget {
  const KeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {

    // data untuk chart dan card (dummy)
    final String totalPemasukan = '50 jt';
    final String totalPengeluaran = '152.1 rb';
    final String jumlahTransaksi = '7';
    final String saldoAkhir = '49.8 jt'; // Contoh perhitungan saldo

    final List<Map<String, dynamic>> pemasukanPerBulan = [
      {'bulan': 'Jan', 'value': 12000, 'label': '12 jt', 'color': Colors.greenAccent},
      {'bulan': 'Feb', 'value': 25000, 'label': '25 jt', 'color': Colors.greenAccent},
      {'bulan': 'Mar', 'value': 18000, 'label': '18 jt', 'color': Colors.greenAccent},
      {'bulan': 'Apr', 'value': 22000, 'label': '22 jt', 'color': Colors.greenAccent},
      {'bulan': 'Mei', 'value': 30000, 'label': '30 jt', 'color': Colors.greenAccent},
      {'bulan': 'Jun', 'value': 27000, 'label': '27 jt', 'color': Colors.greenAccent},
      {'bulan': 'Jul', 'value': 35000, 'label': '35 jt', 'color': Colors.greenAccent},
      {'bulan': 'Agu', 'value': 0, 'label': '0', 'color': Colors.greenAccent}, // tetap
      {'bulan': 'Sep', 'value': 40000, 'label': '40 jt', 'color': Colors.greenAccent},
      {'bulan': 'Okt', 'value': 15000, 'label': '15 jt', 'color': Colors.greenAccent}, // tetap
      {'bulan': 'Des', 'value': 60000, 'label': '60 jt', 'color': Colors.greenAccent}, // tetap
    ];

    final List<Map<String, dynamic>> pengeluaranPerBulan = [
      {'bulan': 'Jan', 'value': 10, 'label': '10 rb', 'color': Colors.redAccent},
      {'bulan': 'Feb', 'value': 12, 'label': '12 rb', 'color': Colors.redAccent},
      {'bulan': 'Mar', 'value': 14, 'label': '14 rb', 'color': Colors.redAccent},
      {'bulan': 'Apr', 'value': 16, 'label': '16 rb', 'color': Colors.redAccent},
      {'bulan': 'Mei', 'value': 18, 'label': '18 rb', 'color': Colors.redAccent},
      {'bulan': 'Jun', 'value': 20, 'label': '20 rb', 'color': Colors.redAccent},
      {'bulan': 'Jul', 'value': 15, 'label': '15 rb', 'color': Colors.redAccent},
      {'bulan': 'Agu', 'value': 13, 'label': '13 rb', 'color': Colors.redAccent},
      {'bulan': 'Sep', 'value': 17, 'label': '17 rb', 'color': Colors.redAccent},
      {'bulan': 'Okt', 'value': 160, 'label': '160 rb', 'color': Colors.redAccent}, // tetap
    ];

    final List<Map<String, dynamic>> pemasukanKategori = [
      {
        'kategori': 'Dana Bantuan Pemerintah',
        'value': 100,
        'color': Colors.greenAccent,
      },
      {
        'kategori': 'Pendapatan Lainnya',
        'value': 0,
        'color': Colors.grey,
      },
    ];

    final List<Map<String, dynamic>> pengeluaranKategori = [
      {
        'kategori': 'Operasional RT/RW',
        'value': 34,
        'color': Colors.orange,
      },
      {
        'kategori': 'Pemeliharaan Fasilitas',
        'value': 66,
        'color': Colors.purpleAccent,
      },
      {
        'kategori': 'Kegiatan Warga',
        'value': 0,
        'color': Colors.grey,
      },
    ];

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
              leftValue: totalPemasukan,
              rightIcon: Icons.arrow_downward,
              rightTitle: 'Total Pengeluaran',
              rightValue: totalPengeluaran,
            ),

            const SizedBox(height: 16),

            DoubleHeaderCardWidget(
              leftIcon: Icons.account_balance_wallet,
              leftTitle: 'Saldo Akhir',
              leftValue: saldoAkhir,
              rightIcon: Icons.receipt_long,
              rightTitle: 'Jumlah Transaksi',
              rightValue: jumlahTransaksi,
            ),

            const SizedBox(height: 24),
            const Divider(),

            // Section Bar Chart - Pemasukan per Bulan 
            const SizedBox(height: 12),
            BarChartWidget(
              icon: Icons.arrow_upward,
              title: 'Pemasukan per Bulan',
              data: pemasukanPerBulan,
              formatAxisLabel: (value) {
                if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)} jt';
                if (value >= 1) return '${value.toStringAsFixed(0)} rb';
                return value.toStringAsFixed(0);
              },
            ),

            const SizedBox(height: 24),
            const Divider(),

            // Section Bar Chart - Pengeluaran per Bulan 
            const SizedBox(height: 12),
            BarChartWidget(
              icon: Icons.arrow_downward,
              title: 'Pengeluaran per Bulan',
              data: pengeluaranPerBulan,
              formatAxisLabel: (value) {
                if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)} jt';
                if (value >= 1) return '${value.toStringAsFixed(0)} rb';
                return value.toStringAsFixed(0);
              },
            ),

            // --- TODO: Section Doughnut Chart - Pemasukan Berdasarkan Kategori ---
            DoughnutChartWidget(
              icon: Icons.arrow_upward,
              title: 'Pemasukan per Kategori',
              data: pemasukanKategori,
            ),

            // --- TODO: Section Pie Chart - Pengeluaran Berdasarkan Kategori ---
            PieChartWidget(
              icon: Icons.arrow_downward,
              title: 'Pengeluaran Per Kategori',
              data: pengeluaranKategori,
            ),
          ],
        ),
      ),
    );
  }
}