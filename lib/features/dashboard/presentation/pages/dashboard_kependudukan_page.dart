import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/layouts/pages_layout.dart'; // Sesuaikan path jika berbeda
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
    // Load data awal (Gunakan Cache jika ada)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().loadPopulation();
    });
  }

  // --- LOGIC REFRESH ---
  Future<void> _handleRefresh() async {
    // PENTING: Gunakan force: true agar data diambil ulang dari API
    await context.read<DashboardController>().loadPopulation(force: true);
  }

  // --- Helper Warna Konsisten ---
  Color _getConsistentColor(String key, int index) {
    final List<Color> palette = [
      Colors.blueAccent, Colors.orangeAccent, Colors.greenAccent, Colors.purpleAccent,
      Colors.redAccent, Colors.tealAccent, Colors.pinkAccent, Colors.amberAccent,
      Colors.indigoAccent, Colors.cyanAccent, Colors.limeAccent, Colors.deepOrangeAccent
    ];
    return palette[index % palette.length];
  }

  // --- Helper Mapping Data ---
  List<Map<String, dynamic>> _mapToChartData(Map<String, int> data, {Map<String, Color>? colorMap}) {
    if (data.isEmpty) return [];

    // Hanya ambil data yang nilainya > 0
    final filteredEntries = data.entries.where((e) => e.value > 0).toList();

    return filteredEntries.asMap().entries.map((entry) {
      int index = entry.key;
      MapEntry<String, int> e = entry.value;

      String label = e.key;
      if (label.isEmpty) label = "Lainnya"; 
      
      // Translate Label (Opsional)
      if (label == 'permanent') label = 'Tetap';
      if (label == 'active') label = 'Aktif';
      if (label == 'inactive') label = 'Tidak Aktif';
      if (label == 'temporary') label = 'Sementara';
      if (label == 'male') label = 'Laki-laki';
      if (label == 'female') label = 'Perempuan';

      return {
        'kategori': label,
        'value': e.value,
        // Prioritas Warna: Map Custom -> Warna Konsisten
        'color': colorMap?[e.key] ?? _getConsistentColor(e.key, index),
      };
    }).toList();
  }

  // --- Widget: Placeholder (Chart Kosong) ---
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
          Text("Data tidak tersedia", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
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
            Icon(Icons.people_outline, size: 80, color: Colors.blue.shade200),
            const SizedBox(height: 24),
            const Text("Belum Ada Data Penduduk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Data statistik kependudukan akan muncul di sini.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
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
    final data = controller.populationData;
    final isLoading = controller.isPopulationLoading;

    // 1. Loading State
    if (isLoading) {
      return const PageLayout(title: 'Kependudukan', body: Center(child: CircularProgressIndicator()));
    }

    // 2. Empty Data State
    if (data == null) {
      return PageLayout(title: 'Kependudukan', body: _buildEmptyState());
    }

    // --- DATA PREPARATION ---
    final statusData = _mapToChartData(data.statusDistribution, colorMap: {
      'permanent': Colors.green,
      'active': Colors.green,
      'temporary': Colors.orange,
      'inactive': Colors.redAccent,
    });

    final genderData = _mapToChartData(data.genderDistribution, colorMap: {
      'male': Colors.blueAccent,
      'female': Colors.pinkAccent,
    });

    final rolesData = _mapToChartData(data.rolesDistribution);
    final jobData = _mapToChartData(data.occupationDistribution);
    final religionData = _mapToChartData(data.religionDistribution);
    final eduData = _mapToChartData(data.educationLevelDistribution);

    return PageLayout(
      title: 'Kependudukan',
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Colors.blue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // --- HEADER STATISTIK ---
              DoubleHeaderCardWidget(
                leftIcon: Icons.home_work_rounded,
                leftTitle: 'Total Keluarga',
                leftValue: '${data.totalFamilies}',
                rightIcon: Icons.people_alt_rounded,
                rightTitle: 'Total Penduduk',
                rightValue: '${data.totalPopulation}',
              ),

              const SizedBox(height: 24),
              const Divider(thickness: 0.5),

              // --- 1. STATUS PENDUDUK ---
              const SizedBox(height: 12),
              Builder(builder: (_) {
                if (statusData.isEmpty) return _buildEmptyChartPlaceholder("Status Penduduk", Icons.info_outline);
                return DoughnutChartWidget(
                  icon: Icons.info_outline_rounded,
                  title: 'Status Penduduk',
                  data: statusData,
                );
              }),

              const SizedBox(height: 24),
              const Divider(thickness: 0.5),

              // --- 2. JENIS KELAMIN ---
              const SizedBox(height: 12),
              Builder(builder: (_) {
                if (genderData.isEmpty) return _buildEmptyChartPlaceholder("Jenis Kelamin", Icons.wc);
                return DoughnutChartWidget(
                  icon: Icons.wc_rounded,
                  title: 'Jenis Kelamin',
                  data: genderData,
                );
              }),

              const SizedBox(height: 24),
              const Divider(thickness: 0.5),

              // --- 3. PEKERJAAN ---
              const SizedBox(height: 12),
              Builder(builder: (_) {
                if (jobData.isEmpty) return _buildEmptyChartPlaceholder("Pekerjaan", Icons.work_outline);
                return DoughnutChartWidget(
                  icon: Icons.work_outline_rounded,
                  title: 'Pekerjaan Penduduk',
                  data: jobData,
                );
              }),

              const SizedBox(height: 24),
              const Divider(thickness: 0.5),

              // --- 4. PERAN KELUARGA ---
              const SizedBox(height: 12),
              Builder(builder: (_) {
                if (rolesData.isEmpty) return _buildEmptyChartPlaceholder("Peran Keluarga", Icons.family_restroom);
                return DoughnutChartWidget(
                  icon: Icons.family_restroom_rounded,
                  title: 'Peran dalam Keluarga',
                  data: rolesData,
                );
              }),

              const SizedBox(height: 24),
              const Divider(thickness: 0.5),

              // --- 5. AGAMA ---
              const SizedBox(height: 12),
              Builder(builder: (_) {
                if (religionData.isEmpty) return _buildEmptyChartPlaceholder("Agama", Icons.mosque);
                return DoughnutChartWidget(
                  icon: Icons.mosque_rounded,
                  title: 'Agama',
                  data: religionData,
                );
              }),

              const SizedBox(height: 24),
              const Divider(thickness: 0.5),

              // --- 6. PENDIDIKAN ---
              const SizedBox(height: 12),
              Builder(builder: (_) {
                if (eduData.isEmpty) return _buildEmptyChartPlaceholder("Pendidikan", Icons.school);
                return DoughnutChartWidget(
                  icon: Icons.school_rounded,
                  title: 'Pendidikan',
                  data: eduData,
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