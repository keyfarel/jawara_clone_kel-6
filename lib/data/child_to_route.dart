import '../routes/app_routes.dart';

final Map<String, String> childToRoute = {
  // Dashboard
  "Keuangan": AppRoutes.keuangan,
  "Kegiatan": AppRoutes.kegiatan,
  "Kependudukan": AppRoutes.kependudukan,

  // Data Warga & Rumah
  "Warga - Daftar": AppRoutes.wargaDaftar,
  "Warga - Tambah": AppRoutes.wargaTambah,
  "Keluarga": AppRoutes.keluarga,
  "Rumah - Daftar": AppRoutes.rumahDaftar,
  "Rumah - Tambah": AppRoutes.rumahTambah,

  // Pemasukan
  "Kategori Iuran": AppRoutes.kategoriIuran,
  "Tagih Iuran": AppRoutes.tagihIuran,
  "Tagihan": AppRoutes.tagihan,
  "Pemasukan Lain - Daftar": AppRoutes.pemasukanDaftar,
  "Pemasukan Lain - Tambah": AppRoutes.pemasukanTambah,

  // Pengeluaran
  "Daftar": AppRoutes.daftarPengeluaran,
  "Tambah": AppRoutes.tambahPengeluaran,

  // Laporan Keuangan
  "Semua Pemasukan": AppRoutes.semuaPemasukan,
  "Semua Pengeluaran": AppRoutes.semuaPengeluaran,
  "Cetak Laporan": AppRoutes.cetakLaporan,

  // Kegiatan & Broadcast
  "Kegiatan - Daftar": AppRoutes.kegiatanDaftar,
  "Kegiatan - Tambah": AppRoutes.kegiatanTambah,
  "Broadcast - Daftar": AppRoutes.broadcastDaftar,
  "Broadcast - Tambah": AppRoutes.broadcastTambah,

  // Pesan Warga
  "Informasi Aspirasi": AppRoutes.informasiAspirasiPage,

  // Penerimaan Warga
  "Penerimaan Warga": AppRoutes.penerimaanWarga,

  // Mutasi Keluarga
  "Daftar Mutasi": AppRoutes.daftarMutasi,
  "Tambah Mutasi": AppRoutes.tambahMutasi,

  // Log Aktifitas
  "Semua Aktifitas": AppRoutes.semuaAktifitasPage,

  // Manajemen Pengguna
  "Daftar Pengguna": AppRoutes.daftarPengguna,
  "Tambah Pengguna": AppRoutes.tambahPengguna,

  // Channel Transfer
  "Daftar Channel": AppRoutes.daftarChannel,
  "Tambah Channel": AppRoutes.tambahChannel,
};
