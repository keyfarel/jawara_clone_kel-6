import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';
import 'widgets/aspirasi_card_widget.dart';
import 'widgets/aspirasi_detail_sheet.dart';
import 'widgets/aspirasi_filter_dialog.dart';

class Aspirasi {
  final String no;
  final String pengirim;
  final String judul;
  final String deskripsi;
  final String status;
  final String tanggal;

  Aspirasi({
    required this.no,
    required this.pengirim,
    required this.judul,
    required this.deskripsi,
    required this.status,
    required this.tanggal,
  });
}

class InformasiAspirasiPage extends StatefulWidget {
  const InformasiAspirasiPage({super.key});

  @override
  State<InformasiAspirasiPage> createState() => _InformasiAspirasiPageState();
}

class _InformasiAspirasiPageState extends State<InformasiAspirasiPage> {
  final List<Aspirasi> daftarAspirasi = [
    Aspirasi(
      no: "1",
      pengirim: "Habibie Ed Dien",
      judul: "Tes",
      deskripsi:
          "Ini adalah deskripsi aspirasi tes untuk menunjukkan fungsionalitas detail.",
      status: "Pending",
      tanggal: "28 September 2025",
    ),
    Aspirasi(
      no: "2",
      pengirim: "Andi Saputra",
      judul: "Perbaikan Lampu Jalan",
      deskripsi:
          "Lampu jalan di sepanjang Jl. Kenangan banyak yang mati, mohon segera diperbaiki demi keamanan warga.",
      status: "Selesai",
      tanggal: "10 Oktober 2025",
    ),
    Aspirasi(
      no: "3",
      pengirim: "Siti Rohani",
      judul: "Pengajuan Taman Bermain",
      deskripsi:
          "Warga RT 05 mengajukan pembangunan taman bermain anak-anak di lahan kosong dekat pos ronda.",
      status: "Diproses",
      tanggal: "5 Oktober 2025",
    ),
    Aspirasi(
      no: "4",
      pengirim: "Budi Santoso",
      judul: "Pembersihan Saluran Air",
      deskripsi:
          "Saluran air di depan gang 5 tersumbat dan menimbulkan bau tak sedap. Perlu segera dibersihkan.",
      status: "Pending",
      tanggal: "20 Oktober 2025",
    ),
  ];

  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    final filteredList = selectedStatus == null
        ? daftarAspirasi
        : daftarAspirasi.where((a) => a.status == selectedStatus).toList();

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
            if (result != null) setState(() => selectedStatus = result);
          },
        ),
      ],
      body: ListView.builder(
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
  }
}
