import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../layouts/pages_layout.dart';
import '../../../../widgets/chart/doughnut_chart_widget.dart';
import '../../../../widgets/header_card/double_header_card_widget.dart';
import '../../controllers/dashboard_controller.dart';

class KependudukanPage extends StatefulWidget {
  const KependudukanPage({super.key});

  @override
  State<KependudukanPage> createState() => _KependudukanPageState();
}

class _KependudukanPageState extends State<KependudukanPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().loadPopulation();
    });
  }

  // Helper untuk generate warna random (jika kategori banyak)
  Color _getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  // Helper Mapping Data API ke Chart Widget
  List<Map<String, dynamic>> _mapToChartData(Map<String, int> data, {Map<String, Color>? colorMap}) {
    if (data.isEmpty) return [];

    return data.entries.map((e) {
      String label = e.key;
      if (label.isEmpty) label = "Tidak Diketahui"; // Handle key kosong "" dari API
      
      // Translate manual jika perlu (optional)
      if (label == 'permanent') label = 'Tetap';
      if (label == 'male') label = 'Laki-laki';
      if (label == 'female') label = 'Perempuan';

      return {
        'kategori': label,
        'value': e.value,
        // Pakai warna dari map jika ada, kalau tidak random/default
        'color': colorMap?[e.key] ?? _getRandomColor(),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final data = controller.populationData;
    final isLoading = controller.isPopulationLoading;

    if (isLoading) {
      return const PageLayout(title: 'Kependudukan', body: Center(child: CircularProgressIndicator()));
    }

    if (data == null) {
      return const PageLayout(title: 'Kependudukan', body: Center(child: Text("Data tidak tersedia")));
    }

    // --- PREPARE CHART DATA ---
    
    final statusData = _mapToChartData(data.statusDistribution, colorMap: {
      'permanent': Colors.greenAccent,
      'temporary': Colors.orangeAccent,
    });

    final genderData = _mapToChartData(data.genderDistribution, colorMap: {
      'male': Colors.blueAccent,
      'female': Colors.pinkAccent,
    });

    final rolesData = _mapToChartData(data.rolesDistribution, colorMap: {
      'Kepala Keluarga': Colors.blueGrey,
      'Istri': Colors.lightBlueAccent,
      'Anak': Colors.cyan,
    });

    // Untuk kategori yang dinamis/banyak opsi, warnanya random generated di helper
    final jobData = _mapToChartData(data.occupationDistribution);
    final religionData = _mapToChartData(data.religionDistribution);
    final eduData = _mapToChartData(data.educationLevelDistribution);

    return PageLayout(
      title: 'Kependudukan',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // --- Section Card Statistik Utama ---
            DoubleHeaderCardWidget(
              leftIcon: Icons.group,
              leftTitle: 'Total Keluarga',
              leftValue: '${data.totalFamilies}',
              rightIcon: Icons.person,
              rightTitle: 'Total Penduduk',
              rightValue: '${data.totalPopulation}',
            ),

            const SizedBox(height: 24),
            const Divider(),

            // --- Status Penduduk ---
            if (statusData.isNotEmpty) ...[
              DoughnutChartWidget(
                icon: Icons.info,
                title: 'Status Penduduk',
                data: statusData,
              ),
              const SizedBox(height: 24),
              const Divider(),
            ],

            // --- Jenis Kelamin ---
            if (genderData.isNotEmpty) ...[
              DoughnutChartWidget(
                icon: Icons.wc,
                title: 'Jenis Kelamin',
                data: genderData,
              ),
              const SizedBox(height: 24),
              const Divider(),
            ],

            // --- Pekerjaan ---
            if (jobData.isNotEmpty) ...[
              DoughnutChartWidget(
                icon: Icons.work,
                title: 'Pekerjaan Penduduk',
                data: jobData,
              ),
              const SizedBox(height: 24),
              const Divider(),
            ],

            // --- Peran Keluarga ---
            if (rolesData.isNotEmpty) ...[
              DoughnutChartWidget(
                icon: Icons.family_restroom,
                title: 'Peran dalam Keluarga',
                data: rolesData,
              ),
              const SizedBox(height: 24),
              const Divider(),
            ],

            // --- Agama ---
            if (religionData.isNotEmpty) ...[
              DoughnutChartWidget(
                icon: Icons.account_balance,
                title: 'Agama',
                data: religionData,
              ),
              const SizedBox(height: 24),
              const Divider(),
            ],

            // --- Pendidikan ---
            if (eduData.isNotEmpty)
              DoughnutChartWidget(
                icon: Icons.school,
                title: 'Pendidikan',
                data: eduData,
              ),
              
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}