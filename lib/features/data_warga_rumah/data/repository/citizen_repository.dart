import '../models/citizen_model.dart';
import '../services/citizen_service.dart';

class CitizenRepository {
  final CitizenService service;

  CitizenRepository(this.service);

  Future<List<CitizenModel>> fetchCitizens() async {
    return await service.getCitizens();
  }
}