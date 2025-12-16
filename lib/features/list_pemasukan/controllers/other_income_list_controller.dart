import 'package:flutter/material.dart';
import '../data/models/other_income_list_model.dart';
import '../data/repository/other_income_list_repository.dart';

enum OtherIncomeListState { initial, loading, loaded, error }

class OtherIncomeListController extends ChangeNotifier {
  final OtherIncomeListRepository _repository;

  OtherIncomeListController(this._repository);

  OtherIncomeListState _state = OtherIncomeListState.initial;
  OtherIncomeListState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  List<OtherIncomeItemModel> _otherIncomes = [];
  List<OtherIncomeItemModel> get otherIncomes => _otherIncomes;


  Future<void> fetchOtherIncomes() async {
    if (_state == OtherIncomeListState.loading) return;

    _state = OtherIncomeListState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.fetchOtherIncomes();
      
      if (response.success) {
        _otherIncomes = response.data;
        _state = OtherIncomeListState.loaded;
      } else {
        _errorMessage = response.message;
        _state = OtherIncomeListState.error;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = OtherIncomeListState.error;
    } finally {
      notifyListeners();
    }
  }
}