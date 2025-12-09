import 'package:flutter/material.dart';

// ==========================================
// 1. FEATURES (DYNAMIC / CONNECTED TO API)
// ==========================================

// Auth
import 'package:myapp/features/auth/presentation/pages/login_page.dart';
import 'package:myapp/features/auth/presentation/pages/register_page.dart';
import 'package:myapp/features/auth/presentation/pages/splash_page.dart';

// Log Aktifitas
import 'package:myapp/features/log_aktifitas/presentation/pages/semua_aktifitas_page.dart';

// Mutasi Keluarga
import 'package:myapp/features/mutasi_keluarga/presentation/pages/daftar_mutasi_page.dart';
import 'package:myapp/features/mutasi_keluarga/presentation/pages/tambah_mutasi_page.dart';

// Channel Transfer
import 'package:myapp/features/channel_transfer/presentation/pages/daftar_channel_page.dart';
import 'package:myapp/features/channel_transfer/presentation/pages/tambah_channel_page.dart';

import 'package:myapp/features/kegiatan_broadcast/presentation/pages/broadcast_daftar_page.dart';
import 'package:myapp/features/kegiatan_broadcast/presentation/pages/broadcast_tambah_page.dart';
// Manajemen Pengguna
import 'package:myapp/features/manajemen_pengguna/presentation/pages/daftar_pengguna_page.dart';
import 'package:myapp/features/manajemen_pengguna/presentation/pages/tambah_pengguna_page.dart'; 

// penerimaan warga
import 'package:myapp/features/penerimaan_warga/presentation/pages/penerimaan_warga_page.dart';


// dashboard
import 'package:myapp/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:myapp/features/dashboard/presentation/pages/dashboard_keuangan_page.dart';
import 'package:myapp/features/dashboard/presentation/pages/dashboard_kependudukan_page.dart';
import 'package:myapp/features/dashboard/presentation/pages/dashboard_kegiatan_page.dart';

// ==========================================
// 2. PAGES (STATIC / LEGACY / DASHBOARD)
// ==========================================

// Data Warga & Rumah
import 'package:myapp/pages/home/data_warga_rumah/keluarga_page.dart';
import 'package:myapp/pages/home/data_warga_rumah/rumah_daftar_page.dart';
import 'package:myapp/pages/home/data_warga_rumah/rumah_tambah_page.dart';
import 'package:myapp/pages/home/data_warga_rumah/warga_daftar_page.dart';
import 'package:myapp/pages/home/data_warga_rumah/warga_tambah_page.dart';

// Kegiatan & Broadcast
import 'package:myapp/pages/home/kegiatan_broadcast/kegiatan_daftar_page.dart';
import 'package:myapp/pages/home/kegiatan_broadcast/kegiatan_tambah_page.dart';

// Pemasukan & Pengeluaran
import 'package:myapp/pages/home/pemasukan/pemasukan_lain_daftar_page.dart';
import 'package:myapp/pages/home/pemasukan/pemasukan_lain_tambah_page.dart';
import 'package:myapp/pages/home/pemasukan/tagih_iuran_page.dart';
import 'package:myapp/pages/home/pemasukan/kategori_iuran_page.dart';
import 'package:myapp/pages/home/pemasukan/tagihan_page.dart';
import 'package:myapp/pages/home/pengeluaran/daftar_page.dart';
import 'package:myapp/pages/home/pengeluaran/tambah_page.dart';

// Laporan
import 'package:myapp/pages/home/laporan_keuangan/semua_pemasukan_page.dart';
import 'package:myapp/pages/home/laporan_keuangan/semua_pengeluaran_page.dart';
import 'package:myapp/pages/home/laporan_keuangan/cetak_laporan_page.dart';

// Lainnya
import 'package:myapp/pages/home/pesan_warga/informasi_aspirasi_page.dart';

class AppRoutes {
  // --- Constants ---
  static const login = '/login';
  static const register = '/register';
  static const splash = '/splash';

  static const dashboard = '/dashboard';
  static const kegiatan = '/kegiatan';
  static const keuangan = '/keuangan';
  static const kependudukan = '/kependudukan';
  static const kegiatanTambah = '/kegiatan_tambah';

