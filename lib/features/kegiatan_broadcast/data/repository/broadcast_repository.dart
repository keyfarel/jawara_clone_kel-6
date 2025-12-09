import 'dart:typed_data';
import '../models/broadcast_model.dart';
import '../services/broadcast_service.dart';

class BroadcastRepository {
  final BroadcastService service;
  BroadcastRepository(this.service);

  Future<List<BroadcastModel>> getAllBroadcast() {
    return service.getBroadcasts();
  }

  Future<bool> createBroadcast({
    required String title,
    required String content,
    String? imagePath,
    String? documentPath,
    Uint8List? imageBytes,
    Uint8List? documentBytes,
    String? imageName,
    String? documentName,
  }) {
    return service.createBroadcast(
      title: title,
      content: content,
      imagePath: imagePath,
      documentPath: documentPath,
      imageBytes: imageBytes,
      documentBytes: documentBytes,
      imageName: imageName,
      documentName: documentName,
    );
  }
}
