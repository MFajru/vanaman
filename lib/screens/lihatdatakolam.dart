import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LihatDataKolam extends StatefulWidget {
  @override
  _LihatDataKolamState createState() => _LihatDataKolamState();
}

class _LihatDataKolamState extends State<LihatDataKolam> {
  Future getDataKolam() async {
    final response = await http
        .get("http://vanaman.educationhost.cloud/index.php/Kolam/getKolam");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lihat Kolam"),
      ),
      body: FutureBuilder(
          future: getDataKolam(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List list = snapshot.data;
                      return ListTile(
                        title: Text(list[index]['nama_kolam']),
                        onTap: () {
                          Navigator.pushNamed(context, "/DetailKolam");
                        },
                        subtitle: Text(list[index]['populasi']),
                      );
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }
}