  static const keluarga = '/keluarga';
  static const rumahTambah = '/rumah_tambah';
  static const wargaDaftar = '/warga_daftar';
  static const wargaTambah = '/warga_tambah';
  static const rumahDaftar = '/rumah-daftar';

  static const broadcastTambah = '/broadcast_tambah';
  static const broadcastDaftar = '/broadcast_daftar';
  static const kegiatanDaftar = '/kegiatan_daftar';

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
  
  static const informasiAspirasiPage = '/informasi_aspirasi';
  static const penerimaanWarga = '/penerimaan_warga';

  // --- UPDATED ROUTES (DYNAMIC) ---
  static const semuaAktifitasPage = '/semua_aktifitas_page';
  
  static const daftarChannel = '/daftar_channel';
  static const tambahChannel = '/tambah_channel';
  
  static const daftarMutasi = '/mutasi_daftar';
  static const tambahMutasi = '/tambah_mutasi';
  
  static const daftarPengguna = '/daftar_pengguna';
  static const tambahPengguna = '/tambah_pengguna';


  // --- ROUTE MAP ---
  static final Map<String, WidgetBuilder> routes = {
    // Auth
    login: (context) => LoginPage(),
    register: (context) => RegisterPage(),
    splash: (context) => const SplashPage(),

    // Dashboard
    dashboard: (context) => const DashboardPage(),
    kegiatan: (context) => const KegiatanPage(),
    keuangan: (context) => const KeuanganPage(),
    kependudukan: (context) => const KependudukanPage(),

    // Data Warga & Rumah
    keluarga: (context) => const KeluargaDaftarPage(),
    rumahTambah: (context) => const RumahTambahPage(),
    wargaDaftar: (context) => const WargaDaftarPage(),
    wargaTambah: (context) => const TambahWargaPage(),
    rumahDaftar: (context) => const RumahDaftarPage(),

    // Kegiatan & Broadcast
    broadcastTambah: (context) => const BroadcastTambahPage(),
    broadcastDaftar: (context) => const BroadcastDaftarPage(),
    kegiatanDaftar: (context) => const KegiatanDaftarPage(),
    kegiatanTambah: (context) => const KegiatanTambahPage(),

    // Pemasukan
    tagihIuran: (context) => const TagihIuranPage(),
    kategoriIuran: (context) => const KategoriIuranPage(),
    tagihan: (context) => const TagihanDaftarPage(),
    pemasukanTambah: (context) => const PemasukanLainTambahPage(),
    pemasukanDaftar: (context) => const PemasukanLainDaftarPage(),

    // Pengeluaran
    daftarPengeluaran: (context) => const PengeluaranDaftarPage(),
    tambahPengeluaran: (context) => const TambahPage(),

    // Laporan Keuangan
    semuaPemasukan: (context) => const SemuaPemasukanPage(),
    semuaPengeluaran: (context) => const SemuaPengeluaranPage(),
    cetakLaporan: (context) => const CetakLaporanPage(),

    // Pesan Warga
    informasiAspirasiPage: (context) => const InformasiAspirasiPage(),
    penerimaanWarga: (context) => const PenerimaanWargaPage(),

    // --- DYNAMIC FEATURES ROUTES ---
    
    // Log Aktifitas
    semuaAktifitasPage: (context) => const SemuaAktifitasPage(),

    // Manajemen Pengguna
    daftarPengguna: (context) => const DaftarPenggunaPage(), // NEW: Dynamic List
    tambahPengguna: (context) => const TambahPenggunaPage(), // Old/Placeholder

    // Channel Transfer
    daftarChannel: (context) => const DaftarChannelPage(), // NEW: Dynamic List
    tambahChannel: (context) => const TambahChannelPage(), // NEW: Dynamic Form

    // Mutasi Keluarga
    daftarMutasi: (context) => const DaftarMutasiPage(), // NEW: Dynamic List
    tambahMutasi: (context) => const TambahMutasiPage(), // NEW: Dynamic Form
  };
}