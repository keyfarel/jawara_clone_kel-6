import 'package:flutter/material.dart';
import '../models/nav_item.dart';

const List<NavItem> menuItems = [
  NavItem(
    title: "Dashboard",
    icon: Icons.dashboard,
    children: ["Keuangan", "Kegiatan", "Kependudukan"],
  ),
  NavItem(
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
  NavItem(
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
  NavItem(
    title: "Pengeluaran",
    icon: Icons.money_off,
    children: ["Daftar", "Tambah"],
  ),
  NavItem(
    title: "Laporan Keuangan",
    icon: Icons.bar_chart,
    children: ["Semua Pemasukan", "Semua Pengeluaran", "Cetak Laporan"],
  ),
  NavItem(
    title: "Kegiatan & Broadcast",
    icon: Icons.campaign,
    children: [
      "Kegiatan - Daftar",
      "Kegiatan - Tambah",
      "Broadcast - Daftar",
      "Broadcast - Tambah",
    ],
  ),
  NavItem(
    title: "Pesan Warga",
    icon: Icons.message,
    children: ["Informasi Aspirasi"],
  ),
  NavItem(
    title: "Penerimaan Warga",
    icon: Icons.people,
    children: ["Penerimaan Warga"],
  ),
  NavItem(
    title: "Mutasi Keluarga",
    icon: Icons.sync_alt,
    children: ["Daftar", "Tambah"],
  ),
  NavItem(
    title: "Log Aktifitas",
    icon: Icons.history,
    children: ["Semua Aktifitas"],
  ),
  NavItem(
    title: "Manajemen Pengguna",
    icon: Icons.manage_accounts,
    children: ["Daftar Pengguna", "Tambah Pengguna"],
  ),
  NavItem(
    title: "Channel Transfer",
    icon: Icons.send,
    children: ["Daftar Channel", "Tambah Channel"],
  ),
];
