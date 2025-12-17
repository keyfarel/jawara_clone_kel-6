// lib/features/data_warga_rumah/data/repository/citizen_repository.dart

import '../models/citizen_model.dart';
import '../services/citizen_service.dart'; // Sesuaikan path service Anda

class CitizenRepository {
  final CitizenService service;

  CitizenRepository(this.service);

  Future<List<CitizenModel>> fetchCitizens() async {
    return await service.getCitizens();
  }

  Future<List<dynamic>> fetchFamilyOptions() async {
    return await service.getFamilyOptions();
  }
  
  // TAMBAHAN BARU
  Future<List<dynamic>> fetchUserOptions() async {
    return await service.getUserOptions();
  }

  Future<bool> addCitizen(Map<String, dynamic> data) async {
    return await service.createCitizen(data);
  }
}