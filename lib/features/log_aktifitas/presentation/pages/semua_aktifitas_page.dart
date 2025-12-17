import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/layouts/pages_layout.dart';
import '../../controllers/log_aktifitas_controller.dart';
import '../../data/models/activity_model.dart';
import '../widgets/activity_card.dart';

class SemuaAktifitasPage extends StatefulWidget {
  const SemuaAktifitasPage({super.key});

  @override
  State<SemuaAktifitasPage> createState() => _SemuaAktifitasPageState();
}

class _SemuaAktifitasPageState extends State<SemuaAktifitasPage> {
  int currentPage = 1;
  final int itemsPerPage = 10; // Menampilkan 10 item per halaman

  @override
  void initState() {
    super.initState();
    // Panggil data saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LogAktifitasController>().loadActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch Controller
    final controller = context.watch<LogAktifitasController>();
    final List<ActivityModel> daftarAktivitas = controller.activities;

    // Logic Pagination (Client Side)
    final totalPages = (daftarAktivitas.length / itemsPerPage).ceil();
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage) > daftarAktivitas.length
        ? daftarAktivitas.length
        : (startIndex + itemsPerPage);

    // Pastikan list tidak kosong sebelum sublist
    final paginatedList = daftarAktivitas.isNotEmpty
        ? daftarAktivitas.sublist(startIndex, endIndex)
        : <ActivityModel>[];

    return PageLayout(
      title: "Semua Aktivitas",
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.errorMessage != null
          ? Center(child: Text("Error: ${controller.errorMessage}"))
          : daftarAktivitas.isEmpty
          ? const Center(child: Text("Belum ada aktivitas tercatat"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: paginatedList.length,
                    itemBuilder: (context, index) {
                      final aktivitas = paginatedList[index];
                      return ActivityCard(aktivitas: aktivitas);
                    },
                  ),
                ),

                // --- Pagination Controls ---
                if (totalPages > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: currentPage > 1
                              ? () => setState(() => currentPage--)
                              : null,
                        ),
                        Text(
                          "$currentPage / $totalPages",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: currentPage < totalPages
                              ? () => setState(() => currentPage++)
                              : null,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
