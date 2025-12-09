// broadcast_controller.dart
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/models/broadcast_model.dart';
import '../data/repository/broadcast_repository.dart';

class BroadcastController extends ChangeNotifier {
  final BroadcastRepository repo;

  BroadcastController(this.repo);

  List<BroadcastModel> broadcasts = [];
  bool isLoading = false;
  String? errorMessage; // Tambahkan variabel untuk pesan error

  Future<void> loadBroadcasts() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      broadcasts = await repo.getAllBroadcast();
    } catch (e) {
      debugPrint("Error Broadcast: $e");
      errorMessage = _getFriendlyErrorMessage(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBroadcast({
    required String title,
    required String content,
    String? imagePath,
    String? documentPath,
    Uint8List? imageBytes,
    Uint8List? documentBytes,
    String? imageName,
    String? documentName,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await repo.createBroadcast(
        title: title,
        content: content,
        imagePath: imagePath,
        documentPath: documentPath,
        imageBytes: imageBytes,
        documentBytes: documentBytes,
        imageName: imageName,
        documentName: documentName,
      );

      return result;
    } catch (e) {
      debugPrint("Error Create Broadcast: $e");
      errorMessage = _getFriendlyErrorMessage(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi helper untuk menerjemahkan error
  String _getFriendlyErrorMessage(String rawError) {
    if (rawError.contains('401') || rawError.contains('Access Token tidak ditemukan')) {
      // 🚨 PENTING: Jika ingin mengarahkan ke login, Anda harus menggunakan 
      // Provider.of<AuthService>(context, listen: false).logout() dan 
      // Navigator.pushReplacement. Ini biasanya dilakukan di *View* (UI) 
      // setelah controller memberi tahu (notifyListeners).
      return 'Sesi Anda telah berakhir. Silakan login ulang.';
    }
    // Hapus detail 'Exception' agar lebih ramah pengguna
    return rawError.replaceAll('Exception: ', '').replaceAll(':', '');
  }
}