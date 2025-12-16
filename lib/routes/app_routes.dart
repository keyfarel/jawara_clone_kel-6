import 'package:flutter/material.dart';

// =========================
// FEATURES (API CONNECTED)
// =========================

// Auth
import 'package:myapp/features/auth/presentation/pages/login_page.dart';
import 'package:myapp/features/auth/presentation/pages/register_page.dart';
import 'package:myapp/features/auth/presentation/pages/splash_page.dart';

// Dashboard
import 'package:myapp/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:myapp/features/dashboard/presentation/pages/dashboard_keuangan_page.dart';
import 'package:myapp/features/dashboard/presentation/pages/dashboard_kependudukan_page.dart';
import 'package:myapp/features/dashboard/presentation/pages/dashboard_kegiatan_page.dart';

import 'package:myapp/features/Keluarga/presentation/pages/keluarga_page.dart';

// Log Aktivitas
import 'package:myapp/features/log_aktifitas/presentation/pages/semua_aktifitas_page.dart';

// Mutasi Keluarga
import 'package:myapp/features/mutasi_keluarga/presentation/pages/daftar_mutasi_page.dart';
import 'package:myapp/features/mutasi_keluarga/presentation/pages/tambah_mutasi_page.dart';

// Channel Transfer
import 'package:myapp/features/channel_transfer/presentation/pages/daftar_channel_page.dart';
import 'package:myapp/features/channel_transfer/presentation/pages/tambah_channel_page.dart';

// Broadcast & Kegiatan
import 'package:myapp/features/kegiatan_broadcast/presentation/pages/broadcast_daftar_page.dart';
import 'package:myapp/features/kegiatan_broadcast/presentation/pages/broadcast_tambah_page.dart';
import 'package:myapp/features/kegiatan_broadcast/presentation/pages/kegiatan_daftar_page.dart';
import 'package:myapp/features/kegiatan_broadcast/presentation/pages/kegiatan_tambah_page.dart';

// Manajemen Pengguna
import 'package:myapp/features/manajemen_pengguna/presentation/pages/daftar_pengguna_page.dart';
import 'package:myapp/features/manajemen_pengguna/presentation/pages/tambah_pengguna_page.dart';

// Penerimaan Warga
import 'package:myapp/features/penerimaan_warga/presentation/pages/penerimaan_warga_page.dart';

// Data Warga & Rumah (Dynamic)
import 'package:myapp/features/data_warga_rumah/presentation/pages/rumah_daftar_page.dart';
import 'package:myapp/features/data_warga_rumah/presentation/pages/warga_daftar_page.dart';
import 'package:myapp/features/data_warga_rumah/presentation/pages/rumah_tambah_page.dart';

// laporan_keuangan
import 'package:myapp/features/laporan_keuangan/presentation/pages/cetak_laporan_page.dart';
// laporan pengeluaran
import 'package:myapp/features/pengeluaran/presentation/pengeluaran_daftar_page.dart';
import 'package:myapp/features/pengeluaran/presentation/tambah_page.dart';

// Pemsukan
import 'package:myapp/features/kategori_iuran/presentation/pages/kategori_iuran_page.dart';
import 'package:myapp/features/tagih_iuran/presentation/pages/tagih_iuran_page.dart';
import 'package:myapp/features/tagihan_list/presentation/pages/tagihan_page.dart';

// =========================
// STATIC / LEGACY PAGES
// =========================

import 'package:myapp/pages/home/data_warga_rumah/warga_tambah_page.dart';

import 'package:myapp/pages/home/pemasukan/pemasukan_lain_daftar_page.dart';
import 'package:myapp/pages/home/pemasukan/pemasukan_lain_tambah_page.dart';






import 'package:myapp/pages/home/laporan_keuangan/semua_pemasukan_page.dart';
import 'package:myapp/pages/home/laporan_keuangan/semua_pengeluaran_page.dart';

import 'package:myapp/pages/home/pesan_warga/informasi_aspirasi_page.dart';

class AppRoutes {
  // Essentials
  static const login = '/login';
  static const register = '/register';
  static const splash = '/splash';

  // Dashboard
  static const dashboard = '/dashboard';
  static const kegiatan = '/kegiatan';
  static const keuangan = '/keuangan';
  static const kependudukan = '/kependudukan';
  static const kegiatanTambah = '/kegiatan_tambah';

