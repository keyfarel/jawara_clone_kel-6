import 'auth_service.dart';
import 'models/login_request.dart';
import 'models/register_request.dart';
import 'package:image_picker/image_picker.dart'; // Tambahkan ini utk XFile

class AuthRepository {
  // Properti ini PUBLIC (tidak pakai underscore), jadi bisa diakses via repository.service
  final AuthService service;
  AuthRepository(this.service);

  Future<Map<String, dynamic>> login(LoginRequest request) {
    return service.login(request);
  }

  // Tambahkan wrapper untuk loginFace agar Controller tidak perlu akses 'service' langsung
  // Ini best practice: Repository membungkus semua method Service
  Future<Map<String, dynamic>> loginFace(XFile selfie) {
    return service.loginFace(selfie);
  }

  Future<Map<String, dynamic>> register(RegisterRequest request) {
    return service.register(request);
  }

  Future<List<dynamic>> getHouseOptions() async {
    try {
      final response = await service.fetchHouseOptions();
      return response; 
    } catch (e) {
      rethrow;
    }
  }
}