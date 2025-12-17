import '../models/other_income_model.dart';
import '../services/other_income_service.dart';

class OtherIncomeRepository {
  final OtherIncomeService service;

  OtherIncomeRepository(this.service);

  Future<List<OtherIncomeModel>> fetchIncomes({String? startDate, String? endDate}) {
    return service.getIncomes(startDate: startDate, endDate: endDate);
  }
}