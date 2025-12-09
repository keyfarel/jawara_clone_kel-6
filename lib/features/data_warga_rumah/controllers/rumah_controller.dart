import 'package:flutter/material.dart';
import '../data/models/rumah_model.dart';
import '../data/repository/rumah_repository.dart';

class RumahController extends ChangeNotifier {
  final RumahRepository repository;

  RumahController(this.repository);

  List<RumahModel> _houses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<RumahModel> get houses => _houses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHouses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchHouses();
      _houses = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ... kode sebelumnya ...

  // Add House
  Future<bool> addHouse({
    required String houseName,
    required String ownerName,
    required String address,
    required String houseType,
    required bool hasFacilities,
    String status = 'empty',
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.addHouse(
        houseName: houseName,
        ownerName: ownerName,
        address: address,
        houseType: houseType,
        hasFacilities: hasFacilities,
        status: status,
      );
      
      // Refresh list agar data baru muncul
      await loadHouses(); 
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