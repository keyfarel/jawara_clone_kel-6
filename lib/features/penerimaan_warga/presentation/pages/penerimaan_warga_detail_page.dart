// lib/features/penerimaan_warga/presentation/pages/penerimaan_warga_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../layouts/pages_layout.dart';
import '../../controllers/penerimaan_warga_controller.dart';
import '../../data/models/penerimaan_warga_model.dart';

class PenerimaanWargaDetailPage extends StatelessWidget {
  final PenerimaanWargaModel warga;

  const PenerimaanWargaDetailPage({super.key, required this.warga});

  // URL Base Storage (Ganti sesuai ngrok/server)
  final String baseImageUrl = "https://unmoaning-lenora-photomechanically.ngrok-free.dev/storage/";

  void _handleVerification(BuildContext context, bool isAccepted) async {
    final controller = context.read<PenerimaanWargaController>();
    
    // Tampilkan konfirmasi dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isAccepted ? "Terima Warga?" : "Tolak Warga?"),
        content: Text(isAccepted 
          ? "Warga akan menjadi permanen dan bisa login." 
          : "Data pengajuan akan ditolak."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isAccepted ? Colors.green : Colors.red,
            ),
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text("Ya, Lanjutkan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Proses API
    final success = await controller.verifyWarga(warga.id, isAccepted);

    if (context.mounted) {
      if (success) {
        Navigator.pop(context); // Kembali ke list
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAccepted ? "Warga Berhasil Diterima" : "Warga Ditolak"),
            backgroundColor: isAccepted ? Colors.green : Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.errorMessage ?? "Gagal memproses")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan PageLayout atau Scaffold biasa
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Verifikasi")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO KTP / IDENTITAS
            Center(
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: warga.fotoIdentitas != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "$baseImageUrl${warga.fotoIdentitas}",
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.credit_card, size: 50, color: Colors.grey),
                          Text("Tidak ada foto identitas"),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // DATA DIRI
            _buildInfoRow("Nama Lengkap", warga.nama),
            _buildInfoRow("NIK", warga.nik),
            _buildInfoRow("Jenis Kelamin", warga.jenisKelamin),
            _buildInfoRow("No. HP", warga.noHp),
            _buildInfoRow("Email", warga.email ?? '-'),
            _buildInfoRow("Peran Keluarga", warga.peranKeluarga),
            
            const SizedBox(height: 30),

            // TOMBOL AKSI (Terima / Tolak)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleVerification(context, false), // Reject
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.close),
                    label: const Text("TOLAK"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleVerification(context, true), // Accept
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text("TERIMA"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const Divider(height: 24),
        ],
      ),
    );
  }
}