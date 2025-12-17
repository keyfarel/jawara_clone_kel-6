import 'package:flutter/material.dart';
import './navigation_map.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final List<String> children;

  MenuItem({required this.title, required this.icon, this.children = const []});
}

final List<MenuItem> appMenuItems = [
  MenuItem(
    title: "Dashboard",
    icon: Icons.dashboard,
    children: ["Dashboard", "Keuangan", "Kegiatan", "Kependudukan"],
  ),
  MenuItem(
    title: "Data Warga & Rumah",
    icon: Icons.home,
    children: [
      "Warga - Daftar",
      "Warga - Tambah",
      "Keluarga",
      "Rumah - Daftar",
      "Rumah - Tambah",
    ],
  ),
  MenuItem(
    title: "Pemasukan",
    icon: Icons.attach_money,
    children: [
      "Kategori Iuran",
      "Tagih Iuran",
      "Tagihan",
      "Pemasukan Lain - Daftar",
      "Pemasukan Lain - Tambah",
    ],
  ),
  MenuItem(
    title: "Pengeluaran",
    icon: Icons.money_off,
    children: ["Daftar", "Tambah"],
  ),
  MenuItem(
    title: "Laporan Keuangan",
    icon: Icons.bar_chart,
    children: ["Semua Pemasukan", "Semua Pengeluaran", "Cetak Laporan"],
  ),
  MenuItem(
    title: "Kegiatan & Broadcast",
    icon: Icons.campaign,
    children: [
      "Kegiatan - Daftar",
      "Kegiatan - Tambah",
      "Broadcast - Daftar",
      "Broadcast - Tambah",
    ],
  ),
  MenuItem(
    title: "Pesan Warga",
    icon: Icons.message,
    children: ["Informasi Aspirasi"],
  ),
  MenuItem(
    title: "Penerimaan Warga",
    icon: Icons.people,
    children: ["Penerimaan Warga"],
  ),
  MenuItem(
    title: "Mutasi Keluarga",
    icon: Icons.sync_alt,
    children: ["Daftar Mutasi", "Tambah Mutasi"],
  ),
  MenuItem(
    title: "Log Aktifitas",
    icon: Icons.history,
    children: ["Semua Aktifitas"],
  ),
  MenuItem(
    title: "Manajemen Pengguna",
    icon: Icons.manage_accounts,
    children: ["Daftar Pengguna", "Tambah Pengguna"],
  ),
  MenuItem(
    title: "Channel Transfer",
    icon: Icons.send,
    children: ["Daftar Channel", "Tambah Channel"],
  ),
];