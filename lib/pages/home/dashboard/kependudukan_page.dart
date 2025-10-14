import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class KependudukanPage extends StatelessWidget {
  const KependudukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Kependudukan',
      body: const Center(
        child: Text(
          'Ini adalah page kependukan',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// TODO: Implement kependudukan_page.dart