import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;
import './screens/main/main_screen.dart';
import './screens/auth/login_screen.dart';
import './util/colors.dart';

final storage = FlutterSecureStorage();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amigo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: amigoRed,
      ),
      home: FutureBuilder(
        future: jwtOrEmpty,            
        builder: (context, snapshot) {
          if(!snapshot.hasData) return CircularProgressIndicator();
          if(snapshot.data != "") {
            var str = snapshot.data;
            var jwt = str.split(".");

            if(jwt.length !=3) {
              return LoginPage();
            } else {
              var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
              if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                return MainPage(str, payload);
              } else {
                return LoginPage();
              }
            }
          } else {
            return LoginPage();
          }
        }
      ),
    );
  }
}