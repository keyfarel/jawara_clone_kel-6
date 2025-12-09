import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/kegiatan_broadcast/controllers/broadcast_controller.dart';
import '../../../../layouts/pages_layout.dart';

class BroadcastTambahPage extends StatefulWidget {
  const BroadcastTambahPage({super.key});

  @override
  State<BroadcastTambahPage> createState() => _BroadcastTambahPageState();
}

class _BroadcastTambahPageState extends State<BroadcastTambahPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  File? selectedImage;
  File? selectedDocument;

  Uint8List? webImageBytes;
  Uint8List? webDocumentBytes;

  String? webImageName;
  String? webDocumentName;

  // ===== PICK IMAGE =====
  Future pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: kIsWeb,
    );

    if (result != null) {
      if (kIsWeb) {
        setState(() {
          webImageBytes = result.files.single.bytes;
          webImageName = result.files.single.name;
          selectedImage = null;
        });
      } else {
        setState(() {
          selectedImage = File(result.files.single.path!);
          webImageBytes = null;
          webImageName = null;
        });
      }
    }
  }

  // ===== PICK DOCUMENT =====
  Future pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: false,
      withData: kIsWeb,
    );

    if (result != null) {
      if (kIsWeb) {
        setState(() {
          webDocumentBytes = result.files.single.bytes;
          webDocumentName = result.files.single.name;
          selectedDocument = null;
        });
      } else {
        setState(() {
          selectedDocument = File(result.files.single.path!);
          webDocumentBytes = null;
          webDocumentName = null;
        });
      }
    }
  }

  // ===== SUBMIT BROADCAST =====
  Future submit() async {
    final controller = context.read<BroadcastController>();

    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul dan Konten wajib diisi")),
      );
      return;
    }

    // Debug prints
    debugPrint('Submit Title: ${titleController.text}');
    debugPrint('Submit Content: ${contentController.text}');
    debugPrint('Submit Image: ${selectedImage?.path ?? webImageName}');
    debugPrint('Submit Document: ${selectedDocument?.path ?? webDocumentName}');

    try {
      bool success = await controller.createBroadcast(
        title: titleController.text,
        content: contentController.text,
        imagePath: selectedImage?.path,
        documentPath: selectedDocument?.path,
        imageBytes: webImageBytes,
        documentBytes: webDocumentBytes,
        imageName: webImageName,
        documentName: webDocumentName,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Broadcast berhasil dibuat!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Gagal menambahkan broadcast.\nCek console debug untuk detail",
              maxLines: 5,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Exception saat submit:\n$e",
            maxLines: 5,
          ),
        ),
      );
    }
  }

  // ===== RESET FORM =====
  void resetForm() {
    setState(() {
      titleController.clear();
      contentController.clear();
      selectedImage = null;
      selectedDocument = null;
      webImageBytes = null;
      webDocumentBytes = null;
      webImageName = null;
      webDocumentName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Tambah Broadcast',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Buat Broadcast Baru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // ===== TITLE =====
            const Text('Judul Broadcast'),
            const SizedBox(height: 4),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Masukkan judul broadcast',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===== CONTENT =====
            const Text('Isi Broadcast'),
            const SizedBox(height: 4),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tulis isi broadcast...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===== IMAGE PICKER =====
            const Text('Foto'),
            const SizedBox(height: 4),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pilih Foto'),
            ),
            const SizedBox(height: 6),
            if (selectedImage != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dipilih: ${selectedImage!.path.split('/').last}"),
                  const SizedBox(height: 6),
                  Image.file(selectedImage!, height: 100),
                ],
              ),
            if (webImageBytes != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Foto dipilih: $webImageName"),
                  const SizedBox(height: 6),
                  Image.memory(webImageBytes!, height: 100),
                ],
              ),

            const SizedBox(height: 16),

            // ===== DOCUMENT PICKER =====
            const Text('Dokumen'),
            const SizedBox(height: 4),
            ElevatedButton.icon(
              onPressed: pickDocument,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Pilih Dokumen'),
            ),
            const SizedBox(height: 6),
            if (selectedDocument != null)
              Text("Dipilih: ${selectedDocument!.path.split('/').last}"),
            if (webDocumentBytes != null)
              Text("Dokumen dipilih: $webDocumentName"),

            const SizedBox(height: 30),

            // ===== BUTTONS =====
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Submit',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: resetForm,
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
