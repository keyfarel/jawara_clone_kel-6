// lib/features/data_warga_rumah/controllers/family_controller.dart

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

  // --- 1. LOAD FAMILIES (DENGAN CACHE) ---
  Future<void> loadFamilies({bool force = false}) async {
    if (!force && _families.isNotEmpty) {
      return; 
    }

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

  // --- 2. ADD FAMILY (AUTO UPDATE) ---
  Future<bool> addFamily(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.createFamily(data);
      await loadFamilies(force: true); 
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}