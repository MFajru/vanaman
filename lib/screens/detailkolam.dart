import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class DetailKolam extends StatefulWidget {
  @override
  _DetailKolamState createState() => _DetailKolamState();
}

class _DetailKolamState extends State<DetailKolam> {
  Map arguments;
  String idKolam;
  var kolam, spotGoldCoinPakan, spotPakan, spotGoldCoinBiomass, spotBiomass;
  getValue() {
    idKolam = arguments['id_kolam'];
  }

  Future getDetailKolam() async {
    final response = await http.get(
        "http://vanaman.educationhost.cloud/index.php/Kolam/getDetailKolam/$idKolam");
    return json.decode(response.body);
  }

  Future getTable() async {
    final response = await http
        .get("http://vanaman.educationhost.cloud/index.php/Goldcoin/getTable");
    return json.decode(response.body);
  }

  Future getPakanKolam() async {
    final response = await http.get(
        "http://vanaman.educationhost.cloud/index.php/DataPakan/getPakanKolam/$idKolam");
    return json.decode(response.body);
  }

  Future getSamplingKolam() async {
    final response = await http.get(
        "http://vanaman.educationhost.cloud/index.php/DataSampling/getSamplingKolam/$idKolam");
    return json.decode(response.body);
  }

  deleteKolam() {
    http.post(
        "http://vanaman.educationhost.cloud/index.php/Kolam/deleteKolam/$idKolam");
    Navigator.pop(context);
  }

