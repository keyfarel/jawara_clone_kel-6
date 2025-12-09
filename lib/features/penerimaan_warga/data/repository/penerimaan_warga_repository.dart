import '../models/penerimaan_warga_model.dart';
import '../services/penerimaan_warga_service.dart';

class PenerimaanWargaRepository {
  final PenerimaanWargaService service;

  PenerimaanWargaRepository(this.service);

  Future<List<PenerimaanWargaModel>> fetchVerificationList() async {
    return await service.getVerificationList();
  }
}