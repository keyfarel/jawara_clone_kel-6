import 'package:flutter/material.dart';
import 'widgets/side_nav_widget.dart';

class PageLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions; // bisa tambah tombol di AppBar
  final Widget? floatingActionButton;

  const PageLayout({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNavWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 2,
        actions: actions,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}