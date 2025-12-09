import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/repository/user_repository.dart';

class UserController extends ChangeNotifier {
  final UserRepository repository;

  UserController(this.repository);

  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load Data
  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchUsers();
      _users = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete Data
  Future<bool> deleteUser(int id) async {
    try {
      await repository.removeUser(id);
      _users.removeWhere((user) => user.id == id); // Hapus lokal biar cepat
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners(); // Update UI untuk show snackbar error
      return false;
    }
  }

  // Update Data (Dipanggil dari Dialog Edit)
  Future<bool> updateUser(int id, String name, String email, String phone, String role, String? password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = {
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
      };
      
      // Hanya kirim password jika diisi (tidak kosong)
      if (password != null && password.isNotEmpty) {
        data['password'] = password;
      }

      await repository.editUser(id, data);
      await loadUsers(); // Refresh list agar data terupdate
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.addUser(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );
      
      // Refresh list pengguna agar data baru muncul
      await loadUsers(); 
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}