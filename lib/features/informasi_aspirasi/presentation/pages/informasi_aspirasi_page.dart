import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/layouts/pages_layout.dart';
import '../widgets/aspirasi_card_widget.dart';
import '../widgets/aspirasi_detail_sheet.dart';
import '../widgets/aspirasi_filter_dialog.dart';

import '../../controllers/aspirasi_controller.dart'; 

class InformasiAspirasiPage extends StatefulWidget {
  const InformasiAspirasiPage({super.key});

  @override
  State<InformasiAspirasiPage> createState() => _InformasiAspirasiPageState();
}

class _InformasiAspirasiPageState extends State<InformasiAspirasiPage> {
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    // UI tidak perlu mengirim token lagi
    context.read<AspirasiController>().loadAspirasi();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: "Informasi Aspirasi",
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () async {
            final result = await showDialog<String?>(
              context: context,
              builder: (context) =>
                  AspirasiFilterDialog(selectedStatus: selectedStatus),
            );
            // Jika result adalah 'Semua' atau null, kita set selectedStatus jadi null
            setState(() => selectedStatus = (result == 'Semua') ? null : result);
          },
        ),
      ],
      body: Consumer<AspirasiController>(
        builder: (context, controller, child) {
          // 1. Kondisi Loading (Gunakan bool isLoading dari controller)
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Kondisi Error (Gunakan pengecekan null pada errorMessage)
          if (controller.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Error: ${controller.errorMessage}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchData,
                    child: const Text("Coba Lagi"),
                  )
                ],
              ),
            );
          }

          // 3. Filter Data dari API
          final filteredList = selectedStatus == null
              ? controller.aspirasiList
              : controller.aspirasiList
                  .where((a) => a.status.toLowerCase() == selectedStatus!.toLowerCase())
                  .toList();

          // 4. Kondisi Data Kosong
          if (filteredList.isEmpty) {
            return const Center(child: Text("Tidak ada data aspirasi."));
          }

          // 5. Kondisi Berhasil (List Data)
          return RefreshIndicator(
            onRefresh: () async => _fetchData(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final aspirasi = filteredList[index];
                return AspirasiCardWidget(
                  aspirasi: aspirasi,
                  onDetailPressed: () =>
                      showAspirasiDetailSheet(context, aspirasi),
                );
              },
            ),
          );
        },
      ),
    );
  }
}