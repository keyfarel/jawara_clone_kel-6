import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/auth_repository.dart';
import '../data/models/login_request.dart';

class LoginController extends ChangeNotifier {
  final AuthRepository repository;

  LoginController(this.repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Login Biasa
  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final request = LoginRequest(email: email, password: password);
      final result = await repository.login(request);
      return result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login Wajah
  Future<Map<String, dynamic>> loginFace(XFile selfie) async {
    _isLoading = true;
    notifyListeners();

    try {
      // PERBAIKAN: Panggil langsung repository.loginFace (karena sudah kita buat methodnya di repo)
      final result = await repository.loginFace(selfie); 
      return result;
    } catch (e) {
        return {'status': 'error', 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}