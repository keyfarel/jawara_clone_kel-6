import 'package:flutter/material.dart';

// Import semua pages
import 'package:myapp/pages/auth/login_page.dart';
import 'package:myapp/pages/auth/register_page.dart';
import 'package:myapp/pages/home/dashboard/kegiatan_page.dart';
import 'package:myapp/pages/home/data_warga_rumah/rumah_tambah_page.dart';
import 'package:myapp/pages/home/kegiatan_broadcast/broadcast_tambah_page.dart';

// Fitur Aryan
import 'package:myapp/pages/home/dashboard/keuangan_page.dart';
import 'package:myapp/pages/home/data_warga_rumah/warga_daftar_page.dart';
import 'package:myapp/pages/home/pemasukan/tagih_iuran_page.dart';
import 'package:myapp/pages/home/laporan_keuangan/semua_pemasukan_page.dart';
import 'package:myapp/pages/home/kegiatan_broadcast/kegiatan_daftar_page.dart';
import 'package:myapp/pages/home/log_aktifitas/semua_aktifitas_page.dart';
import 'package:myapp/pages/home/manajemen_pengguna/tambah_pengguna_page.dart';

class AppRoutes {
  // Route Names
  // Auth
  static const login = '/login';
  static const register = '/register';
  
  // Dashboard
  static const kegiatan = '/kegiatan';
  static const keuangan = '/keuangan';
  
  // Warga & Rumah
  static const rumahTambah = '/rumah_tambah';
  static const wargaDaftar = '/warga_daftar';
  
  // Kegiatan & Broadcast
  static const broadcastTambah = '/broadcast_tambah';
  static const kegiatanDaftar = '/kegiatan_daftar';
  
  // Fitur Aryan Lainnya
  static const tagihIuran = '/tagih_iuran';
  static const semuaPemasukan = '/semua_pemasukan';
  static const semuaAktifitas = '/semua_aktifitas';
  static const tambahPengguna = '/tambah_pengguna';

  // Routes Map
  static final Map<String, WidgetBuilder> routes = {
    // Auth 
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    
    // Dashboard
    kegiatan: (context) => const KegiatanPage(),
    keuangan: (context) => const KeuanganPage(),
    
    // Warga & Rumah
    rumahTambah: (context) => const RumahTambahPage(),
    wargaDaftar: (context) => const WargaDaftarPage(),
    
    // Kegiatan & Broadcast
    broadcastTambah: (context) => const BroadcastTambahPage(),
    kegiatanDaftar: (context) => const KegiatanDaftarPage(),
    
    // Fitur Aryan Lainnya
    tagihIuran: (context) => const TagihIuranPage(),
    semuaPemasukan: (context) => const SemuaPemasukanPage(),
    semuaAktifitas: (context) => const SemuaAktifitasPage(),
    tambahPengguna: (context) => const TambahPenggunaPage(),
  };

  // Navigation Helper
  static void navigateTo(String pageTitle, BuildContext context) {
    switch (pageTitle) {
      // Fitur Aryan
      case "Keuangan":
        Navigator.pushNamed(context, keuangan);
        break;
      case "Warga - Daftar":
        Navigator.pushNamed(context, wargaDaftar);
        break;
      case "Tagih Iuran":
        Navigator.pushNamed(context, tagihIuran);
        break;
      case "Semua Pemasukan":
        Navigator.pushNamed(context, semuaPemasukan);
        break;
      case "Kegiatan - Daftar":
        Navigator.pushNamed(context, kegiatanDaftar);
        break;
      case "Semua Aktifitas":
        Navigator.pushNamed(context, semuaAktifitas);
        break;
      case "Tambah Pengguna":
        Navigator.pushNamed(context, tambahPengguna);
        break;

      // Routes yang sudah ada
      case "Kegiatan":
        Navigator.pushNamed(context, kegiatan);
        break;
      case "Rumah - Tambah":
        Navigator.pushNamed(context, rumahTambah);
        break;
      case "Broadcast - Tambah":
        Navigator.pushNamed(context, broadcastTambah);
        break;

      default:
        // Fallback ke halaman error atau home
        Navigator.pushNamed(context, login);
        break;
    }
  }
}