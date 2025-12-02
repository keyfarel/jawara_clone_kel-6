import '../models/channel_model.dart';
import '../services/channel_service.dart';
import 'package:image_picker/image_picker.dart';

class ChannelRepository {
  final ChannelService service;

  ChannelRepository(this.service);

  Future<List<ChannelModel>> fetchChannels() async {
    return await service.getChannels();
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
    return await service.createChannel(
      name: name,
      type: type,
      accountNumber: accountNumber,
      accountName: accountName,
      notes: notes,
      thumbnail: thumbnail,
      qrCode: qrCode,
    );
  }
}