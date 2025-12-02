import 'package:flutter/material.dart';
import '../data/models/mutasi_model.dart';
import '../data/repository/mutasi_repository.dart';

class MutasiController extends ChangeNotifier {
  final MutasiRepository repository;

  MutasiController(this.repository);

  List<MutasiModel> _mutations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MutasiModel> get mutations => _mutations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMutations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchMutations();
      _mutations = result;
      // Sort terbaru (opsional)
      _mutations.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}