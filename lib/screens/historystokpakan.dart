import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryStokPakan extends StatefulWidget {
  @override
  _HistoryStokPakanState createState() => _HistoryStokPakanState();
}

class _HistoryStokPakanState extends State<HistoryStokPakan> {
  Future getHistory() async {
    final response = await http.get(
        "http://vanaman.educationhost.cloud/index.php/HistoryStokPakan/getHistory");
    return json.decode(response.body);
  }

  deleteHistory($id) {
    String idHistory = $id;
    http.post(
        "http://vanaman.educationhost.cloud/index.php/HistoryStokPakan/deleteHistory/$idHistory");
  }

  Future getTotalHistory() async {
    final response = await http.get(
        "http://vanaman.educationhost.cloud/index.php/HistoryStokPakan/getTotalHistory");
    return json.decode(response.body);
  }

  Future getPakan() async {
    final response = await http
        .get("http://vanaman.educationhost.cloud/index.php/DataPakan/getPakan");
    return json.decode(response.body);
  }

  Future getNamaKolam($id) async {
    String idKolam = $id;
    final response = await http.get(
        "http://vanaman.educationhost.cloud/index.php/Kolam/getDetailKolam/$idKolam");
    return json.decode(response.body);
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
          ListView(
            padding: EdgeInsets.only(top: 200),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Pakan Masuk Udang",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 83, 66, 1.0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minHeight: 100,
                          minWidth: double.infinity,
                          maxHeight: 360),
                      //color: Colors.black12,
                      child: FutureBuilder(
                        future: getHistory(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    List list = snapshot.data;
                                    return Card(
                                      color: Color.fromRGBO(136, 226, 226, 1.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          "${list[index]['jumlah']} Kilogram",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  0, 83, 66, 1.0),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17),
                                        ),
                                        subtitle: Text(
                                            "Pada : ${list[index]['created_at']}"),
                                        trailing: IconButton(
                                          icon: Icon(
                                              Icons.delete_forever_rounded),
                                          onPressed: () {
                                            return showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext alert) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          "Hapus History",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      83,
                                                                      66,
                                                                      1.0),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        content: Text(
                                                          "${list[index]['jumlah']} Kilogram",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      83,
                                                                      66,
                                                                      1.0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 17),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    alert);
                                                              },
                                                              child: Text(
                                                                  "Batal")),
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    alert);
                                                                deleteHistory(
                                                                    list[index]
                                                                        ['id']);
                                                              },
                                                              child:
                                                                  Text("Hapus"))
                                                        ],
                                                      );
                                                    })
                                                .then(
                                                    (value) => setState(() {}));
                                          },
                                          iconSize: 30,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 25),
                        child: FutureBuilder(
                          future: getTotalHistory(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            return snapshot.hasData
                                ? Text(
                                    "Total = ${snapshot.data['jumlah']} Kilogram",
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 83, 66, 1.0),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Center(child: CircularProgressIndicator());
                          },
                        )),
                    Center(
                      child: Text(
                        "Pakan Keluar",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 83, 66, 1.0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minHeight: 100,
                          minWidth: double.infinity,
                          maxHeight: 360),
                      //color: Colors.black12,
                      child: FutureBuilder(
                        future: getPakan(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    List list = snapshot.data;
                                    return Card(
                                      color: Color.fromRGBO(136, 226, 226, 1.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      child: ListTile(
                                        title: Row(
                                          children: <Widget>[
                                            Text(
                                              "${list[index]['jumlah']} Kg, ",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 83, 66, 1.0),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17),
                                            ),
                                            FutureBuilder(
                                              future: getNamaKolam(
                                                  list[index]['id_kolam']),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError)
                                                  print(snapshot.error);
                                                return snapshot.hasData
                                                    ? Text(
                                                        "Ke ${snapshot.data['nama_kolam']}",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    83,
                                                                    66,
                                                                    1.0),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 17),
                                                      )
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator());
                                              },
                                            )
                                          ],
                                        ),
                                        subtitle: Text(
                                            "Pada : ${list[index]['created_at']}"),
                                      ),
                                    );
                                  },
                                )
                              : Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 30),
                      child: Text(
                        "Total = ${arguments['pakanKeluar']} Kilogram",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 83, 66, 1.0),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          ClipPath(
            clipper: MyClipper2(),
            child: Container(
              height: 220,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              height: 210,
              color: Color.fromRGBO(255, 220, 160, 1.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 25, top: 92),
                    child: Text(
                      "History Stok Pakan",
                      style: TextStyle(
                          color: Color.fromRGBO(148, 75, 15, 1.0),
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
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
