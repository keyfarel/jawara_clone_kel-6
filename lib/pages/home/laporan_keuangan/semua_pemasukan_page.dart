import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class SemuaPemasukanPage extends StatelessWidget {
  const SemuaPemasukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Semua Pemasukan',
      body: Column(
        children: [
          // Filter section
          Card(
            margin: const EdgeInsets.all(16.0),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Dari Tanggal',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () {
                        // TODO: Implement date picker
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Sampai Tanggal',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () {
                        // TODO: Implement date picker
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // List pemasukan
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                elevation: 2,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(Icons.arrow_downward, color: Colors.green),
                  ),
                  title: Text(
                    'Pemasukan ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Rp ${(index + 1) * 50000}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
     
    );
  }
}