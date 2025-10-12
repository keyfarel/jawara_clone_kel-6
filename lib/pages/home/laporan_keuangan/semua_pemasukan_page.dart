import 'package:flutter/material.dart';

class SemuaPemasukanPage extends StatelessWidget {
  const SemuaPemasukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semua Pemasukan')),
      body: Column(
        children: [
          // Filter section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Dari Tanggal',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Sampai Tanggal',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List pemasukan
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  leading: const Icon(Icons.arrow_downward, color: Colors.green),
                  title: Text('Pemasukan ${index + 1}'),
                  subtitle: Text('Rp ${(index + 1) * 50000}'),
                  trailing: Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}