import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/broadcast_model.dart';

class BroadcastService {
  final String baseUrl =
      "https://unmoaning-lenora-photomechanically.ngrok-free.dev";

  Future<List<BroadcastModel>> getBroadcasts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/announcements'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      List data = body['data'];

      return data.map((e) => BroadcastModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil broadcast');
    }
  }
}
