import '../models/semua_pengeluaran_model.dart';
import '../services/semua_pengeluaran_service.dart';

class SemuaPengeluaranRepository {
  final SemuaPengeluaranService _service;

  SemuaPengeluaranRepository({SemuaPengeluaranService? service})
      : _service = service ?? SemuaPengeluaranService();

  Future<List<SemuaPengeluaranModel>> getDaftarPengeluaran() async {
    try {
      return await _service.fetchTransactions();
    } catch (e) {
      // Melempar pesan error asli dari service
      throw e.toString().replaceFirst('Exception: ', '');
    }
  }
}