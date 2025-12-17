import 'package:flutter/foundation.dart';
import '../data/models/semua_pengeluaran_model.dart';
import '../data/repository/semua_pengeluaran_repository.dart';

class SemuaPengeluaranController {
  final SemuaPengeluaranRepository _repository;

  SemuaPengeluaranController({SemuaPengeluaranRepository? repository})
      : _repository = repository ?? SemuaPengeluaranRepository();

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<List<SemuaPengeluaranModel>> listPengeluaran = ValueNotifier([]);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  Future<void> loadData() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final data = await _repository.getDaftarPengeluaran();
      listPengeluaran.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      listPengeluaran.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}