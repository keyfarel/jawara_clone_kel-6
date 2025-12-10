import '../models/pengeluaran_model.dart';
import '../services/pengeluaran_service.dart';

class PengeluaranRepository {
  // Singleton pattern
  static final PengeluaranRepository _instance = PengeluaranRepository._internal();
  factory PengeluaranRepository() => _instance;
  PengeluaranRepository._internal();

  // Repository memanggil Service
  final PengeluaranService _service = PengeluaranService();

  List<Pengeluaran> getAll() {
    return _service.fetchAll();
  }

  void add(Pengeluaran pengeluaran) {
    _service.create(pengeluaran);
  }
}