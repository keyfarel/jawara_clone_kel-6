// lib/features/data_warga_rumah/data/repository/family_repository.dart
import '../services/family_service.dart';
import '../models/keluarga_model.dart';

class FamilyRepository {
  final FamilyService service;
  FamilyRepository(this.service);

  Future<List<KeluargaModel>> fetchFamilies() async {
    return await service.getFamilies();
  }

  Future<bool> createFamily(Map<String, dynamic> data) async {
    return await service.createFamily(data);
  }
}