  // Data Warga & Rumah
  static const keluarga = '/keluarga';
  static const rumahTambah = '/rumah_tambah';
  static const wargaDaftar = '/warga_daftar';
  static const wargaTambah = '/warga_tambah';
  static const rumahDaftar = '/rumah_daftar';

  // Broadcast & Kegiatan
  static const broadcastTambah = '/broadcast_tambah';
  static const broadcastDaftar = '/broadcast_daftar';
  static const kegiatanDaftar = '/kegiatan_daftar';

  // Keuangan
  static const tagihIuran = '/tagih_iuran';
  static const kategoriIuran = '/kategori_iuran';
  static const semuaPemasukan = '/semua_pemasukan';
  static const semuaPengeluaran = '/semua_pengeluaran';
  static const tagihan = '/tagihan';
  static const pemasukanTambah = '/pemasukan_tambah';
  static const pemasukanDaftar = '/pemasukan_daftar';
  static const daftarPengeluaran = '/daftar_pengeluaran';
  static const tambahPengeluaran = '/tambah_pengeluaran';
  static const cetakLaporan = '/cetak_laporan';

  // Lainnya
  static const informasiAspirasiPage = '/informasi_aspirasi';
  static const penerimaanWarga = '/penerimaan_warga';

  // Dynamic Pages (API)
  static const semuaAktifitasPage = '/semua_aktifitas_page';
  static const daftarChannel = '/daftar_channel';
  static const tambahChannel = '/tambah_channel';
  static const daftarMutasi = '/mutasi_daftar';
  static const tambahMutasi = '/tambah_mutasi';
  static const daftarPengguna = '/daftar_pengguna';
  static const tambahPengguna = '/tambah_pengguna';

  // =========================
  // ROUTE MAP
  // =========================
  static final Map<String, WidgetBuilder> routes = {
    // Auth
    login: (_) => LoginPage(),
    register: (_) => RegisterPage(),
    splash: (_) => const SplashPage(),

    // Dashboard
    dashboard: (_) => const DashboardPage(),
    kegiatan: (_) => const KegiatanPage(),
    keuangan: (_) => const KeuanganPage(),
    kependudukan: (_) => const KependudukanPage(),

    // Data Warga & Rumah
    keluarga: (_) => const ListKeluargaPage(),
    rumahTambah: (_) => const RumahTambahPage(),
    wargaDaftar: (_) => const WargaDaftarPage(),
    wargaTambah: (_) => const TambahWargaPage(),
    rumahDaftar: (_) => const RumahDaftarPage(),

    // Kegiatan & Broadcast
    broadcastTambah: (_) => const BroadcastTambahPage(),
    broadcastDaftar: (_) => const BroadcastDaftarPage(),
    kegiatanDaftar: (_) => const KegiatanDaftarPage(),
    kegiatanTambah: (_) => const KegiatanTambahPage(),

    // Pemasukan
    tagihIuran: (_) => const TagihIuranPage(),
    kategoriIuran: (_) => const KategoriIuranPage(),
    tagihan: (_) => const TagihanDaftarPage(),
    pemasukanTambah: (_) => const PemasukanLainTambahPage(),
    pemasukanDaftar: (_) => const PemasukanLainDaftarPage(),

    // Pengeluaran
    daftarPengeluaran: (_) => const PengeluaranDaftarPage(),
    tambahPengeluaran: (_) => const TambahPage(),

    // Laporan
    semuaPemasukan: (_) => const SemuaPemasukanPage(),
    semuaPengeluaran: (_) => const SemuaPengeluaranPage(),
    cetakLaporan: (_) => const CetakLaporanPage(),

    // Pesan Warga
    informasiAspirasiPage: (_) => const InformasiAspirasiPage(),
    penerimaanWarga: (_) => const PenerimaanWargaPage(),

    // Dynamic API Pages
    semuaAktifitasPage: (_) => const SemuaAktifitasPage(),
    daftarPengguna: (_) => const DaftarPenggunaPage(),
    tambahPengguna: (_) => const TambahPenggunaPage(),
    daftarChannel: (_) => const DaftarChannelPage(),
    tambahChannel: (_) => const TambahChannelPage(),
    daftarMutasi: (_) => const DaftarMutasiPage(),
    tambahMutasi: (_) => const TambahMutasiPage(),
  };
}