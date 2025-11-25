import 'auth_service.dart';
import 'models/login_request.dart';
import 'models/register_request.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository(this.service);

  Future<Map<String, dynamic>> login(LoginRequest request) {
    return service.login(request);
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