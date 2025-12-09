import 'package:flutter/material.dart';
import '../data/models/kegiatan_model.dart';
import '../data/repository/kegiatan_repository.dart';

class KegiatanController extends ChangeNotifier {
  final KegiatanRepository repository;

  KegiatanController(this.repository);

  List<KegiatanModel> _activities = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<KegiatanModel> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadActivities() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchActivities();
      _activities = result;
      // Sort: Terbaru (Date Descending)
      _activities.sort((a, b) => b.activityDate.compareTo(a.activityDate));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ... kode sebelumnya ...

  // Add Activity
  Future<bool> addActivity({
    required String name,
    required String category,
    required String date,
    required String location,
    required String personInCharge,
    String? description,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.addActivity(
        name: name,
        category: category,
        date: date,
        location: location,
        personInCharge: personInCharge,
        description: description,
      );
      
      // Refresh list agar data baru muncul
      await loadActivities(); 
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