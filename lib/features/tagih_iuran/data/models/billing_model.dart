// lib/features/billing/data/models/billing_model.dart

import 'dart:convert';

// --- Model Data yang Dikirim (Request Payload) ---
class CreateBillingPayload {
  final int familyId;
  final int duesTypeId;
  final String period;
  final double amount; // Menggunakan double untuk jumlah uang

  CreateBillingPayload({
    required this.familyId,
    required this.duesTypeId,
    required this.period,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'family_id': familyId,
      'dues_type_id': duesTypeId,
      'period': period,
      'amount': amount,
    };
  }
}


// --- Model Response Data Tagihan (Data yang Diterima) ---
class BillingModel {
  final int id;
  final int familyId;
  final int duesTypeId;
  final String billingCode;
  final String period;
  final double amount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  BillingModel({
    required this.id,
    required this.familyId,
    required this.duesTypeId,
    required this.billingCode,
    required this.period,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BillingModel.fromJson(Map<String, dynamic> json) {
    // Parsing amount menjadi double
    final double parsedAmount = double.tryParse(json['amount'].toString()) ?? 0.0;
    
    return BillingModel(
      id: json['id'] as int? ?? 0,
      familyId: json['family_id'] as int? ?? 0,
      duesTypeId: json['dues_type_id'] as int? ?? 0,
      billingCode: json['billing_code'] as String? ?? 'N/A',
      period: json['period'] as String? ?? 'N/A',
      amount: parsedAmount,
      status: json['status'] as String? ?? 'N/A',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime(0),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime(0),
    );
  }
}

// --- Model Response Top Level API (Untuk menangani success/message) ---
class CreateBillingResponse {
  final bool success;
  final String message;
  final BillingModel? billingData;

  CreateBillingResponse({
    required this.success,
    required this.message,
    this.billingData,
  });

  factory CreateBillingResponse.fromJson(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    return CreateBillingResponse(
      success: jsonMap['success'] ?? false,
      message: jsonMap['message'] ?? 'Unknown message',
      billingData: jsonMap['data'] != null 
          ? BillingModel.fromJson(jsonMap['data'] as Map<String, dynamic>) 
          : null,
    );
  }
}