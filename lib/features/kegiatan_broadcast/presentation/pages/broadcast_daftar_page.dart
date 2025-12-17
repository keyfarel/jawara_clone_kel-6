import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/layouts/pages_layout.dart';
import '../../../../features/kegiatan_broadcast/controllers/broadcast_controller.dart';

class BroadcastDaftarPage extends StatefulWidget {
  const BroadcastDaftarPage({super.key});

  @override
  State<BroadcastDaftarPage> createState() => _BroadcastDaftarPageState();
}

class _BroadcastDaftarPageState extends State<BroadcastDaftarPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BroadcastController>().loadBroadcasts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BroadcastController>();

    return PageLayout(
      title: "Daftar Broadcast",
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.broadcasts.isEmpty
                ? const Center(child: Text("Belum ada broadcast"))
                : ListView.builder(
                    itemCount: controller.broadcasts.length,
                    itemBuilder: (context, index) {
                      final br = controller.broadcasts[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(br.id.toString()),
                          ),
                          title: Text(br.title),
                          subtitle: Text(
                            "Pengirim: ${br.senderName}\n${br.createdAt}",
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
