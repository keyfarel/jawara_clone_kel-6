// lib/features/keluarga/data/repository/keluarga_repository.dart

import '../models/keluarga_model.dart';
import '../services/keluarga_service.dart';

class KeluargaRepository {
  final KeluargaService _keluargaService;

  KeluargaRepository(this._keluargaService);

  Future<List<KeluargaModel>> getListKeluarga() async {
    // Memanggil Service untuk mengambil data
    return await _keluargaService.fetchListKeluarga();
  }
}