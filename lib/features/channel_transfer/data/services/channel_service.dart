import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/channel_model.dart';
import 'package:image_picker/image_picker.dart'; // Tambahkan ini

class ChannelService {
  final String baseUrl = 'https://unmoaning-lenora-photomechanically.ngrok-free.dev/api';

  Future<List<ChannelModel>> getChannels() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final uri = Uri.parse('$baseUrl/payment-channels');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['status'] == 'success') {
        final List data = body['data'];
        return data.map((json) => ChannelModel.fromJson(json)).toList();
      }
    }
    
    throw Exception('Gagal memuat channel: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> createChannel({
    required String name,
    required String type,
    required String accountNumber,
    required String accountName,
    String? notes,
    XFile? thumbnail,
    XFile? qrCode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final uri = Uri.parse('$baseUrl/payment-channels');

    var request = http.MultipartRequest('POST', uri);
    
    // Headers
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'ngrok-skip-browser-warning': 'true',
    });

    // Fields
    request.fields['channel_name'] = name;
    request.fields['type'] = type; // bank_transfer, e_wallet, qris
    request.fields['account_number'] = accountNumber;
    request.fields['account_name'] = accountName;
    if (notes != null) request.fields['notes'] = notes;
    request.fields['is_active'] = '1'; // Default aktif

    // Files
    if (thumbnail != null) {
      final bytes = await thumbnail.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'thumbnail',
        bytes,
        filename: thumbnail.name,
      ));
    }

    if (qrCode != null) {
      final bytes = await qrCode.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'qr_code',
        bytes,
        filename: qrCode.name,
      ));
    }

    // Send
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      } else {
        throw Exception(body['message'] ?? 'Gagal membuat channel');
      }
    } catch (e) {
      rethrow;
    }
  }
}