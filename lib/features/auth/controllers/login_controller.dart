import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import '../data/models/login_request.dart';

class LoginController with ChangeNotifier {
  final AuthRepository repository;

  bool isLoading = false;

  LoginController(this.repository);

  Future<Map<String, dynamic>> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final request = LoginRequest(email: email, password: password);
    final result = await repository.login(request);

    isLoading = false;
    notifyListeners();

    return result;
  }
}
