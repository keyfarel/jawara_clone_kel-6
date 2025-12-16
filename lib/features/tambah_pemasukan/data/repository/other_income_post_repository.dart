import 'dart:io';
import 'dart:convert';
import '../models/other_income_post_model.dart';
import '../services/other_income_post_service.dart';

abstract class OtherIncomePostRepository {
  Future<OtherIncomePostResponse> postOtherIncome({
    required int categoryId,
    required String title,
    required double amount,
    required DateTime transactionDate,
    String? description,
    File? proofImage,
  });
}

class OtherIncomePostRepositoryImpl implements OtherIncomePostRepository {
  final OtherIncomePostService service;

  OtherIncomePostRepositoryImpl(this.service);

  @override
  Future<OtherIncomePostResponse> postOtherIncome({
    required int categoryId,
    required String title,
    required double amount,
    required DateTime transactionDate,
    String? description,
    File? proofImage,
  }) async {
    try {
      // Panggil service. Service akan melempar Exception jika status code tidak 201/401
      final response = await service.postOtherIncome(
        categoryId: categoryId,
        title: title,
        amount: amount,
        transactionDate: transactionDate,
        description: description,
        proofImage: proofImage,
      );

      // Jika service tidak melempar, status code pasti 201 (Success)
      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return OtherIncomePostResponse.fromJson(jsonResponse);
      } else {
         // Seharusnya tidak tercapai karena Service menangani non-201, 
         // tetapi kita sertakan untuk kepastian.
          throw Exception('Respons API tidak valid setelah pemrosesan Service. Status: ${response.statusCode}');
      }
    } catch (e) {
      // Tangkap Exception yang dilempar oleh Service (misalnya Token/Jaringan/Error Logika API)
      // dan lempar kembali sebagai Exception yang lebih bersih untuk Controller.
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}