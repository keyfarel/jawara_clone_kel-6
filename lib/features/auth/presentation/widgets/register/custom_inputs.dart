import 'package:flutter/material.dart';

// --- 1. MODERN TEXT FIELD (Updated) ---
class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color primaryColor;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  
  // TAMBAHAN PARAMETER BARU
  final bool readOnly;
  final VoidCallback? onTap;

  const ModernTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.primaryColor,
    this.inputType = TextInputType.text,
    this.validator,
    this.focusNode,
    // Default false agar textfield biasa tetap bisa diketik
    this.readOnly = false, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: inputType,
      validator: validator,
      // Pass parameter baru ke sini
      readOnly: readOnly,
      onTap: onTap,
      
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: modernInputDecoration(hint, icon, primaryColor),
    );
  }
}

// --- 2. MODERN PASSWORD FIELD ---
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
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      validator: widget.validator,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: modernInputDecoration(
        widget.hint,
        Icons.lock_outline,
        widget.primaryColor,
      ).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

// --- 3. MODERN DROPDOWN ---
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
      icon: const Icon(Icons.keyboard_arrow_down),
      isExpanded: true,
      decoration: modernInputDecoration(hint, icon, primaryColor),
      hint: Text(hint, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? "$hint wajib dipilih" : null,
    );
  }
}

// --- 4. DECORATION HELPER ---
InputDecoration modernInputDecoration(String hint, IconData icon, Color primaryColor) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 22),
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
    filled: true,
    fillColor: Colors.grey.shade50,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
  );
}