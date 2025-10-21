import 'package:flutter/material.dart';

class AspirasiFilterDialog extends StatefulWidget {
  final String? selectedStatus;
  const AspirasiFilterDialog({super.key, this.selectedStatus});

  @override
  State<AspirasiFilterDialog> createState() => _AspirasiFilterDialogState();
}

class _AspirasiFilterDialogState extends State<AspirasiFilterDialog> {
  String? tempStatus;
  final List<String> statusOptions = ["Pending", "Diproses", "Selesai"];

  @override
  void initState() {
    super.initState();
    tempStatus = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Filter Aspirasi"),
      content: DropdownButtonFormField<String>(
        value: tempStatus,
        items: statusOptions
            .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
            .toList(),
        onChanged: (val) => setState(() => tempStatus = val),
        decoration: const InputDecoration(
          labelText: "Pilih Status",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text("Reset"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(context, tempStatus),
          child: const Text("Terapkan"),
        ),
      ],
    );
  }
}
