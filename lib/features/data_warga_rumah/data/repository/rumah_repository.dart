import '../models/rumah_model.dart';
import '../services/rumah_service.dart';

class RumahRepository {
  final RumahService service;

  RumahRepository(this.service);

  Future<List<RumahModel>> fetchHouses() async {
    return await service.getHouses();
  }

  // ... kode sebelumnya ...

  Future<bool> addHouse({
    required String houseName,
    required String ownerName,
    required String address,
    required String houseType,
    required bool hasFacilities,
    String status = 'empty',
  }) async {
    return await service.createHouse(
      houseName: houseName,
      ownerName: ownerName,
      address: address,
      houseType: houseType,
      hasFacilities: hasFacilities,
      status: status,
    );
  }
}