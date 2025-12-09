import 'package:flutter/material.dart';
import '../data/models/citizen_model.dart';
import '../data/repository/citizen_repository.dart';

class CitizenController extends ChangeNotifier {
  final CitizenRepository repository;

  CitizenController(this.repository);

  List<CitizenModel> _citizens = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CitizenModel> get citizens => _citizens;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCitizens() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchCitizens();
      _citizens = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}