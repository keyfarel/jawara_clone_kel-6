// file: home_page.dart
import 'package:flutter/material.dart';
import '../../layouts/pages_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Dashboard',
      body: const Center(
        child: Text(
          'Ini adalah konten utama',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
