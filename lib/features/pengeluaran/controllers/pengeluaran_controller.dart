import 'package:intl/intl.dart';
import '../data/models/pengeluaran_model.dart';
import '../data/repository/pengeluaran_repository.dart';

class PengeluaranController {
  // Controller berbicara dengan Repository
  final PengeluaranRepository _repo = PengeluaranRepository();

  List<Pengeluaran> getPengeluaran({String? filterJenis}) {
    final allData = _repo.getAll();
    
    if (filterJenis == null) {
      return allData;
    }
    return allData.where((item) => item.jenisPengeluaran == filterJenis).toList();
  }

  void tambahPengeluaran({
    required String nama,
    required String jenis,
    required DateTime tanggal,
    required String nominalStr,
  }) {
    String cleanNominal = nominalStr.replaceAll(RegExp(r'[^0-9]'), '');
    double nominal = double.tryParse(cleanNominal) ?? 0;

    final newItem = Pengeluaran(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: nama,
      jenisPengeluaran: jenis,
      tanggal: tanggal,
      nominal: nominal,
    );

    _repo.add(newItem);
  }

  // Utilities
  String formatRupiah(double amount) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0
    );
    return currencyFormatter.format(amount);
  }

  String formatTanggal(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }
}