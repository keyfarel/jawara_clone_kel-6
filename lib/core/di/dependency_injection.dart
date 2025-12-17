import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// Auth
import '../../features/auth/controllers/login_controller.dart';
import '../../features/auth/controllers/register_controller.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/auth_service.dart';

// Dashboard
import '../../features/dashboard/controllers/dashboard_controller.dart';
import '../../features/dashboard/data/repository/dashboard_repository.dart';
import '../../features/dashboard/data/services/dashboard_service.dart';

// Log Aktivitas
import '../../features/log_aktifitas/controllers/log_aktifitas_controller.dart';
import '../../features/log_aktifitas/data/repository/log_aktifitas_repository.dart';
import '../../features/log_aktifitas/data/services/log_aktifitas_services.dart';

// Mutasi Keluarga
import '../../features/mutasi_keluarga/controllers/mutasi_controller.dart';
import '../../features/mutasi_keluarga/data/repository/mutasi_repository.dart';
import '../../features/mutasi_keluarga/data/services/mutasi_service.dart';

// Channel Transfer
import '../../features/channel_transfer/controllers/channel_controller.dart';
import '../../features/channel_transfer/data/repository/channel_repository.dart';
import '../../features/channel_transfer/data/services/channel_service.dart';

// Manajemen Pengguna
import '../../features/manajemen_pengguna/controllers/user_controller.dart';
import '../../features/manajemen_pengguna/data/repository/user_repository.dart';
import '../../features/manajemen_pengguna/data/services/user_service.dart';

// Penerimaan Warga
import '../../features/penerimaan_warga/controllers/penerimaan_warga_controller.dart';
import '../../features/penerimaan_warga/data/repository/penerimaan_warga_repository.dart';
import '../../features/penerimaan_warga/data/services/penerimaan_warga_service.dart';

// Broadcast & Kegiatan
import '../../features/kegiatan_broadcast/controllers/broadcast_controller.dart';
import '../../features/kegiatan_broadcast/data/services/broadcast_service.dart';
import '../../features/kegiatan_broadcast/data/repository/broadcast_repository.dart';
import '../../features/kegiatan_broadcast/controllers/kegiatan_controller.dart';
import '../../features/kegiatan_broadcast/data/repository/kegiatan_repository.dart';
import '../../features/kegiatan_broadcast/data/services/kegiatan_service.dart';

// Data Warga & Rumah
import '../../features/data_warga_rumah/controllers/rumah_controller.dart';
import '../../features/data_warga_rumah/data/repository/rumah_repository.dart';
import '../../features/data_warga_rumah/data/services/rumah_service.dart';
import '../../features/data_warga_rumah/controllers/citizen_controller.dart';
import '../../features/data_warga_rumah/data/repository/citizen_repository.dart';
import '../../features/data_warga_rumah/data/services/citizen_service.dart';
import '../../features/data_warga_rumah/controllers/family_controller.dart';
import '../../features/data_warga_rumah/data/repository/family_repository.dart';
import '../../features/data_warga_rumah/data/services/family_service.dart';

// Keuangan: Laporan & Pemasukan
import '../../features/laporan_keuangan/controllers/laporan_controller.dart';
import '../../features/laporan_keuangan/data/repository/laporan_repository.dart';
import '../../features/laporan_keuangan/data/services/laporan_service.dart';
import '../../features/laporan_keuangan/controllers/semua_pengeluaran_controller.dart';
import '../../features/laporan_keuangan/data/repository/semua_pengeluaran_repository.dart';
import '../../features/laporan_keuangan/data/services/semua_pengeluaran_service.dart';
import '../../features/laporan_keuangan/controllers/other_income_controller.dart';
import '../../features/laporan_keuangan/data/repository/other_income_repository.dart';
import '../../features/laporan_keuangan/data/services/other_income_service.dart';

// Kategori & Tagihan
import '../../features/kategori_iuran/controllers/dues_type_controller.dart';
import '../../features/kategori_iuran/data/repository/dues_type_repository.dart';
import '../../features/kategori_iuran/data/services/dues_type_service.dart';
import '../../features/tagih_iuran/controllers/billing_controller.dart';
import '../../features/tagih_iuran/data/repository/billing_repository.dart';
import '../../features/tagih_iuran/data/services/billing_service.dart';
import '../../features/tagihan_list/controllers/billing_list_controller.dart';
import '../../features/tagihan_list/data/repository/billing_list_repository.dart';
import '../../features/tagihan_list/data/services/billing_list_service.dart';

