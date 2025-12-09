import '../models/dashboard_model.dart';
import '../services/dashboard_service.dart';

class DashboardRepository {
  final DashboardService service;

  DashboardRepository(this.service);

  Future<DashboardModel> fetchDashboardData() async {
    return await service.getDashboardData();
  }

  // ... kode sebelumnya ...

  Future<FinancialDashboardModel> fetchFinancialData() async {
    return await service.getFinancialData();
  }

  // ... kode sebelumnya ...

  Future<PopulationDashboardModel> fetchPopulationData() async {
    return await service.getPopulationData();
  }

  // ... kode sebelumnya ...

  Future<ActivityDashboardModel> fetchActivityData() async {
    return await service.getActivityData();
  }
}