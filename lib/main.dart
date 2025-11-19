import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/controllers/login_controller.dart';
import 'features/auth/controllers/register_controller.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/data/auth_service.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  final authRepo = AuthRepository(authService);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<AuthRepository>.value(value: authRepo),
        ChangeNotifierProvider(create: (_) => LoginController(authRepo)),
        ChangeNotifierProvider(create: (_) => RegisterController(authRepo)),
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
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
