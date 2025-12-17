import 'package:flutter/material.dart';
import '../data/models/aspirasi_model.dart';
import '../data/repository/aspirasi_repository.dart';

class AspirasiController extends ChangeNotifier {
  final AspirasiRepository repository;

  // Constructor menerima repository (Dependency Injection)
  AspirasiController(this.repository);

  List<AspirasiModel> _aspirasiList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AspirasiModel> get aspirasiList => _aspirasiList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAspirasi() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Pastikan di repository nama methodnya adalah fetchAspirasi
      final result = await repository.fetchAspirasi();
      _aspirasiList = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}