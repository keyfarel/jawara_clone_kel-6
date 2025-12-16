import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtherIncomePostService {
  // Base URL yang ditentukan oleh pengguna
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api'; 

  Future<http.Response> postOtherIncome({
    required int categoryId,
    required String title,
    required double amount,
    required DateTime transactionDate,
    String? description,
    File? proofImage, // Menggunakan File dari dart:io
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');
    
    final url = Uri.parse('$baseUrl/other-incomes');
    
    if (token == null) {
      throw Exception('Autentikasi gagal: Access token tidak ditemukan.');
    }
    
    try {
      // Format tanggal ke string 'YYYY-MM-DD'
      final dateString = DateFormat('yyyy-MM-dd').format(transactionDate);

      // 1. Buat MultipartRequest
      var request = http.MultipartRequest('POST', url)
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $token'
        // Menambahkan header ngrok untuk menghindari browser warning
        ..headers['ngrok-skip-browser-warning'] = 'true' 
        
        // 2. Tambahkan fields (selain file)
        ..fields['transaction_category_id'] = categoryId.toString()
        ..fields['title'] = title
        // Mengubah double kembali menjadi string
        ..fields['amount'] = amount.toString() 
        ..fields['transaction_date'] = dateString
        ..fields['description'] = description ?? '';

      // 3. Tambahkan file jika ada
      if (proofImage != null) {
        final file = await http.MultipartFile.fromPath(
          'proof_image', // Nama field di API (proof_image)
          proofImage.path,
        );
        request.files.add(file);
      }
      
      // 4. Kirim request
      final streamResponse = await request.send();
      // 5. Ubah StreamedResponse menjadi Response
      final response = await http.Response.fromStream(streamResponse);

      // 6. Penanganan Status Code yang lebih terstruktur (mirip DuesTypeService)
      if (response.statusCode == 201) {
        return response; // Berhasil dibuat
      } else if (response.statusCode == 401) {
        throw Exception('Autentikasi gagal. Sesi Anda mungkin telah berakhir.');
      } else {
        // Coba decode body untuk mendapatkan pesan error spesifik jika ada
        String errorMessage = 'Gagal menambahkan pemasukan. Status Code: ${response.statusCode}';
        try {
          final errorJson = json.decode(response.body);
          if (errorJson['message'] != null) {
            errorMessage = 'Gagal menambahkan pemasukan: ${errorJson['message']}';
          }
        } catch (_) {
          // Abaikan jika body tidak bisa di-decode (bukan JSON)
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Menangkap error jaringan, I/O, atau Exception yang dilempar di atas
      throw Exception('Terjadi kesalahan saat koneksi: $e');
    }
  }
}