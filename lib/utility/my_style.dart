import 'package:flutter/material.dart';

class MyStyle {
  Color textColor = Color.fromARGB(0xff, 0x26, 0x41, 0x8f);
  Color mainColor = Color.fromARGB(0xff, 0x84, 0x93, 0xf3);
  Color barColor = Color.fromARGB(0xff, 0x3f, 0x51, 0xb5);

  TextStyle h1TextStyle = TextStyle(
    fontFamily: 'PermanentMarker',
    color: Color.fromARGB(0xff, 0x26, 0x41, 0x8f),
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
  );
  TextStyle h1TextStyleWhite = TextStyle(
    fontFamily: 'PermanentMarker',
    color: Colors.white,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
  );
  TextStyle h2TextStyle = TextStyle(
    fontFamily: 'PermanentMarker',
    color: Color.fromARGB(0xff, 0x26, 0x41, 0x8f),
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
  );

  TextStyle h2Title = TextStyle(
    color: Color.fromARGB(0xff, 0x26, 0x41, 0x8f),
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
  );

  MyStyle();
}

class MyConstant {
  String urlHost = 'http://desktop-pkdogbs:3001/';
  String urlUpload = 'http://192.168.1.109:90/dashboard/saveFile.php';
  String urlPic = 'http://192.168.1.109:90/dashboard/upload/';
  String urlInsertProduct = 'http://desktop-pkdogbs:3001/api/users/upload';
  String urlGetAllProduct = 'http://desktop-pkdogbs:3001/api/users/getpic';

  MyConstant();
}
