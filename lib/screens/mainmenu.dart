import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:test_app/widgets/weather.dart';
import 'package:test_app/models/weatherdata.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool isLoading = false;
  WeatherData weatherData;

  Future getKolam() async {
    final response = await http
        .get("http://vanaman.educationhost.cloud/index.php/Kolam/getKolam");
    return json.decode(response.body);
  }

  Future getTotalStok() async {
    final response = await http.get(
        "http://vanaman.educationhost.cloud/index.php/StokPakan/getTotalStok");
    return json.decode(response.body);
  }

  String stokPakan;

  Future getAllPakan() async {
    final response = await http.get(
        "http://vanaman.educationhost.cloud/index.php/DataPakan/getAllPakan");
    return json.decode(response.body);
  }

  String pakanKeluar;

  String username, namaUser;
  Future getSession() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    setState(() {
      username = session.getString("username");
      namaUser = session.getString("nama_user");
    });
  }

  logout() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    session.clear();
    Navigator.pushReplacementNamed(context, "/login");
  }

  startTime() async {
    var duration = new Duration(seconds: 7200);
    return new Timer(duration, backToLogin);
  }

  backToLogin() {
    logout();
    Navigator.pushReplacementNamed(context, "/login");
    _showToast();
  }

  FToast fToast;
  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Sesi telah habis"),
        ],
      ),
    );

    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 0.0,
            left: 25.0,
            right: 25.0,
            bottom: 50.0,
          );
        });
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy\nHH:mm:ss').format(dateTime);
  }

  Position _currentPosition;
  String _currentAddress;

  _getCurrentLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);
    setState(() {
      _getAddressFromLatLng();
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.subLocality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  loadWeather() async {
    setState(() {
      isLoading = true;
    });

    Position weatherPosition;
    try {
      weatherPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      print(e);
    }

    if (weatherPosition != null) {
      final lat = weatherPosition.latitude;
      final lon = weatherPosition.longitude;

      final weatherResponse = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=${lat.toString()}&lon=${lon.toString()}&appid=0ef67a38472f7483a8d1f979b1206af7');

      if (weatherResponse.statusCode == 200) {
        setState(() {
          weatherData = WeatherData.fromJson(jsonDecode(weatherResponse.body));
          isLoading = false;
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  String _timeString;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    loadWeather();
    startTime();
    getSession();
    fToast = FToast();
    fToast.init(context);
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Color.fromRGBO(152, 255, 254, 1.0),
          ),
          ClipPath(
            clipper: MyClipper2(),
            child: Container(
              width: double.infinity,
              height: 260,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              width: double.infinity,
              height: 250,
              color: Color.fromRGBO(255, 220, 160, 1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 10),
                    child: Text(
                      "Halo, $namaUser!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      _timeString,
                    ),
                  ),
                  if (_currentPosition != null && _currentAddress != null)
                    Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.location_on,
                                  size: 15,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              TextSpan(
                                  text: _currentAddress,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          ),
          Positioned(
              top: 45,
              right: 15,
              child: ElevatedButton(
                  onPressed: logout,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text("LOGOUT"))),
          Container(
              alignment: Alignment.center,
              child: Container(
                  width: 200.0,
                  height: 200.0,
                  color: Colors.grey.withOpacity(0.08),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: weatherData != null
                            ? Weather(weather: weatherData)
                            : Container(),
                      ),
                      isLoading
                          ? CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                            )
                          : IconButton(
                              icon: Icon(Icons.refresh),
                              tooltip: 'Refresh',
                              onPressed: loadWeather,
                              color: Colors.white,
                            ),
                    ],
                  ))),
          DraggableScrollableSheet(
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Stack(
                clipBehavior: Clip.hardEdge,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40)),
                    ),
                    child: ListView(
                      children: <Widget>[
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 3,
                              width: 65,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xffd9dbdb)),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, bottom: 5),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "/tambahstokpakan",
                                          arguments: {
                                            'stok_pakan': stokPakan
                                          }).then((value) => setState(() {}));
                                    },
                                    child: Container(
                                      width: 95,
                                      child: RichText(
                                        textAlign: TextAlign.left,
                                        softWrap: false,
                                        text: TextSpan(children: [
                                          WidgetSpan(
                                              child: Icon(
                                            Icons.add_circle_outline_rounded,
                                            size: 15,
                                          )),
                                          TextSpan(
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                              text: " STOK PAKAN")
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 20,
                              runSpacing: 5,
                              alignment: WrapAlignment.center,
                              children: [
                                FutureBuilder(
                                  future: getKolam(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      print(snapshot.error);
                                    }
                                    return snapshot.hasData
                                        ? GridView.builder(
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 10.0,
                                              mainAxisSpacing: 5.0,
                                            ),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              List list = snapshot.data;
                                              return Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      side: BorderSide(
                                                        color: Colors.black,
                                                        width: 1,
                                                      )),
                                                  color: Color.fromRGBO(
                                                      152, 255, 254, 1.0),
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    child: Center(
                                                      child: ListTile(
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              "/detailkolam",
                                                              arguments: {
                                                                'id_kolam':
                                                                    list[index]
                                                                        ['id'],
                                                              }).then((value) =>
                                                              setState(() {}));
                                                        },
                                                        title: Text(
                                                          list[index]
                                                              ['nama_kolam'],
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                        subtitle: Text(
                                                          "Populasi : ${list[index]['populasi']}",
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                            },
                                          )
                                        : Center(
                                            child: CircularProgressIndicator());
                                  },
                                ),
                                Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: BorderSide(
                                          color: Colors.black,
                                          width: 4,
                                        )),
                                    child: InkWell(
                                        splashColor: Colors.blue.withAlpha(30),
                                        onTap: () {
                                          Navigator.pushNamed(
                                                  context, "/tambahkolam")
                                              .then((value) => setState(() {}));
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.black,
                                          size: 100,
                                        ))),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, top: 20),
                              child: Column(
                                children: [
                                  FutureBuilder(
                                    future: getTotalStok(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        print(snapshot.error);
                                      } else if (snapshot.hasData) {
                                        stokPakan = snapshot.data['total'];
                                        return Text(
                                            "Stok Pakan di Gudang = $stokPakan");
                                      }
                                      return Center(
                                          child: CircularProgressIndicator());
                                    },
                                  ),
                                  FutureBuilder(
                                    future: getAllPakan(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        print(snapshot.error);
                                      } else if (snapshot.hasData) {
                                        pakanKeluar = snapshot.data['total'];
                                        return Text(
                                            "Total Pakan Keluar = $pakanKeluar");
                                      }
                                      return Center(
                                          child: CircularProgressIndicator());
                                    },
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, "/historypakan",
                                            arguments: {
                                              'pakanKeluar': pakanKeluar
                                            }).then((value) => setState(() {}));
                                      },
                                      child: Text("LIHAT HISTORY STOK PAKAN")),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      controller: scrollController,
                    ),
                  ),
                ],
              );
            },
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
