// lib/features/dues_type/data/models/dues_type_model.dart

import 'dart:convert';

// --- Model Iuran Individual ---

class DuesTypeModel {
  final int id;
  final String name;
  final double amount; // Menggunakan double untuk jumlah uang
  final DateTime createdAt;
  final DateTime updatedAt;

  DuesTypeModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DuesTypeModel.fromJson(Map<String, dynamic> json) {
    // Parsing amount menjadi double
    final String amountString = json['amount'].toString();
    final double parsedAmount = double.tryParse(amountString) ?? 0.0;
    
    return DuesTypeModel(
      id: json['id'],
      name: json['name'],
      amount: parsedAmount,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

// --- Model Response Top Level API ---

class ListDuesTypeModel {
  final bool success;
  final String message;
  final List<DuesTypeModel> duesTypes;

  ListDuesTypeModel({
    required this.success,
    required this.message,
    required this.duesTypes,
  });

  factory ListDuesTypeModel.fromJson(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    final List<dynamic> dataList = jsonMap['data'] as List<dynamic>;
    
    final duesTypes = dataList
        .map((i) => DuesTypeModel.fromJson(i as Map<String, dynamic>))
        .toList();

    return ListDuesTypeModel(
      success: jsonMap['success'] ?? false,
      message: jsonMap['message'] ?? 'Unknown message',
      duesTypes: duesTypes,
    );
  }
}