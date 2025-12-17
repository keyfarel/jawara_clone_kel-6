import 'package:flutter/material.dart';

// --- AUTH & DASHBOARD ---
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_keuangan_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_kependudukan_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_kegiatan_page.dart';

// --- DATA WARGA & RUMAH ---
import '../../features/data_warga_rumah/presentation/pages/rumah_daftar_page.dart';
import '../../features/data_warga_rumah/presentation/pages/warga_daftar_page.dart';
import '../../features/data_warga_rumah/presentation/pages/rumah_tambah_page.dart';
import '../../features/data_warga_rumah/presentation/pages/warga_tambah_page.dart';
import '../../features/data_warga_rumah/presentation/pages/keluarga_page.dart';

// --- KEUANGAN (Laporan, Pemasukan, Pengeluaran, Tagihan) ---
import '../../features/laporan_keuangan/presentation/pages/semua_pemasukan_page.dart';
import '../../features/laporan_keuangan/presentation/pages/cetak_laporan_page.dart';
import '../../features/laporan_keuangan/presentation/pages/semua_pengeluaran_page.dart';
import '../../features/list_pengeluaran/presentation/pages/daftar_page.dart';
import '../../features/tambah_pengeluaran/presentation/pages/TambahPage.dart';
import '../../features/kategori_iuran/presentation/pages/kategori_iuran_page.dart';
import '../../features/tagih_iuran/presentation/pages/tagih_iuran_page.dart';
import '../../features/tagihan_list/presentation/pages/tagihan_page.dart';
import '../../features/list_pemasukan/presentation/pages/pemasukan_lain_daftar_page.dart';
import '../../features/tambah_pemasukan/presentation/pages/pemasukan_lain_tambah_page.dart';

// --- KEGIATAN & BROADCAST ---
import '../../features/kegiatan_broadcast/presentation/pages/broadcast_daftar_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/broadcast_tambah_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/kegiatan_daftar_page.dart';
import '../../features/kegiatan_broadcast/presentation/pages/kegiatan_tambah_page.dart';

// --- FITUR LAINNYA ---
import '../../features/log_aktifitas/presentation/pages/semua_aktifitas_page.dart';
import '../../features/mutasi_keluarga/presentation/pages/daftar_mutasi_page.dart';
import '../../features/mutasi_keluarga/presentation/pages/tambah_mutasi_page.dart';
import '../../features/channel_transfer/presentation/pages/daftar_channel_page.dart';
import '../../features/channel_transfer/presentation/pages/tambah_channel_page.dart';
import '../../features/manajemen_pengguna/presentation/pages/daftar_pengguna_page.dart';
import '../../features/manajemen_pengguna/presentation/pages/tambah_pengguna_page.dart';
import '../../features/penerimaan_warga/presentation/pages/penerimaan_warga_page.dart';
import '../../features/informasi_aspirasi/presentation/pages/informasi_aspirasi_page.dart';

class AppRoutes {
  // Hanya simpan route UTAMA yang sering dipanggil lewat konstanta (Opsional)
  static const splash = '/splash';
  static const login = '/login';
  static const dashboard = '/dashboard';

  static final Map<String, WidgetBuilder> routes = {
    // Auth
    splash: (_) => const SplashPage(),
    login: (_) => LoginPage(),
    '/register': (_) => RegisterPage(),

    // Dashboard
    dashboard: (_) => const DashboardPage(),
    '/kegiatan': (_) => const KegiatanPage(), 
    '/keuangan': (_) => const KeuanganPage(), 
    '/kependudukan': (_) => const KependudukanPage(),
    // Data Warga & Rumah
    '/keluarga': (_) => const KeluargaDaftarPage(),
    '/rumah_tambah': (_) => const RumahTambahPage(),
    '/warga_daftar': (_) => const WargaDaftarPage(),
    '/warga_tambah': (_) => const TambahWargaPage(),
    '/rumah_daftar': (_) => const RumahDaftarPage(),

    // Kegiatan & Broadcast
    '/broadcast_tambah': (_) => const BroadcastTambahPage(),
    '/broadcast_daftar': (_) => const BroadcastDaftarPage(),
    '/kegiatan_daftar': (_) => const KegiatanDaftarPage(),
    '/kegiatan_tambah': (_) => const KegiatanTambahPage(),

    // Keuangan
    '/tagih_iuran': (_) => const TagihIuranPage(),
    '/kategori_iuran': (_) => const KategoriIuranPage(),
    '/tagihan': (_) => const TagihanDaftarPage(),
    '/pemasukan_tambah': (_) => const PemasukanLainTambahPage(),
    '/pemasukan_daftar': (_) => const PemasukanLainDaftarPage(),
    '/daftar_pengeluaran': (_) => const PengeluaranDaftarPage(),
    '/tambah_pengeluaran': (_) => const TambahPage(),
    
    // Laporan
    '/semua_pemasukan': (_) => const SemuaPemasukanPage(),
    '/semua_pengeluaran': (_) => const SemuaPengeluaranPage(),
    '/cetak_laporan': (_) => const CetakLaporanPage(),

    // Lainnya
    '/informasi_aspirasi': (_) => const InformasiAspirasiPage(),
    '/penerimaan_warga': (_) => const PenerimaanWargaPage(),
    '/semua_aktifitas_page': (_) => const SemuaAktifitasPage(),
    '/daftar_pengguna': (_) => const DaftarPenggunaPage(),
    '/tambah_pengguna': (_) => const TambahPenggunaPage(),
    '/daftar_channel': (_) => const DaftarChannelPage(),
    '/tambah_channel': (_) => const TambahChannelPage(),
    '/mutasi_daftar': (_) => const DaftarMutasiPage(),
    '/tambah_mutasi': (_) => const TambahMutasiPage(),
  };
}