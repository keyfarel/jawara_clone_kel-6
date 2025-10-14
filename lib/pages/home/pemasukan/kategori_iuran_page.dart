import 'package:flutter/material.dart';

class KategoriIuranPage extends StatelessWidget {
  const KategoriIuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dataIuran = [
      {"no": "1", "nama": "Mingguan", "jenis": "Iuran Khusus"},
      {"no": "2", "nama": "agustusan", "jenis": "Iuran Khusus"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Iuran'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF5F7FB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card Info
            Card(
              color: const Color(0xFFE8F0FE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Info:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Iuran Bulanan: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "Dibayar setiap bulan sekali secara rutin.\n",
                          ),
                          TextSpan(
                            text: "Iuran Khusus: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "Dibayar sesuai jadwal atau kebutuhan tertentu, misalnya iuran untuk acara khusus, renovasi, atau kegiatan lain yang tidak rutin.",
                          ),
                        ],
                      ),
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol tambah & filter
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (context) => const IuranFormModal(),
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {},
                  child: const Icon(Icons.filter_list, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tabel Data
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Table(
                border: TableBorder(
                  horizontalInside:
                      BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                columnWidths: const {
                  0: FixedColumnWidth(40),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                },
                children: [
                  // Header
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "NO",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "NAMA IURAN",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "JENIS IURAN",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  // Data
                  for (var iuran in dataIuran)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(iuran['no']!),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(iuran['nama']!),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(iuran['jenis']!),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// MODAL FORM IURAN BARU
// =====================================================================

class IuranFormModal extends StatefulWidget {
  const IuranFormModal({super.key});

  @override
  State<IuranFormModal> createState() => _IuranFormModalState();
}

class _IuranFormModalState extends State<IuranFormModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  String? _selectedKategori;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Buat Iuran Baru',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Masukkan data iuran baru dengan lengkap.',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 20),

              // Nama Iuran
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Iuran',
                  hintText: 'Masukkan nama iuran',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Nama iuran wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Jumlah
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Jumlah wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Kategori Iuran
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori Iuran',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Iuran Bulanan',
                    child: Text('Iuran Bulanan'),
                  ),
                  DropdownMenuItem(
                    value: 'Iuran Khusus',
                    child: Text('Iuran Khusus'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedKategori = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih kategori iuran' : null,
              ),
              const SizedBox(height: 20),

              // Tombol Aksi
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Simpan logika data di sini
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data iuran berhasil disimpan!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    child: const Text('Simpan'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}