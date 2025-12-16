import '../models/other_income_list_model.dart';
import '../services/other_income_list_service.dart';

abstract class OtherIncomeListRepository {
  Future<OtherIncomeListResponse> fetchOtherIncomes();
}

class OtherIncomeRepositoryImpl implements OtherIncomeListRepository {
  final OtherIncomeListService service;

  OtherIncomeRepositoryImpl(this.service);

  @override
  Future<OtherIncomeListResponse> fetchOtherIncomes() {
    // Panggilan langsung ke Service
    return service.fetchOtherIncomes();
  }
}