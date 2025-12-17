// lib/features/penerimaan_warga/data/repository/penerimaan_warga_repository.dart

import '../models/penerimaan_warga_model.dart';
import '../services/penerimaan_warga_service.dart';

class PenerimaanWargaRepository {
  final PenerimaanWargaService service;

  PenerimaanWargaRepository(this.service);

  Future<List<PenerimaanWargaModel>> fetchVerificationList() async {
    return await service.getVerificationList();
  }

  Future<bool> verifyCitizen(int id, String status) async {
    return await service.updateStatus(id, status);
  }
}