  Future onRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;
    getValue();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FutureBuilder(
            future: getTable(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              spotGoldCoinPakan = List.generate(
                  snapshot.data.length,
                  (index) => FlSpot(double.parse(snapshot.data[index]['day']),
                      double.parse(snapshot.data[index]['pakan_harian'])));
              spotGoldCoinBiomass = List.generate(
                  snapshot.data.length,
                  (index) => FlSpot(double.parse(snapshot.data[index]['day']),
                      double.parse(snapshot.data[index]['biomass'])));
              return FutureBuilder(
                future: getPakanKolam(),
                builder: (context, snapshot2) {
                  if (snapshot2.hasError) {
                    print(snapshot2.error);
                  }
                  spotPakan = List.generate(
                      snapshot2.data.length,
                      (index) => FlSpot(index.toDouble() + 1,
                          double.parse(snapshot2.data[index]['jumlah'])));
                  return FutureBuilder(
                    future: getSamplingKolam(),
                    builder: (context, snapshot3) {
                      if (snapshot3.hasError) {
                        print(snapshot3.error);
                      }
                      spotBiomass = List.generate(
                          snapshot3.data.length,
                          (index) => FlSpot(index.toDouble() + 1,
                              double.parse(snapshot3.data[index]['biomass'])));
                      return Text("");
                    },
                  );
                },
              );
            },
          ),
          Container(
            color: Color.fromRGBO(152, 255, 254, 1.0),
          ),
          RefreshIndicator(
            onRefresh: onRefresh,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 80, left: 25),
                              child: FutureBuilder(
                                future: getDetailKolam(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                  }
                                  kolam = snapshot.data;
                                  return snapshot.hasData
                                      ? Text(
                                          "Detail ${kolam['nama_kolam']}",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  148, 75, 15, 1.0),
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator());
                                },
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 25),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              "/tambahsampling", arguments: {
                                            'id_kolam': kolam['id'],
                                            'nama_kolam': kolam['nama_kolam']
                                          }).then((value) => setState(() {}));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                            ),
                                            elevation: 5,
                                            primary: Colors.green),
                                        child: Container(
                                            width: 120,
                                            height: 60,
                                            child: Center(
                                                child: Text(
                                              "SAMPLING",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            )))),
                                    SizedBox(width: 25),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              "/tambahpakanharian", arguments: {
                                            'id_kolam': kolam['id'],
                                            'nama_kolam': kolam['nama_kolam']
                                          }).then((value) => setState(() {}));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                            ),
                                            elevation: 5,
                                            primary: Colors.green),
                                        child: Container(
                                            width: 120,
                                            height: 60,
                                            child: Center(
                                                child: Text(
                                              "PAKAN",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ))))
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Text(
                    "Grafik Perkembangan\nPakan Harian",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 83, 66, 1.0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      color: Color.fromRGBO(136, 226, 226, 1.0),
                    ),
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: 2500,
                        height: 325,
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 18.0, left: 20.0, top: 30, bottom: 20),
                          child: LineChart(LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Color.fromRGBO(136, 226, 226, 1.0),
                                    strokeWidth: 1,
                                  );
                                },
                                getDrawingVerticalLine: (value) {
                                  return FlLine(
                                    color: Color.fromRGBO(136, 226, 226, 1.0),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: SideTitles(
                                  rotateAngle: 90,
                                  showTitles: true,
                                  reservedSize: 15,
                                  getTextStyles: (value) => const TextStyle(
                                      color: Color.fromRGBO(0, 83, 66, 1.0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  getTitles: (value) {
                                    for (var i = 1; i < 121; i++) {
                                      if (value.toInt() == i) {
                                        return "$i";
                                      }
                                    }
                                    return '';
                                  },
                                  margin: 8,
                                ),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  getTextStyles: (value) => const TextStyle(
                                    color: Color.fromRGBO(0, 83, 66, 1.0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  getTitles: (value) {
                                    switch (value.toInt()) {
                                      case 10:
                                        return '10 Kg';
                                      case 20:
                                        return '20 Kg';
                                      case 30:
                                        return '30 Kg';
                                      case 40:
                                        return '40 Kg';
                                      case 50:
                                        return '50 Kg';
                                    }
                                    return '';
                                  },
                                  reservedSize: 28,
                                  margin: 12,
                                ),
                              ),
                              borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                              minX: 0,
                              maxX: 121,
                              minY: 0,
                              maxY: 50,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: spotGoldCoinPakan,
                                  isCurved: true,
                                  colors: [Colors.green],
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                  ),
                                ),
                                LineChartBarData(
                                  spots: spotPakan,
                                  isCurved: true,
                                  colors: [Colors.blue],
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                  ),
                                )
                              ])),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 35, left: 25, right: 25),
                  child: Text(
                    "Grafik Perkembangan\nBiomass",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 83, 66, 1.0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                        color: Color.fromRGBO(136, 226, 226, 1.0)),
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: 2500,
                        height: 350,
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 18.0, left: 20.0, top: 50, bottom: 20),
                          child: LineChart(LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Color.fromRGBO(136, 226, 226, 1.0),
                                    strokeWidth: 1,
                                  );
                                },
                                getDrawingVerticalLine: (value) {
                                  return FlLine(
                                    color: Color.fromRGBO(136, 226, 226, 1.0),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: SideTitles(
                                  rotateAngle: 90,
                                  showTitles: true,
                                  reservedSize: 15,
                                  getTextStyles: (value) => const TextStyle(
                                      color: Color.fromRGBO(0, 83, 66, 1.0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  getTitles: (value) {
                                    for (var i = 1; i < 121; i++) {
                                      if (value.toInt() == i) {
                                        return "$i";
                                      }
                                    }
                                    return '';
                                  },
                                  margin: 8,
                                ),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  getTextStyles: (value) => const TextStyle(
                                    color: Color.fromRGBO(0, 83, 66, 1.0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  getTitles: (value) {
                                    switch (value.toInt()) {
                                      case 400:
                                        return '400 Kg';
                                      case 800:
                                        return '800 Kg';
                                      case 1200:
                                        return '1200 Kg';
                                      case 1600:
                                        return '1600 Kg';
                                      case 2000:
                                        return '2000 Kg';
                                    }
                                    return '';
                                  },
                                  reservedSize: 45,
                                  margin: 12,
                                ),
                              ),
                              borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                              minX: 0,
                              maxX: 121,
                              minY: 0,
                              maxY: 2000,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: spotGoldCoinBiomass,
                                  isCurved: true,
                                  colors: [Colors.green],
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                  ),
                                ),
                                LineChartBarData(
                                  spots: spotBiomass,
                                  isCurved: true,
                                  colors: [Colors.blue],
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                  ),
                                )
                              ])),
                        ),
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                  future: getDetailKolam(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    return snapshot.hasData
                        ? Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 35, left: 25, right: 25),
                                child: Text(
                                  "Akumulasi Pakan :\n${snapshot.data['akumulasi_pakan']} Kilogram",
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 83, 66, 1.0),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 20, left: 25, right: 25),
                                child: Text(
                                  "Biomass :\n${snapshot.data['biomass']} Kilogram",
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 83, 66, 1.0),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 20, left: 25, right: 25, bottom: 30),
                                child: Text(
                                  "FCR : ${snapshot.data['fcr']}",
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 83, 66, 1.0),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        : CircularProgressIndicator();
                  },
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.only(left: 25, top: 60),
                icon: Icon(Icons.arrow_back_ios),
                color: Color.fromRGBO(148, 75, 15, 1.0),
                iconSize: 30,
              ),
              IconButton(
                onPressed: () {
                  return showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext alert) {
                        return AlertDialog(
                          title: Text(
                            "Hapus ${kolam['nama_kolam']}",
                            style: TextStyle(
                                color: Color.fromRGBO(0, 83, 66, 1.0),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            "Yakin akan menghapusnya?",
                            style: TextStyle(
                                color: Color.fromRGBO(0, 83, 66, 1.0),
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(alert);
                                },
                                child: Text("Batal")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(alert);
                                  deleteKolam();
                                },
                                child: Text("Hapus"))
                          ],
                        );
                      }).then((value) => setState(() {}));
                },
                padding: EdgeInsets.only(top: 60, right: 20),
                icon: Icon(Icons.delete_forever_rounded),
                color: Color.fromRGBO(148, 75, 15, 1.0),
                iconSize: 30,
              ),
            ],
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
