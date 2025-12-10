// lib/features/keluarga/controllers/keluarga_controller.dart

// Hapus ValueNotifier dan ganti dengan ChangeNotifier
import 'package:flutter/material.dart'; // Ganti foundation.dart menjadi material.dart jika Anda menggunakan StatelessWidget/Widget
import '../data/models/keluarga_model.dart';
import '../data/repository/keluarga_repository.dart';

// Enum untuk status data
enum KeluargaState { initial, loading, loaded, error }

// Ubah: extends ChangeNotifier
class KeluargaController extends ChangeNotifier { 
  final KeluargaRepository _repository;

  // Hapus ValueNotifier, ganti dengan variabel biasa
  List<KeluargaModel> _listKeluarga = [];
  KeluargaState _state = KeluargaState.initial;
  String? _errorMessage;
  String? _selectedStatusFilter;

  // Getter
  List<KeluargaModel> get listKeluarga => _listKeluarga;
  KeluargaState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get selectedStatusFilter => _selectedStatusFilter;


  KeluargaController(this._repository);

  // Fungsi untuk memuat data dari Repository
  Future<void> fetchListKeluarga() async {
    if (_state == KeluargaState.loading) return;
    
    _state = KeluargaState.loading;
    _errorMessage = null;
    notifyListeners(); // Beri tahu UI bahwa state berubah menjadi loading

    try {
      final data = await _repository.getListKeluarga();
      _listKeluarga = data;
      _state = KeluargaState.loaded;
      notifyListeners(); // Beri tahu UI bahwa data sudah dimuat
    } catch (e) {
      _errorMessage = e.toString();
      _state = KeluargaState.error;
      notifyListeners(); // Beri tahu UI bahwa terjadi error
      debugPrint('Error fetching list keluarga: $e');
    }
  }

  // Fungsi untuk menerapkan filter
  void applyFilter(String? status) {
    _selectedStatusFilter = status;
    notifyListeners(); // Beri tahu UI bahwa filter berubah
  }

  // Getter untuk daftar keluarga yang difilter
  List<KeluargaModel> get filteredList {
    if (_selectedStatusFilter == null || _selectedStatusFilter == 'Semua') {
      return _listKeluarga;
    }

    // API menggunakan 'active'/'inactive'
    final apiStatus = _selectedStatusFilter == 'Aktif' ? 'active' : 'inactive'; 

    return _listKeluarga
        .where((k) => k.status.toLowerCase() == apiStatus.toLowerCase())
        .toList();
  }
}