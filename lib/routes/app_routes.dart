import 'package:flutter/material.dart';

// Import semua pages
import 'package:myapp/pages/auth/login_page.dart';
import 'package:myapp/pages/auth/register_page.dart';
import 'package:myapp/pages/home/dashboard/dashboard_page.dart';
import 'package:myapp/pages/home/dashboard/kegiatan_page.dart';
import 'package:myapp/pages/home/dashboard/kependudukan_page.dart';
import 'package:myapp/pages/home/dashboard/keuangan_page.dart';
import 'package:myapp/pages/home/data_warga_rumah/keluarga_page.dart';
import 'package:myapp/pages/home/data_warga_rumah/rumah_daftar_page.dart';
import 'package:myapp/pages/home/data_warga_rumah/rumah_tambah_page.dart';
import 'package:myapp/pages/home/data_warga_rumah/warga_daftar_page.dart';
import 'package:myapp/pages/home/data_warga_rumah/warga_tambah_page.dart';
import 'package:myapp/pages/home/kegiatan_broadcast/broadcast_tambah_page.dart';
import 'package:myapp/pages/home/kegiatan_broadcast/kegiatan_daftar_page.dart';
import 'package:myapp/pages/home/kegiatan_broadcast/kegiatan_tambah_page.dart';
import 'package:myapp/pages/home/mutasi_keluarga/daftar_mutasi_page.dart';
import 'package:myapp/pages/home/pemasukan/pemasukan_lain_daftar_page.dart';
import 'package:myapp/pages/home/pemasukan/pemasukan_lain_tambah_page.dart';
import 'package:myapp/pages/home/pemasukan/tagih_iuran_page.dart';
import 'package:myapp/pages/home/pemasukan/kategori_iuran_page.dart';
import 'package:myapp/pages/home/laporan_keuangan/semua_pemasukan_page.dart';
import 'package:myapp/pages/home/laporan_keuangan/semua_pengeluaran_page.dart';
import 'package:myapp/pages/home/log_aktifitas/semua_aktifitas_page.dart';
import 'package:myapp/pages/home/manajemen_pengguna/tambah_pengguna_page.dart';
import 'package:myapp/pages/home/channel_transfer/daftar_channel_page.dart';
import 'package:myapp/pages/home/channel_transfer/tambah_channel_page.dart';
import 'package:myapp/pages/home/pemasukan/tagihan_page.dart';
import 'package:myapp/pages/home/pesan_warga/informasi_aspirasi_page.dart';
import 'package:myapp/pages/home/mutasi_keluarga/tambah_mutasi_page.dart';
import 'package:myapp/pages/home/pengeluaran/daftar_page.dart';
import 'package:myapp/pages/home/pengeluaran/tambah_page.dart';
import 'package:myapp/pages/home/kegiatan_broadcast/broadcast_daftar_page.dart';
import 'package:myapp/pages/home/laporan_keuangan/cetak_laporan_page.dart';
import 'package:myapp/pages/home/manajemen_pengguna/daftar_pengguna_page.dart';
import 'package:myapp/pages/home/penerimaan_warga/penerimaan_warga_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';

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
  static const semuaAktifitasPage = '/semua_aktifitas_page';
  static const tambahPengguna = '/tambah_pengguna';
  static const tagihan = '/tagihan';
  static const pemasukanTambah = '/pemasukan_tambah';
  static const pemasukanDaftar = '/pemasukan_daftar';

  static const daftarChannel = '/daftar_channel';
  static const tambahChannel = '/tambah_channel';
  static const informasiAspirasiPage = '/informasi_aspirasi_page';
  static const tambahMutasi = '/tambah_mutasi';
  static const daftarMutasi = '/mutasi_daftar';

  static const daftarPengeluaran = '/daftar_pengeluaran';
  static const tambahPengeluaran = '/tambah_pengeluaran';
  static const cetakLaporan = '/cetak_laporan';
  static const daftarPengguna = '/daftar_pengguna';
  static const penerimaanWarga = '/penerimaan_warga';

  static final Map<String, WidgetBuilder> routes = {
    // Auth
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),

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

    // Laporan Keuangan
    semuaPemasukan: (context) => const SemuaPemasukanPage(),
    semuaPengeluaran: (context) => const SemuaPengeluaranPage(),
    cetakLaporan: (context) => const CetakLaporanPage(),

    // Log Aktifitas
    semuaAktifitasPage: (context) => const SemuaAktifitasPage(),

    // Manajemen Pengguna
    tambahPengguna: (context) => const TambahPenggunaPage(),
    daftarPengguna: (context) => const DaftarPenggunaPage(),

    // Channel Transfer
    daftarChannel: (context) => const DaftarChannelPage(),
    tambahChannel: (context) => const TambahChannelPage(),

    // Pesan Warga
    informasiAspirasiPage: (context) => const InformasiAspirasiPage(),

    // Mutasi Keluarga
    tambahMutasi: (context) => const TambahMutasiPage(),
    daftarMutasi: (context) => const DaftarMutasiPage(),

    // Pengeluaran
    daftarPengeluaran: (context) => const PengeluaranDaftarPage(),
    tambahPengeluaran: (context) => const TambahPage(),

    // Penerimaan Warga
    penerimaanWarga: (context) => const PenerimaanWargaPage(),
  };
}
