import '../models/aspirasi_model.dart';
import '../services/aspirasi_service.dart';

class AspirasiRepository {
  final AspirasiService _service;

  AspirasiRepository(this._service);

  Future<List<AspirasiModel>> fetchAspirasi() async {
    try {
      return await _service.getAspirasi();
    } catch (e) {
      rethrow;
    }
  }
}