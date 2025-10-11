import 'package:flutter/material.dart';

class NavItem {
  final String title;
  final IconData? icon;
  final List<String>? children;

  const NavItem({
    required this.title,
    this.icon,
    this.children,
  });
}
