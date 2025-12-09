import '../models/user_model.dart';
import '../services/user_service.dart';

class UserRepository {
  final UserService service;

  UserRepository(this.service);

  Future<List<UserModel>> fetchUsers() async {
    return await service.getUsers();
  }

  Future<bool> editUser(int id, Map<String, dynamic> data) async {
    return await service.updateUser(id, data);
  }

  Future<bool> removeUser(int id) async {
    return await service.deleteUser(id);
  }

  Future<bool> addUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
    };
    return await service.createUser(data);
  }
}