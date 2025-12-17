import 'package:flutter/material.dart';
import '../data/models/penerimaan_warga_model.dart';
import '../data/repository/penerimaan_warga_repository.dart';

class PenerimaanWargaController extends ChangeNotifier {
  final PenerimaanWargaRepository repository;

  PenerimaanWargaController(this.repository);

  List<PenerimaanWargaModel> _listWarga = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PenerimaanWargaModel> get listWarga => _listWarga;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // UPDATE DI SINI: Tambahkan parameter force
  Future<void> loadVerificationList({bool force = false}) async {
    // 1. Cek Cache: Jika tidak dipaksa refresh DAN data sudah ada, stop (jangan loading).
    if (!force && _listWarga.isNotEmpty) {
      return; 
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchVerificationList();
      
      // Filter status 'pending' (Case Insensitive)
      _listWarga = result.where((warga) {
        final status = warga.statusRegistrasi?.toLowerCase() ?? '';
        return status == 'pending'; 
      }).toList();

    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update logic verify agar otomatis refresh list
  Future<bool> verifyWarga(int id, bool isAccepted) async {
    _isLoading = true;
    notifyListeners(); // Tampilkan loading saat proses verifikasi berjalan

    try {
      final status = isAccepted ? 'verified' : 'rejected';
      await repository.verifyCitizen(id, status);
      
      // Setelah sukses verifikasi, kita paksa refresh list (force: true)
      // karena data di server sudah berubah (item berkurang 1)
      await loadVerificationList(force: true); 
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false; // Stop loading jika error
      notifyListeners();
      return false;
    }
  }
}