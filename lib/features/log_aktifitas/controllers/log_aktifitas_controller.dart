import 'package:flutter/material.dart';
import '../data/models/activity_model.dart';
import '../data/repository/log_aktifitas_repository.dart';

class LogAktifitasController extends ChangeNotifier {
  final LogAktifitasRepository repository;

  LogAktifitasController(this.repository);

  List<ActivityModel> _activities = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ActivityModel> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadActivities() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchActivities();
      _activities = result;

      // SEKARANG SORTING SUDAH BISA DIGUNAKAN
      // Mengurutkan dari yang paling baru (Descending)
      _activities.sort((a, b) => b.activityDate.compareTo(a.activityDate));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
