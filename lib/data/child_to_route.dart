import '../routes/app_routes.dart';

final Map<String, String> childToRoute = {
  // Dashboard
  "Keuangan": AppRoutes.keuangan,
  "Kegiatan": AppRoutes.kegiatan,
  // "Kependudukan": belum ada route

  // Data Warga & Rumah
  "Warga - Daftar": AppRoutes.wargaDaftar,
  // "Warga - Tambah": belum ada route
  // "Keluarga": belum ada route
  // "Rumah - Daftar": belum ada route
  "Rumah - Tambah": AppRoutes.rumahTambah,

  // Pemasukan
  "Kategori Iuran": AppRoutes.kategoriIuran,
  "Tagih Iuran": AppRoutes.tagihIuran,
  // "Tagihan": belum ada route
  // "Pemasukan Lain - Daftar": belum ada route
  // "Pemasukan Lain - Tambah": belum ada route

  // Pengeluaran
  // "Daftar": belum ada route
  "Tambah": AppRoutes.tambahPengeluaran,

  // Laporan Keuangan
  "Semua Pemasukan": AppRoutes.semuaPemasukan,
  // "Semua Pengeluaran": belum ada route
  "Cetak Laporan": AppRoutes.cetakLaporan,

  // Kegiatan & Broadcast
  "Kegiatan - Daftar": AppRoutes.kegiatanDaftar,
  // "Kegiatan - Tambah": belum ada route
  "Broadcast - Daftar": AppRoutes.broadcastDaftar,
  "Broadcast - Tambah": AppRoutes.broadcastTambah,

  // Pesan Warga
  "Informasi Aspirasi": AppRoutes.informasiAspirasiPage,

  // Penerimaan Warga
  "Penerimaan Warga": AppRoutes.penerimaanWarga,

  // Mutasi Keluarga
  // "Daftar Mutasi": belum ada route
  "Tambah Mutasi": AppRoutes.tambahMutasiPage,

  // Log Aktifitas
  "Semua Aktifitas": AppRoutes.semuaAktifitasPage,

  // Manajemen Pengguna
  "Daftar Pengguna": AppRoutes.daftarPengguna,
  "Tambah Pengguna": AppRoutes.tambahPengguna,

  // Channel Transfer
  "Daftar Channel": AppRoutes.daftarChannel,
  "Tambah Channel": AppRoutes.tambahChannel,
};
