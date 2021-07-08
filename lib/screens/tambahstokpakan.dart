import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TambahStokPakan extends StatefulWidget {
  @override
  _TambahStokPakanState createState() => _TambahStokPakanState();
}

class _TambahStokPakanState extends State<TambahStokPakan> {
  TextEditingController jumlah = new TextEditingController();
  final _key = new GlobalKey<FormState>();

  checkPakan() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      updateStok();
    }
  }

  updateStok() {
    http.post(
        "http://vanaman.educationhost.cloud/index.php/HistoryStokPakan/insertHistory",
        body: {
          "jumlah": jumlah.text,
        });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
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
                        height: 310,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        height: 300,
                        color: Color.fromRGBO(255, 220, 160, 1.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 25, top: 120),
                              child: Text(
                                "Tambah Data Pakan\ndi Gudang",
                                style: TextStyle(
                                    color: Color.fromRGBO(148, 75, 15, 1.0),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, bottom: 30),
                  child: Text(
                    "Pakan di Gudang Saat Ini\n${arguments['stok_pakan']} Kilogram",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 83, 66, 1.0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    "Jumlah yang Ditambah",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 83, 66, 1.0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 40),
                  child: TextFormField(
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Masukkan jumlah pakan!";
                      }
                      return null;
                    },
                    controller: jumlah,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      new FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                    ],
                    decoration: InputDecoration(hintText: '(Kilogram)'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 40),
                  child: RawMaterialButton(
                    onPressed: () {
                      checkPakan();
                    },
                    elevation: 2.0,
                    fillColor: Colors.green,
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                )
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.only(left: 25, top: 60),
            icon: Icon(Icons.arrow_back_ios),
            color: Color.fromRGBO(148, 75, 15, 1.0),
            iconSize: 30,
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 4, size.height - 100, size.width / 2, size.height - 50);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 50);
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
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 4, size.height - 100, size.width / 2, size.height - 50);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
