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
      // Sort dari yang paling baru
      _mutations.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMutation({
    required int familyId,
    required String mutationType,
    required String date,
    required String reason,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.createMutation(
        familyId: familyId,
        mutationType: mutationType,
        date: date,
        reason: reason,
      );
      
      // Refresh list setelah berhasil tambah
      await loadMutations(); 
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _familyOptions = [];
  bool _isFamilyOptionsLoading = false;

  List<Map<String, dynamic>> get familyOptions => _familyOptions;
  bool get isFamilyOptionsLoading => _isFamilyOptionsLoading;

  // METHOD BARU: Load Family Options
  Future<void> loadFamilyOptions() async {
    _isFamilyOptionsLoading = true;
    notifyListeners();

    try {
      final result = await repository.getFamilyOptions();
      _familyOptions = result;
    } catch (e) {
      print("Error loading families: $e");
    } finally {
      _isFamilyOptionsLoading = false;
      notifyListeners();
    }
  }
}