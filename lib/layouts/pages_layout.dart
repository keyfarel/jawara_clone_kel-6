import 'package:flutter/material.dart';
import 'widgets/side_nav_widget.dart';

class PageLayout extends StatelessWidget {
  final String title;
  final Widget body;

  const PageLayout({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNavWidget(),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue.shade700,
      ),
      body: body,
    );
  }
}
