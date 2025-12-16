import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'routes/app_routes.dart';

// Auth
import 'features/auth/controllers/login_controller.dart';
import 'features/auth/controllers/register_controller.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/data/auth_service.dart';

// Dashboard
import 'features/dashboard/controllers/dashboard_controller.dart';
import 'features/dashboard/data/repository/dashboard_repository.dart';
import 'features/dashboard/data/services/dashboard_service.dart';

// Log Aktivitas
import 'features/log_aktifitas/controllers/log_aktifitas_controller.dart';
import 'features/log_aktifitas/data/repository/log_aktifitas_repository.dart';
import 'features/log_aktifitas/data/services/log_aktifitas_services.dart';

// Mutasi Keluarga
import 'features/mutasi_keluarga/controllers/mutasi_controller.dart';
import 'features/mutasi_keluarga/data/repository/mutasi_repository.dart';
import 'features/mutasi_keluarga/data/services/mutasi_service.dart';

// Channel Transfer
import 'features/channel_transfer/controllers/channel_controller.dart';
import 'features/channel_transfer/data/repository/channel_repository.dart';
import 'features/channel_transfer/data/services/channel_service.dart';

// Manajemen Pengguna
import 'features/manajemen_pengguna/controllers/user_controller.dart';
import 'features/manajemen_pengguna/data/repository/user_repository.dart';
import 'features/manajemen_pengguna/data/services/user_service.dart';

// Penerimaan Warga
import 'features/penerimaan_warga/controllers/penerimaan_warga_controller.dart';
import 'features/penerimaan_warga/data/repository/penerimaan_warga_repository.dart';
import 'features/penerimaan_warga/data/services/penerimaan_warga_service.dart';

// Broadcast & Kegiatan
import 'features/kegiatan_broadcast/controllers/broadcast_controller.dart';
import 'features/kegiatan_broadcast/data/services/broadcast_service.dart';
import 'features/kegiatan_broadcast/data/repository/broadcast_repository.dart';

import 'features/kegiatan_broadcast/controllers/kegiatan_controller.dart';
import 'features/kegiatan_broadcast/data/repository/kegiatan_repository.dart';
import 'features/kegiatan_broadcast/data/services/kegiatan_service.dart';

// Data Warga & Rumah
import 'features/data_warga_rumah/controllers/rumah_controller.dart';
import 'features/data_warga_rumah/data/repository/rumah_repository.dart';
import 'features/data_warga_rumah/data/services/rumah_service.dart';

import 'features/data_warga_rumah/controllers/citizen_controller.dart';
import 'features/data_warga_rumah/data/repository/citizen_repository.dart';
import 'features/data_warga_rumah/data/services/citizen_service.dart';

import 'features/Keluarga/controllers/keluarga_controller.dart';
import 'features/Keluarga/data/repository/keluarga_repository.dart';
import 'features/Keluarga/data/services/keluarga_service.dart';
import 'features/laporan_keuangan/controllers/laporan_controller.dart';
import 'features/laporan_keuangan/data/repository/laporan_repository.dart';
import 'features/laporan_keuangan/data/services/laporan_service.dart';

// pemasukan
import 'features/kategori_iuran/controllers/dues_type_controller.dart';
import 'features/kategori_iuran/data/repository/dues_type_repository.dart';
import 'features/kategori_iuran/data/services/dues_type_service.dart';

import 'features/tagih_iuran/controllers/billing_controller.dart';
import 'features/tagih_iuran/data/repository/billing_repository.dart';
import 'features/tagih_iuran/data/services/billing_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  // Services
  final authService = AuthService();
  final dashboardService = DashboardService();
  final logService = LogAktifitasService();
  final mutasiService = MutasiService();
  final channelService = ChannelService();
  final broadcastService = BroadcastService();
  final userService = UserService();
  final penerimaanService = PenerimaanWargaService();
  final rumahService = RumahService();
  final citizenService = CitizenService();
  final kegiatanService = KegiatanService();
  final keluargaService = KeluargaService();
  final laporanService = LaporanService();
  final duesTypeService = DuesTypeService();
  final billingService = BillingService();

  // Repositories
  final authRepo = AuthRepository(authService);
  final dashboardRepo = DashboardRepository(dashboardService);
  final logRepo = LogAktifitasRepository(logService);
  final mutasiRepo = MutasiRepository(mutasiService);
  final channelRepo = ChannelRepository(channelService);
  final broadcastRepo = BroadcastRepository(broadcastService);
  final userRepo = UserRepository(userService);
  final penerimaanRepo = PenerimaanWargaRepository(penerimaanService);
  final rumahRepo = RumahRepository(rumahService);
  final citizenRepo = CitizenRepository(citizenService);
  final kegiatanRepo = KegiatanRepository(kegiatanService);
  final keluargaRepo = KeluargaRepository(keluargaService);
  final laporanRepo = LaporanRepository(laporanService);
  final duesTypeRepo = DuesTypeRepository(duesTypeService);
  final billingRepo = BillingRepository(billingService);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<AuthRepository>.value(value: authRepo),

        ChangeNotifierProvider(create: (_) => LoginController(authRepo)),
        ChangeNotifierProvider(create: (_) => RegisterController(authRepo)),
        ChangeNotifierProvider(create: (_) => DashboardController(dashboardRepo)),
        ChangeNotifierProvider(create: (_) => LogAktifitasController(logRepo)),
        ChangeNotifierProvider(create: (_) => MutasiController(mutasiRepo)),
        ChangeNotifierProvider(create: (_) => ChannelController(channelRepo)),
        ChangeNotifierProvider(create: (_) => BroadcastController(broadcastRepo)),
        ChangeNotifierProvider(create: (_) => UserController(userRepo)),
        ChangeNotifierProvider(create: (_) => PenerimaanWargaController(penerimaanRepo)),
        ChangeNotifierProvider(create: (_) => RumahController(rumahRepo)),
        ChangeNotifierProvider(create: (_) => CitizenController(citizenRepo)),
        ChangeNotifierProvider(create: (_) => KegiatanController(kegiatanRepo)),
        ChangeNotifierProvider(create: (_) => KeluargaController(keluargaRepo)),
        ChangeNotifierProvider(create: (_) => LaporanController(laporanRepo)),
        ChangeNotifierProvider(create: (_) => DuesTypeController(duesTypeRepo)),
        ChangeNotifierProvider(create: (_) => BillingController(billingRepo)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jawara Pintar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade50,
        fontFamily: 'Poppins',
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
