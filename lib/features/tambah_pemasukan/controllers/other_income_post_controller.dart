import 'dart:io';
import 'package:flutter/material.dart';
import '../data/models/other_income_post_model.dart';
import '../data/repository/other_income_post_repository.dart';

// Enum untuk Status UI
enum OtherIncomePostState { initial, loading, success, error }

class OtherIncomePostController extends ChangeNotifier {
  final OtherIncomePostRepository _repository;

  OtherIncomePostController(this._repository);

  OtherIncomePostState _state = OtherIncomePostState.initial;
  String? _errorMessage;
  OtherIncomePostData? _responseData;

  OtherIncomePostState get state => _state;
  String? get errorMessage => _errorMessage;
  OtherIncomePostData? get responseData => _responseData;

  Future<void> postOtherIncome({
    required int categoryId,
    required String title,
    required double amount,
    required DateTime transactionDate,
    String? description,
    File? proofImage,
  }) async {
    _state = OtherIncomePostState.loading;
    _errorMessage = null;
    _responseData = null;
    notifyListeners();

    try {
      final response = await _repository.postOtherIncome(
        categoryId: categoryId,
        title: title,
        amount: amount,
        transactionDate: transactionDate,
        description: description,
        proofImage: proofImage,
      );
      
      // Jika berhasil, model data sudah terisi dan success: true
      _responseData = response.data;
      _state = OtherIncomePostState.success;
      
    } catch (e) {
      // Tangkap pesan error dari Repository
      _errorMessage = e.toString();
      _state = OtherIncomePostState.error;
    }

    notifyListeners();
  }

  // Utility untuk mereset status
  void resetState() {
    _state = OtherIncomePostState.initial;
    _errorMessage = null;
    _responseData = null;
    notifyListeners();
  }
}