import 'package:flutter/material.dart';
import 'widgets/login/login_header.dart';
import 'widgets/login/login_form_section.dart';
import 'widgets/login/login_action_section.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoginHeader(),
              LoginFormSection(),
              LoginActionSection(),
            ],
          ),
        ),
      ),
    );
  }
}
