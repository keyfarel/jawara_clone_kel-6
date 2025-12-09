import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'routes/app_routes.dart';

// --- AUTH IMPORTS ---
import 'features/auth/controllers/login_controller.dart';
import 'features/auth/controllers/register_controller.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/data/auth_service.dart';

// --- DASHBOARD IMPORTS (BARU) ---
import 'features/dashboard/controllers/dashboard_controller.dart';
import 'features/dashboard/data/repository/dashboard_repository.dart';
import 'features/dashboard/data/services/dashboard_service.dart';

// --- LOG AKTIFITAS IMPORTS ---
import 'features/log_aktifitas/controllers/log_aktifitas_controller.dart';
import 'features/log_aktifitas/data/repository/log_aktifitas_repository.dart';
import 'features/log_aktifitas/data/services/log_aktifitas_services.dart';

// --- MUTASI KELUARGA IMPORTS ---
import 'features/mutasi_keluarga/controllers/mutasi_controller.dart';
import 'features/mutasi_keluarga/data/repository/mutasi_repository.dart';
import 'features/mutasi_keluarga/data/services/mutasi_service.dart';

// --- CHANNEL TRANSFER IMPORTS ---
import 'features/channel_transfer/controllers/channel_controller.dart';
import 'features/channel_transfer/data/repository/channel_repository.dart';
import 'features/channel_transfer/data/services/channel_service.dart';

// --- MANAJEMEN PENGGUNA IMPORTS ---
import 'features/manajemen_pengguna/controllers/user_controller.dart';
import 'features/manajemen_pengguna/data/repository/user_repository.dart';
import 'features/manajemen_pengguna/data/services/user_service.dart';

// --- PENERIMAAN WARGA IMPORTS ---
import 'features/penerimaan_warga/controllers/penerimaan_warga_controller.dart';
import 'features/penerimaan_warga/data/repository/penerimaan_warga_repository.dart';
import 'features/penerimaan_warga/data/services/penerimaan_warga_service.dart';


import 'features/kegiatan_broadcast/controllers/broadcast_controller.dart';
import 'features/kegiatan_broadcast/data/services/broadcast_service.dart';
import 'features/kegiatan_broadcast/data/repository/broadcast_repository.dart';

// data warga dan rumah
import 'features/data_warga_rumah/controllers/rumah_controller.dart';
import 'features/data_warga_rumah/data/repository/rumah_repository.dart';
import 'features/data_warga_rumah/data/services/rumah_service.dart';

import 'features/data_warga_rumah/controllers/citizen_controller.dart';
import 'features/data_warga_rumah/data/repository/citizen_repository.dart';
import 'features/data_warga_rumah/data/services/citizen_service.dart';

import 'features/kegiatan_broadcast/controllers/kegiatan_controller.dart';
import 'features/kegiatan_broadcast/data/repository/kegiatan_repository.dart';
import 'features/kegiatan_broadcast/data/services/kegiatan_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Format Tanggal Indonesia
  await initializeDateFormatting('id_ID', null);

  // ==========================================
  // 1. Inisialisasi SERVICE (Akses API)
  // ==========================================
  final authService = AuthService();
  final dashboardService = DashboardService(); // Tambahan Dashboard
  final logService = LogAktifitasService();
  final mutasiService = MutasiService();
  final channelService = ChannelService();
  final broadcastService = BroadcastService();
  final userService = UserService();
  final penerimaanService = PenerimaanWargaService();
  final rumahService = RumahService();
  final citizenService = CitizenService();
  final kegiatanService = KegiatanService();

  // ==========================================
  // 2. Inisialisasi REPOSITORY (Jembatan Data)
  // ==========================================
  final authRepo = AuthRepository(authService);
  final dashboardRepo = DashboardRepository(dashboardService); // Tambahan Dashboard
  final logRepo = LogAktifitasRepository(logService);
  final mutasiRepo = MutasiRepository(mutasiService);
  final channelRepo = ChannelRepository(channelService);
  final broadcastRepo = BroadcastRepository(broadcastService);
  final userRepo = UserRepository(userService);
  final penerimaanRepo = PenerimaanWargaRepository(penerimaanService);
  final rumahRepo = RumahRepository(rumahService);
  final citizenRepo = CitizenRepository(citizenService);
  final kegiatanRepo = KegiatanRepository(kegiatanService);

  runApp(
    MultiProvider(
      providers: [
        // --- Auth Providers ---
        Provider<AuthService>.value(value: authService),
        Provider<AuthRepository>.value(value: authRepo),
        ChangeNotifierProvider(create: (_) => LoginController(authRepo)),
        ChangeNotifierProvider(create: (_) => RegisterController(authRepo)),

        // --- Dashboard Provider (BARU) ---
        ChangeNotifierProvider(create: (_) => DashboardController(dashboardRepo)),

        // --- Log Aktifitas Provider ---
        ChangeNotifierProvider(create: (_) => LogAktifitasController(logRepo)),

        // --- Mutasi Keluarga Provider ---
        ChangeNotifierProvider(create: (_) => MutasiController(mutasiRepo)),

        // --- Channel Transfer Provider ---
        ChangeNotifierProvider(create: (_) => ChannelController(channelRepo)),
        ChangeNotifierProvider(
          create: (_) => BroadcastController(broadcastRepo),
        ),

        // --- Manajemen Pengguna Provider ---
        ChangeNotifierProvider(create: (_) => UserController(userRepo)),

        // --- Penerimaan Warga Provider ---
        ChangeNotifierProvider(create: (_) => PenerimaanWargaController(penerimaanRepo)),

        ChangeNotifierProvider(create: (_) => RumahController(rumahRepo)),

        ChangeNotifierProvider(create: (_) => CitizenController(citizenRepo)),

        ChangeNotifierProvider(create: (_) => KegiatanController(kegiatanRepo)),
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
        // Font global bisa diset disini jika perlu
        fontFamily: 'Poppins', 
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
