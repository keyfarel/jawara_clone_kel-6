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

  Future<void> loadVerificationList() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchVerificationList();
      _listWarga = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}