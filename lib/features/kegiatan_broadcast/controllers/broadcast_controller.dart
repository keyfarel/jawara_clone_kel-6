import 'package:flutter/material.dart';
import '../data/models/broadcast_model.dart';
import '../data/repository/broadcast_repository.dart';

class BroadcastController extends ChangeNotifier {
  final BroadcastRepository repo;

  BroadcastController(this.repo);

  List<BroadcastModel> broadcasts = [];
  bool isLoading = false;

  Future<void> loadBroadcasts() async {
    try {
      isLoading = true;
      notifyListeners();

      broadcasts = await repo.getAllBroadcast();

    } catch (e) {
      debugPrint("Error Broadcast: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
