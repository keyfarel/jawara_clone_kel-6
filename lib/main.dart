import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- AUTH IMPORTS ---
import 'features/auth/controllers/login_controller.dart';
import 'features/auth/controllers/register_controller.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/data/auth_service.dart';

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

import 'routes/app_routes.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Tambahkan baris ini (PENTING!)
  // Ini menyiapkan format tanggal untuk Bahasa Indonesia
  await initializeDateFormatting('id_ID', null);

  // 1. Service
  final authService = AuthService();
  final logService = LogAktifitasService();
  final mutasiService = MutasiService(); // <--- PERBAIKAN: Uncomment ini
  final channelService = ChannelService();

  // 2. Repository
  final authRepo = AuthRepository(authService);
  final logRepo = LogAktifitasRepository(logService);
  final mutasiRepo = MutasiRepository(mutasiService); // Sekarang tidak error
  final channelRepo = ChannelRepository(channelService);

  runApp(
    MultiProvider(
      providers: [
        // Auth
        Provider<AuthService>.value(value: authService),
        Provider<AuthRepository>.value(value: authRepo),
        ChangeNotifierProvider(create: (_) => LoginController(authRepo)),
        ChangeNotifierProvider(create: (_) => RegisterController(authRepo)),

        // Log Aktifitas
        ChangeNotifierProvider(create: (_) => LogAktifitasController(logRepo)),

        // Mutasi Keluarga
        // PERBAIKAN: Uncomment ini juga agar bisa dipakai di halaman Mutasi
        ChangeNotifierProvider(create: (_) => MutasiController(mutasiRepo)),

        // Channel Transfer
        ChangeNotifierProvider(create: (_) => ChannelController(channelRepo)),
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
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}