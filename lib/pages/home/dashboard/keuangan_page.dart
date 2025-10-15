import 'package:flutter/material.dart';
import '../../../layouts/pages_layout.dart';

class KeuanganPage extends StatelessWidget {
  const KeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Dashboard Keuangan',
      body: Column(
        children: [
          // Card ringkasan keuangan
          Card(
            margin: const EdgeInsets.all(16.0),
            elevation: 4,
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
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              elevation: 4,
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.money, color: Colors.blue),
                  title: Text('Transaksi ${index + 1}'),
                  subtitle: Text('Rp ${(index + 1) * 100000}'),
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

  Widget _buildInfoCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title, 
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
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