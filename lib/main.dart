import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/screens/detailkolam.dart';
import 'package:test_app/screens/historystokpakan.dart';
import 'package:test_app/screens/login.dart';
import 'package:test_app/screens/mainmenu.dart';
import 'package:test_app/screens/tambahkolam.dart';
import 'package:test_app/screens/tambahpakanharian.dart';
import 'package:test_app/screens/tambahsampling.dart';
import 'package:test_app/screens/tambahstokpakan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences session = await SharedPreferences.getInstance();
  var username = session.getString("username");
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Vanaman",
      home: username == null ? Login() : MainMenu(),
      routes: {
        "/login": (context) => Login(),
        "/mainmenu": (context) => MainMenu(),
        "/tambahstokpakan": (context) => TambahStokPakan(),
        "/tambahkolam": (context) => TambahKolam(),
        "/historypakan": (context) => HistoryStokPakan(),
        "/detailkolam": (context) => DetailKolam(),
        "/tambahsampling": (context) => TambahSampling(),
        "/tambahpakanharian": (context) => TambahPakanHarian(),
      },
    ),
  );
}
