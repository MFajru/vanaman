import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

int value;
String pesan, namaUser;

class _LoginState extends State<Login> {
  String username, password;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(
        "http://vanaman.educationhost.cloud/index.php/Users/getUser",
        body: {"username": username, "password": password});
    final data = jsonDecode(response.body);
    value = data['value'];
    pesan = data['message'];
    namaUser = data['nama_user'];

    if (value == 1) {
      _showToast();
      SharedPreferences session = await SharedPreferences.getInstance();
      session.setString("username", username);
      session.setString("nama_user", namaUser);
      Navigator.pushReplacementNamed(context, "/mainmenu");
      print(namaUser);
      print(pesan);
    } else {
      _showToast2();
      print(pesan);
    }
  }

  FToast fToast;
  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Login Berhasil"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showToast2() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              "Login Gagal.\n"
              "Username atau Password salah.",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Color.fromRGBO(152, 255, 254, 1.0),
          ),
          Form(
            key: _key,
            child: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: MyClipper2(),
                      child: Container(
                        height: 400,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        height: 400,
                        color: Color.fromRGBO(255, 220, 160, 1.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 25, top: 110),
                              child: Text(
                                "POSEIDON\nAQUAKULTURA SEJAHTERA",
                                style: TextStyle(
                                    color: Color.fromRGBO(148, 75, 15, 1.0),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(
                            //       left: 130, top: 180, right: 10),
                            //   child: Text("LOGO"),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, top: 330, right: 40),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 83, 66, 1.0),
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: TextFormField(
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Masukkan username";
                      }
                      return null;
                    },
                    onSaved: (e) => username = e,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 83, 66, 1.0),
                      fontSize: 23,
                    ),
                    decoration: InputDecoration(
                      hintText: "Username",
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0, 83, 66, 1.0))),
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(0, 83, 66, 0.3),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40, top: 20, right: 40),
                  child: TextFormField(
                    obscureText: _secureText,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Masukkan password";
                      }
                      return null;
                    },
                    onSaved: (e) => password = e,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 83, 66, 1.0),
                      fontSize: 23,
                    ),
                    decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: showHide,
                          icon: Icon(_secureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 83, 66, 1.0)),
                        ),
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(0, 83, 66, 0.3),
                          fontSize: 20,
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 80, top: 30, right: 80),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: check,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          elevation: 5,
                          primary: Color.fromARGB(255, 255, 177, 41)),
                      child: Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 35.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 200);
    path.quadraticBezierTo(size.width / 3, (size.height / 2) - 20,
        (size.width / 2) + 10, size.height - 110);
    path.quadraticBezierTo(size.width - (size.width / 3), size.height - 20,
        size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class MyClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 200);
    path.quadraticBezierTo(
        size.width / 3, size.height / 2, size.width / 2, size.height - 100);
    path.quadraticBezierTo(
        size.width - (size.width / 3), size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
