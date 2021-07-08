import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TambahPakanHarian extends StatefulWidget {
  @override
  _TambahPakanHarianState createState() => _TambahPakanHarianState();
}

class _TambahPakanHarianState extends State<TambahPakanHarian> {
  Map arguments;
  String idKolam, namaKolam;
  getValue() {
    idKolam = arguments['id_kolam'];
    namaKolam = arguments['nama_kolam'];
  }

  TextEditingController jumlah = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  formChecker() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      insertPakan();
    }
  }

  Future getCountPakan() async {
    final response = await http.get(
        "http://vanaman.educationhost.cloud/index.php/DataPakan/getCountPakan/$idKolam");
    return json.decode(response.body);
  }

  insertPakan() {
    http.post(
        "http://vanaman.educationhost.cloud/index.php/DataPakan/insertPakan/$idKolam",
        body: {'jumlah': jumlah.text});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;
    getValue();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Color.fromRGBO(152, 255, 254, 1.0),
          ),
          Form(
            key: _formKey,
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
                                child: FutureBuilder(
                                  future: getCountPakan(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError)
                                      print(snapshot.error);
                                    return snapshot.hasData
                                        ? RichText(
                                            text: TextSpan(
                                                text:
                                                    "Pakan Hari ke-${int.parse(snapshot.data['counts']) + 1}\n",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        148, 75, 15, 1.0),
                                                    fontSize: 28,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <TextSpan>[
                                                TextSpan(
                                                    text: namaKolam,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            148, 75, 15, 1.0),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ]))
                                        : Center(
                                            child: CircularProgressIndicator());
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 40),
                  child: Text(
                    "Jumlah Pakan Hari Ini",
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
                        return "Masukkan data pakan";
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
                  padding: EdgeInsets.only(top: 40),
                  child: RawMaterialButton(
                    onPressed: () {
                      formChecker();
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
