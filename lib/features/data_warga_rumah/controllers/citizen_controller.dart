// lib/features/data_warga_rumah/presentation/controllers/citizen_controller.dart

import 'package:flutter/material.dart';
import '../data/models/citizen_model.dart';
import '../data/repository/citizen_repository.dart';

class CitizenController extends ChangeNotifier {
  final CitizenRepository repository;

  CitizenController(this.repository);

  // State
  List<CitizenModel> _citizens = [];
  List<dynamic> _userOptions = [];
  List<dynamic> _familyOptions = [];
  
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<CitizenModel> get citizens => _citizens;
  List<dynamic> get userOptions => _userOptions;
  List<dynamic> get familyOptions => _familyOptions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 1. Load Data Warga
  Future<void> loadCitizens({bool force = false}) async {
    // CACHING STRATEGY:
    // Jika tidak dipaksa (force == false) DAN data sudah ada di memory (_citizens tidak kosong)
    // Maka JANGAN request ke API, return saja.
    if (!force && _citizens.isNotEmpty) {
      return; 
    }

    _setLoading(true);
    try {
      final result = await repository.fetchCitizens();
      _citizens = result;
      _errorMessage = null; // Reset error jika sukses
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // 2. Load Opsi Keluarga
  Future<void> loadFamilyOptions() async {
    try {
      final result = await repository.fetchFamilyOptions();
      _familyOptions = result;
      notifyListeners();
    } catch (e) {
      print("Gagal load opsi keluarga: $e");
    }
  }

  // 3. Load Opsi User
  Future<void> loadUserOptions() async {
    try {
      final result = await repository.fetchUserOptions();
      _userOptions = result;
      notifyListeners();
    } catch (e) {
      print("Gagal load opsi user: $e");
    }
  }

  // Helper untuk load semua data awal (dipanggil di initState)
  Future<void> loadInitialData() async {
    await Future.wait([
      loadFamilyOptions(),
      loadUserOptions(),
    ]);
  }

  // 4. Submit Data
  Future<bool> addCitizen(Map<String, dynamic> requestData) async {
    _setLoading(true);
    try {
      await repository.addCitizen(requestData);
      
      // STRATEGY DATA BARU:
      // Karena ada data baru, cache lama sudah basi.
      // Kita panggil loadCitizens dengan force: true untuk ambil data terbaru.
      await loadCitizens(force: true); 
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}