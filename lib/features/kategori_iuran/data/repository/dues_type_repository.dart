// lib/features/dues_type/data/repository/dues_type_repository.dart

import '../models/dues_type_model.dart';
import '../services/dues_type_service.dart';

class DuesTypeRepository {
  final DuesTypeService _duesTypeService;

  DuesTypeRepository(this._duesTypeService);

  Future<List<DuesTypeModel>> getListDuesTypes() async {
    // Memanggil Service untuk mengambil data
    return await _duesTypeService.fetchListDuesTypes();
  }
}