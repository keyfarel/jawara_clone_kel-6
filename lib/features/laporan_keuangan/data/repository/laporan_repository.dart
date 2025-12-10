import '../models/finance_report_model.dart';
import '../services/laporan_service.dart';

class LaporanRepository {
  final LaporanService service;

  LaporanRepository(this.service);

  Future<FinanceReportModel> fetchReport({
    required String startDate,
    required String endDate,
    required String type,
  }) async {
    return await service.getReport(
      startDate: startDate, 
      endDate: endDate, 
      type: type
    );
  }
}