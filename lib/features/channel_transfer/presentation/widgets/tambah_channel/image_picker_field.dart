import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerField extends StatelessWidget {
  final String label;
  final XFile? file;
  final VoidCallback onTap;

  const ImagePickerField({
    super.key,
    required this.label,
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.image, color: Colors.grey.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                file != null ? file!.name : label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: file != null ? Colors.black87 : Colors.grey.shade600,
                ),
              ),
            ),
            if (file != null)
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }
}
