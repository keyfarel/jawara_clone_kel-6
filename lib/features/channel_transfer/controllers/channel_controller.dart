import 'package:flutter/material.dart';
import '../data/models/channel_model.dart';
import '../data/repository/channel_repository.dart';
import 'package:image_picker/image_picker.dart';

class ChannelController extends ChangeNotifier {
  final ChannelRepository repository;

  ChannelController(this.repository);

  List<ChannelModel> _channels = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ChannelModel> get channels => _channels;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadChannels() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchChannels();
      _channels = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addChannel({
    required String name,
    required String type,
    required String accountNumber,
    required String accountName,
    String? notes,
    XFile? thumbnail,
    XFile? qrCode,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await repository.createChannel(
        name: name,
        type: type,
        accountNumber: accountNumber,
        accountName: accountName,
        notes: notes,
        thumbnail: thumbnail,
        qrCode: qrCode,
      );
      
      // Jika sukses, reload list agar data baru muncul
      await loadChannels(); 
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}