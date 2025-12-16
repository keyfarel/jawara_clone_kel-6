// lib/features/billing/data/repository/billing_list_repository.dart

import '../../data/models/billing_list_model.dart'; // Sesuaikan jika nama file model beda
import '../../data/services/billing_list_service.dart';

abstract class BillingListRepository {
  Future<BillingListResponse> fetchBillings({int page});
}

// Ganti nama kelas implementasi agar unik dan sesuai
class BillingListRepositoryImpl implements BillingListRepository { 
  final BillingListService service;

  // Konstruktor ini WAJIB menerima service
  BillingListRepositoryImpl(this.service); 

  @override
  Future<BillingListResponse> fetchBillings({int page = 1}) {
    return service.fetchBillings(page: page);
  }
}