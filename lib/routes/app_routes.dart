import 'package:flutter/material.dart';
import 'package:myapp/pages/auth/login_page.dart';
import 'package:myapp/pages/auth/register_page.dart';
import 'package:myapp/pages/home/dashboard/kegiatan_page.dart';
import 'package:myapp/pages/home/data_warga/rumah_tambah_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const rumahTambah = '/rumah_tambah';
  static const kegiatanDaftar = '/kegiatan_daftar';
  static const kegiatanTambah = '/kegiatan_tambah';
  static const wargaDaftar = '/warga_daftar';
  static const wargaTambah = '/warga_tambah';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    home: (context) => const KegiatanPage(),
    rumahTambah: (context) => const RumahTambahPage(),
    // tambahkan lainnya nanti
  };
}
