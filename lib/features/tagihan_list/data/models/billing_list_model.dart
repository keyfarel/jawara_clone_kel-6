// --- Model Terkait (Sub-Models) ---

import 'dart:convert';

class DuesTypeModel {
  final int id;
  final String name;
  final double amount;

  DuesTypeModel({
    required this.id,
    required this.name,
    required this.amount,
  });

  factory DuesTypeModel.fromJson(Map<String, dynamic> json) {
    return DuesTypeModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'N/A',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
    );
  }
}

class FamilyModel {
  final int id;
  final int houseId;
  final String? kkNumber;
  final String ownershipStatus;
  final String status;

  FamilyModel({
    required this.id,
    required this.houseId,
    this.kkNumber,
    required this.ownershipStatus,
    required this.status,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'] as int? ?? 0,
      houseId: json['house_id'] as int? ?? 0,
      kkNumber: json['kk_number'] as String?,
      ownershipStatus: json['ownership_status'] as String? ?? 'N/A',
      status: json['status'] as String? ?? 'N/A',
    );
  }
}

// --- Billing Model (Data Item di dalam List) ---

class BillingListItemModel {
  final int id;
  final int familyId;
  final int duesTypeId;
  final String billingCode;
  final String period;
  final double amount;
  final String status;
  final DateTime createdAt;
  final FamilyModel family;
  final DuesTypeModel duesType;

  BillingListItemModel({
    required this.id,
    required this.familyId,
    required this.duesTypeId,
    required this.billingCode,
    required this.period,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.family,
    required this.duesType,
  });

  factory BillingListItemModel.fromJson(Map<String, dynamic> json) {
    final double parsedAmount = double.tryParse(json['amount'].toString()) ?? 0.0;

    return BillingListItemModel(
      id: json['id'] as int? ?? 0,
      familyId: json['family_id'] as int? ?? 0,
      duesTypeId: json['dues_type_id'] as int? ?? 0,
      billingCode: json['billing_code'] as String? ?? 'N/A',
      period: json['period'] as String? ?? 'N/A',
      amount: parsedAmount,
      status: json['status'] as String? ?? 'N/A',
      createdAt: DateTime.tryParse(json['created_at'].toString()) ?? DateTime(0),
      // Parsing sub-model
      family: FamilyModel.fromJson(json['family'] as Map<String, dynamic>),
      duesType: DuesTypeModel.fromJson(json['dues_type'] as Map<String, dynamic>),
    );
  }
}

// --- Model Response Top Level List (Paginated) ---

class BillingListResponse {
  final bool success;
  final String message;
  final int currentPage;
  final int lastPage;
  final List<BillingListItemModel> data;

  BillingListResponse({
    required this.success,
    required this.message,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory BillingListResponse.fromJson(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final dataMap = jsonMap['data'] as Map<String, dynamic>?;

    if (dataMap == null) {
      return BillingListResponse(
        success: jsonMap['success'] ?? false,
        message: jsonMap['message'] ?? 'Data tidak ditemukan',
        currentPage: 0,
        lastPage: 0,
        data: [],
      );
    }

    return BillingListResponse(
      success: jsonMap['success'] ?? false,
      message: jsonMap['message'] ?? 'List data tagihan',
      currentPage: dataMap['current_page'] as int? ?? 0,
      lastPage: dataMap['last_page'] as int? ?? 0,
      data: (dataMap['data'] as List<dynamic>?)
          ?.map((item) => BillingListItemModel.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}