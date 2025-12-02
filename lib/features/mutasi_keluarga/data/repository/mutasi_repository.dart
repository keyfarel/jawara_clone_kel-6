import '../models/mutasi_model.dart';
import '../services/mutasi_service.dart';

class MutasiRepository {
  final MutasiService service;

  MutasiRepository(this.service);

  Future<List<MutasiModel>> fetchMutations() async {
    return await service.getMutations();
  }
}