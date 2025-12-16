// lib/features/billing/data/repository/billing_repository.dart

import '../models/billing_model.dart';
import '../services/billing_service.dart';

class BillingRepository {
  final BillingService _billingService;

  BillingRepository(this._billingService);

  // Fungsi untuk membuat tagihan baru
  Future<BillingModel> createBilling(CreateBillingPayload payload) async {
    return await _billingService.createBilling(payload);
  }
}