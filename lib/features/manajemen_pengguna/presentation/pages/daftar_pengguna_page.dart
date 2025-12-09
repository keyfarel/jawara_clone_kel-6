import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../layouts/pages_layout.dart';
import '../../controllers/user_controller.dart';
import '../../data/models/user_model.dart';

class DaftarPenggunaPage extends StatefulWidget {
  const DaftarPenggunaPage({super.key});

  @override
  State<DaftarPenggunaPage> createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends State<DaftarPenggunaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UserController>();
    final users = controller.users;

    return PageLayout(
      title: "Daftar Pengguna",
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman Tambah Pengguna (Nanti)
          Navigator.pushNamed(context, '/tambah_pengguna');
        },
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: controller.loadUsers,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _buildUserCard(user, context);
                },
              ),
            ),
    );
  }

  Widget _buildUserCard(UserModel user, BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildRoleBadge(user.role),
                const SizedBox(width: 8),
                Text(
                  user.phone,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            )
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'detail') _showDetailDialog(user);
            if (value == 'edit') _showEditDialog(user);
            if (value == 'delete') _confirmDelete(user);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'detail',
              child: Row(
                children: [Icon(Icons.info_outline, color: Colors.blue), SizedBox(width: 8), Text('Detail')],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [Icon(Icons.edit, color: Colors.orange), SizedBox(width: 8), Text('Edit')],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text('Hapus')],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color color = Colors.grey;
    if (role == 'admin') color = Colors.red;
    if (role == 'resident' || role == 'citizen') color = Colors.green;
    if (role == 'secretary') color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  // --- DIALOGS ---

  void _showDetailDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Detail: ${user.name}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow("Email", user.email),
            _detailRow("No. HP", user.phone),
            _detailRow("Role", user.role),
            _detailRow("Status", user.registrationStatus),
            _detailRow("Bergabung", user.createdAt ?? '-'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup")),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showEditDialog(UserModel user) {
    final nameCtrl = TextEditingController(text: user.name);
    final emailCtrl = TextEditingController(text: user.email);
    final phoneCtrl = TextEditingController(text: user.phone);
    final passCtrl = TextEditingController();
    String selectedRole = user.role;

    final roles = ['resident', 'admin', 'secretary', 'treasurer'];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Edit Pengguna"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nama")),
                    TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
                    TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "No. HP")),
                    DropdownButtonFormField<String>(
                      value: roles.contains(selectedRole) ? selectedRole : roles.first,
                      items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (val) => setState(() => selectedRole = val!),
                      decoration: const InputDecoration(labelText: "Role"),
                    ),
                    TextField(
                      controller: passCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password Baru (Opsional)",
                        helperText: "Kosongkan jika tidak ingin mengganti",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context); // Tutup dialog dulu
                    final success = await context.read<UserController>().updateUser(
                      user.id,
                      nameCtrl.text,
                      emailCtrl.text,
                      phoneCtrl.text,
                      selectedRole,
                      passCtrl.text,
                    );

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil update data")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(context.read<UserController>().errorMessage ?? "Gagal update"),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  child: const Text("Simpan"),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _confirmDelete(UserModel user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: Text("Yakin ingin menghapus pengguna ${user.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context.read<UserController>().deleteUser(user.id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pengguna dihapus")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(context.read<UserController>().errorMessage ?? "Gagal menghapus"),
                  backgroundColor: Colors.red,
                ));
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}