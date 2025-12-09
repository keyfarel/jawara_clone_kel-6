import '../models/kegiatan_model.dart';
import '../services/kegiatan_service.dart';

class KegiatanRepository {
  final KegiatanService service;

  KegiatanRepository(this.service);

  Future<List<KegiatanModel>> fetchActivities() async {
    return await service.getActivities();
  }

  // ... kode sebelumnya ...

  Future<bool> addActivity({
    required String name,
    required String category,
    required String date,
    required String location,
    required String personInCharge,
    String? description,
  }) async {
    return await service.createActivity(
      name: name,
      category: category,
      date: date,
      location: location,
      personInCharge: personInCharge,
      description: description,
    );
  }
}