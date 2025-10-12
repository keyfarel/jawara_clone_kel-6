import 'package:flutter/material.dart';
import 'package:myapp/pages/auth/login_page.dart';
import 'package:myapp/pages/auth/register_page.dart';
import 'package:myapp/pages/home/dashboard/kegiatan_page.dart';
import 'package:myapp/pages/home/warga_rumah/rumah_tambah_page.dart';
import 'package:myapp/pages/home/kegiatan_broadcast/broadcast_tambah_page.dart'; 

class AppRoutes {
  // auth 
  static const login = '/login';
  static const register = '/register';
  // dashboard
  static const kegiatan = '/kegiatan';
  // warga_rumah
  static const rumahTambah = '/rumah_tambah';
  // kegiatan_broadcast
  static const broadcastTambah = '/broadcast_tambah'; 

  static final Map<String, WidgetBuilder> routes = {
    // auth 
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    // dashboard
    kegiatan: (context) => const KegiatanPage(),
    // warga_rumah
    rumahTambah: (context) => const RumahTambahPage(),
    // kegiatan_broadcast
    broadcastTambah: (context) => const BroadcastTambahPage(),
    // tambahkan lainnya nanti
  };
}
