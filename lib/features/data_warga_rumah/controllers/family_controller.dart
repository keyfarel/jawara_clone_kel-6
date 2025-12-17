// lib/features/data_warga_rumah/presentation/controllers/family_controller.dart

import 'package:flutter/material.dart';
import '../data/models/keluarga_model.dart';
import '../data/repository/family_repository.dart';

class FamilyController extends ChangeNotifier {
  final FamilyRepository repository;
  FamilyController(this.repository);

  List<KeluargaModel> _families = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<KeluargaModel> get families => _families;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadFamilies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchFamilies();
      _families = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}