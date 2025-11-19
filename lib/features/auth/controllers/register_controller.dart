import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import '../data/models/register_request.dart';

class RegisterController extends ChangeNotifier {
  final AuthRepository repository;

  RegisterController(this.repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await repository.register(request);
      return result;
    } catch (e) {
      return {
        'status': 'error', 
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}