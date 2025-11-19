// // utils/app_logger.dart

// import 'dart:io' if (dart.library.html) 'dart:html';
// import 'package:flutter/foundation.dart';
// import 'package:path_provider/path_provider.dart';

// class AppLogger {
//   static late File _logFile;
//   static bool _initialized = false;

//   static Future<void> init() async {
//     if (_initialized) return;
//     _initialized = true;

//     // =================== WEB ===================
//     if (kIsWeb) {
//       log("==== LOGGER INITIALIZED (Web) ====");
//       return;
//     }
//     // ===========================================

//     // =================== NON-WEB ===================
//     Directory logDir;

//     if (kDebugMode &&
//         (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
//       // Desktop debug mode → akses folder langsung
//       logDir = Directory("logs");
//     } else {
//       // Mobile/real device → gunakan path_provider
//       final dir = await getApplicationDocumentsDirectory();
//       logDir = Directory("${dir.path}/logs");
//     }

//     if (!await logDir.exists()) {
//       await logDir.create(recursive: true);
//     }

//     _logFile = File("${logDir.path}/app.log");

//     log("==== LOGGER INITIALIZED ====");
//   }

//   static void log(String message) {
//     if (!_initialized) return;

//     final time = DateTime.now().toIso8601String();
//     final formatted = "[$time] $message";

//     debugPrint(formatted);

//     // Tulis ke file hanya jika BUKAN Web
//     if (!kIsWeb) {
//       _logFile.writeAsStringSync("$formatted\n", mode: FileMode.append);
//     }
//   }
// }
