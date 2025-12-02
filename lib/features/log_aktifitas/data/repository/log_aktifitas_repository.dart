import '../models/activity_model.dart';
import '../services/log_aktifitas_services.dart';

class LogAktifitasRepository {
  final LogAktifitasService service;

  LogAktifitasRepository(this.service);

  Future<List<ActivityModel>> fetchActivities() async {
    try {
      return await service.getActivities();
    } catch (e) {
      rethrow;
    }
  }
}