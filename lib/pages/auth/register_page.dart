import 'package:flutter/material.dart';
import 'widgets/register/register_header.dart';
import 'widgets/register/register_form_section.dart';
import 'widgets/register/register_submit_section.dart';
import 'widgets/register/register_login_redirect.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              RegisterHeader(),
              RegisterFormSection(),
              SizedBox(height: 24),
              RegisterSubmitSection(),
              RegisterLoginRedirect(),
            ],
          ),
        ),
      ),
    );
  }
}
