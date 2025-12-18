import '../models/mutasi_model.dart';
import '../services/mutasi_service.dart';

class MutasiRepository {
  final MutasiService service;

  MutasiRepository(this.service);

  Future<List<MutasiModel>> fetchMutations() async {
    return await service.getMutations();
  }

  Future<bool> createMutation({
    required int familyId,
    required String mutationType,
    required String date,
    required String reason,
  }) async {
    return await service.createMutation(
      familyId: familyId,
      mutationType: mutationType,
      date: date,
      reason: reason,
    );
  }

  Future<List<Map<String, dynamic>>> getFamilyOptions() async {
    return await service.getFamilyOptions();
  }

  Future<List<Map<String, dynamic>>> fetchCitizensByFamily(int familyId) async {
    return await service.getCitizensByFamily(familyId);
  }
}