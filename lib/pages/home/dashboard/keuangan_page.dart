import 'package:flutter/material.dart';

class KeuanganPage extends StatelessWidget {
  const KeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Keuangan')),
      body: Column(
        children: [
          // Card ringkasan keuangan
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoCard(
                    'Total Pemasukan',
                    'Rp 5.000.000',
                    Colors.green,
                  ),
                  _buildInfoCard(
                    'Total Pengeluaran',
                    'Rp 3.200.000',
                    Colors.red,
                  ),
                  _buildInfoCard('Saldo', 'Rp 1.800.000', Colors.blue),
                ],
              ),
            ),
          ),
          // Grafik atau list transaksi terbaru
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.money),
                title: Text('Transaksi ${index + 1}'),
                subtitle: Text('Rp ${(index + 1) * 100000}'),
                trailing: Text(DateTime.now().toString()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
