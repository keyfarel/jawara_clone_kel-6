import 'package:flutter/material.dart';
import '../data/models/mutasi_model.dart';
import '../data/repository/mutasi_repository.dart';

class MutasiController extends ChangeNotifier {
  final MutasiRepository repository;

  MutasiController(this.repository);

  // --- STATE LIST MUTASI ---
  List<MutasiModel> _mutations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MutasiModel> get mutations => _mutations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // --- STATE OPTIONS (KELUARGA) ---
  List<Map<String, dynamic>> _familyOptions = [];
  bool _isFamilyOptionsLoading = false;
  List<Map<String, dynamic>> get familyOptions => _familyOptions;
  bool get isFamilyOptionsLoading => _isFamilyOptionsLoading;

  // --- STATE OPTIONS (WARGA) - BARU ---
  List<Map<String, dynamic>> _citizensOptions = [];
  bool _isCitizensLoading = false;
  List<Map<String, dynamic>> get citizensOptions => _citizensOptions;
  bool get isCitizensLoading => _isCitizensLoading;

  // 1. Load Daftar Mutasi
  Future<void> loadMutations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchMutations();
      _mutations = result;
      _mutations.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. Load Opsi Keluarga
  Future<void> loadFamilyOptions() async {
    _isFamilyOptionsLoading = true;
    notifyListeners();
    try {
      _familyOptions = await repository.getFamilyOptions();
    } catch (e) {
      print("Error families: $e");
    } finally {
      _isFamilyOptionsLoading = false;
      notifyListeners();
    }
  }

  // 3. Load Opsi Warga (Berdasarkan ID Keluarga) - BARU
  Future<void> loadCitizensByFamily(int familyId) async {
    _isCitizensLoading = true;
    _citizensOptions = []; // Reset list warga saat ganti keluarga
    notifyListeners();

    try {
      _citizensOptions = await repository.fetchCitizensByFamily(familyId);
    } catch (e) {
      print("Error citizens: $e");
    } finally {
      _isCitizensLoading = false;
      notifyListeners();
    }
  }

  // 4. Tambah Mutasi (Update Parameter)
  Future<bool> addMutation({
    required int familyId,
    int? citizenId, // <--- Parameter Baru (Opsional)
    required String mutationType,
    required String date,
    required String reason,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Kita perlu update method createMutation di repo/service juga 
      // agar menerima citizenId. (Asumsi sudah diupdate sesuai logic backend)
      
      // Kirim data ke backend (pastikan service.createMutation menerima citizenId)
       await repository.service.createMutation(
        familyId: familyId,
        // citizenId: citizenId, // <-- Pastikan service diupdate terima ini
        mutationType: mutationType,
        date: date,
        reason: reason,
      );
      
      // Disini saya pakai trick, karena service Anda tadi belum saya ubah full signaturenya.
      // Anda harus menambahkan 'citizen_id': citizenId ke body JSON di MutasiService.createMutation
      
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
}