// List & Tambah Pemasukan
import '../../features/list_pemasukan/controllers/other_income_list_controller.dart';
import '../../features/list_pemasukan/data/repository/other_income_list_repository.dart';
import '../../features/list_pemasukan/data/services/other_income_list_service.dart';
import '../../features/tambah_pemasukan/controllers/other_income_post_controller.dart';
import '../../features/tambah_pemasukan/data/repository/other_income_post_repository.dart';
import '../../features/tambah_pemasukan/data/services/other_income_post_service.dart';
import '../../features/shared/controllers/transaction_category_controller.dart';
import '../../features/shared/data/repository/transaction_category_repository.dart';
import '../../features/shared/data/services/transaction_category_service.dart';

// Informasi Aspirasi
import '../../features/informasi_aspirasi/controllers/aspirasi_controller.dart';
import '../../features/informasi_aspirasi/data/repository/aspirasi_repository.dart';
import '../../features/informasi_aspirasi/data/services/aspirasi_service.dart';

// Pengeluaran
import '../../features/tambah_pengeluaran/controllers/other_expense_controller.dart';
import '../../features/tambah_pengeluaran/data/repository/other_expense_repository.dart';
import '../../features/tambah_pengeluaran/data/services/other_expense_service.dart';
import '../../features/list_pengeluaran/controllers/other_expense_list_controller.dart';
import '../../features/list_pengeluaran/data/repository/other_expense_list_repository.dart';
import '../../features/list_pengeluaran/data/services/other_expense_list_service.dart';

class DependencyInjection {
  static List<SingleChildWidget> init() {

    // Shared repository instance for Auth
    final authRepo = AuthRepository(AuthService());

    return [
      // Auth (login & register)
      Provider<AuthRepository>.value(value: authRepo),
      ChangeNotifierProvider(create: (_) => LoginController(authRepo)),
      ChangeNotifierProvider(create: (_) => RegisterController(authRepo)),
      ChangeNotifierProvider(create: (_) => UserController(UserRepository(UserService()))),

      // Dashboard
      ChangeNotifierProvider(create: (_) => DashboardController(DashboardRepository(DashboardService()))),

      // Log Aktivitas
      ChangeNotifierProvider(create: (_) => LogAktifitasController(LogAktifitasRepository(LogAktifitasService()))),

      // Mutasi keluarga
      ChangeNotifierProvider(create: (_) => MutasiController(MutasiRepository(MutasiService()))),

      // Channel transfer
      ChangeNotifierProvider(create: (_) => ChannelController(ChannelRepository(ChannelService()))),

      // Broadcast & kegiatan
      ChangeNotifierProvider(create: (_) => BroadcastController(BroadcastRepository(BroadcastService()))),
      ChangeNotifierProvider(create: (_) => KegiatanController(KegiatanRepository(KegiatanService()))),

      // Penerimaan warga
      ChangeNotifierProvider(create: (_) => PenerimaanWargaController(PenerimaanWargaRepository(PenerimaanWargaService()))),

      // Data rumah & warga
      ChangeNotifierProvider(create: (_) => RumahController(RumahRepository(RumahService()))),
      ChangeNotifierProvider(create: (_) => CitizenController(CitizenRepository(CitizenService()))),
      ChangeNotifierProvider(create: (_) => FamilyController(FamilyRepository(FamilyService()))),

      // Aspirasi
      ChangeNotifierProvider(create: (_) => AspirasiController(AspirasiRepository(AspirasiService()))),

      // Laporan keuangan
      ChangeNotifierProvider(create: (_) => LaporanController(LaporanRepository(LaporanService()))),
      ChangeNotifierProvider(create: (_) => OtherIncomeController(OtherIncomeRepository(OtherIncomeService()))),

      // Kategori & tagihan
      ChangeNotifierProvider(create: (_) => DuesTypeController(DuesTypeRepository(DuesTypeService()))),
      ChangeNotifierProvider(create: (_) => BillingController(BillingRepository(BillingService()))),
      ChangeNotifierProvider(create: (_) => BillingListController(BillingListRepositoryImpl(BillingListService()))),

      // Pemasukan: list & tambah
      ChangeNotifierProvider(create: (_) => OtherIncomeListController(OtherIncomeRepositoryImpl(OtherIncomeListService()))),
      ChangeNotifierProvider(create: (_) => OtherIncomePostController(OtherIncomePostRepositoryImpl(OtherIncomePostService()))),
      ChangeNotifierProvider(create: (_) => TransactionCategoryController(TransactionCategoryRepository(TransactionCategoryService()))),

      // Pengeluaran (semua + tambah + list)
      Provider(create: (_) => SemuaPengeluaranController(repository: SemuaPengeluaranRepository(service: SemuaPengeluaranService()))),
      ChangeNotifierProvider(create: (_) => OtherExpenseController(OtherExpenseRepository(OtherExpenseService()))),
      ChangeNotifierProvider(create: (_) => OtherExpenseListController(OtherExpenseListRepository(OtherExpenseListService()))),
    ];
  }
}
