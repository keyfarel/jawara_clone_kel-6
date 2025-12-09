import '../models/broadcast_model.dart';
import '../services/broadcast_service.dart';

class BroadcastRepository {
  final BroadcastService service;

  BroadcastRepository(this.service);

  Future<List<BroadcastModel>> getAllBroadcast() {
    return service.getBroadcasts();
  }
}
