// lib/features/dues_type/controllers/dues_type_controller.dart

import 'package:flutter/material.dart';
import '../data/models/dues_type_model.dart';
import '../data/repository/dues_type_repository.dart';

// Enum untuk status data
enum DuesTypeState { initial, loading, loaded, error }

class DuesTypeController extends ChangeNotifier { 
  final DuesTypeRepository _repository;

  List<DuesTypeModel> _listDuesTypes = [];
  DuesTypeState _state = DuesTypeState.initial;
  String? _errorMessage;

  // Getter
  List<DuesTypeModel> get listDuesTypes => _listDuesTypes;
  DuesTypeState get state => _state;
  String? get errorMessage => _errorMessage;

  DuesTypeController(this._repository);

  // Fungsi untuk memuat data dari Repository
  Future<void> fetchListDuesTypes() async {
    if (_state == DuesTypeState.loading) return;
    
    _state = DuesTypeState.loading;
    _errorMessage = null;
    notifyListeners(); // Beri tahu UI bahwa state berubah menjadi loading

    try {
      final data = await _repository.getListDuesTypes();
      _listDuesTypes = data;
      _state = DuesTypeState.loaded;
      notifyListeners(); // Beri tahu UI bahwa data sudah dimuat
    } catch (e) {
      _errorMessage = e.toString();
      _state = DuesTypeState.error;
      notifyListeners(); // Beri tahu UI bahwa terjadi error
      debugPrint('Error fetching list dues types: $e');
    }
  }

  // Helper untuk mendapatkan nama kategori berdasarkan ID (berguna di UI lain)
  String getDuesTypeName(int id) {
    try {
      return _listDuesTypes.firstWhere((dt) => dt.id == id).name;
    } catch (_) {
      return 'Kategori Tidak Ditemukan';
    }
  }
}