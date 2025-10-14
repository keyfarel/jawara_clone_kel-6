// TODO: Implement broadcast_daftar_page.dart
import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class BroadcastDaftarPage extends StatelessWidget {
  const BroadcastDaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Broadcast Daftar',
      body: const Center(
        child: Text(
          'Ini adalah page broadcast daftar',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}