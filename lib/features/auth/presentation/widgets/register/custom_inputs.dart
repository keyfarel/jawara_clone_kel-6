import 'package:flutter/material.dart';

// 1. DEKORASI UMUM (Style)
InputDecoration modernInputDecoration(
  String hint,
  IconData icon,
  Color color, {
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
    prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 22),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Colors.grey.shade50,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade200),
    ),
  );
}

// 2. TEXT FIELD BIASA
class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final Color primaryColor;
  final FocusNode? focusNode; // Opsional: Support FocusNode jika nanti butuh

  const ModernTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.primaryColor,
    this.inputType = TextInputType.text,
    this.validator,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: inputType,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: modernInputDecoration(hint, icon, primaryColor),
    );
  }
}

// 3. DROPDOWN
class ModernDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final IconData icon;
  final List<String> items;
  final Function(String?) onChanged;
  final Color primaryColor;

  const ModernDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      decoration: modernInputDecoration(hint, icon, primaryColor),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 15)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? "$hint wajib dipilih" : null,
    );
  }
}

// 4. PASSWORD FIELD (Menangani Hide/Show sendiri)
class ModernPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Color primaryColor;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const ModernPasswordField({
    super.key,
    required this.controller,
    required this.hint,
    required this.primaryColor,
    this.validator,
    this.focusNode,
  });

  @override
  State<ModernPasswordField> createState() => _ModernPasswordFieldState();
}

class _ModernPasswordFieldState extends State<ModernPasswordField> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _isHidden,
      validator: widget.validator,
      style: const TextStyle(fontSize: 15),
      decoration: modernInputDecoration(
        widget.hint,
        widget.hint.contains("Ulangi") ? Icons.lock_reset_outlined : Icons.lock_outline,
        widget.primaryColor,
        suffixIcon: IconButton(
          icon: Icon(
            _isHidden ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () => setState(() => _isHidden = !_isHidden),
        ),
      ),
    );
  }
}