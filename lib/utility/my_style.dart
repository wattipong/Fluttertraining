import 'package:flutter/material.dart';

class MyStyle {
  Color textColor = Colors.orange.shade400;
  Color mainColor = Colors.teal.shade200;

  TextStyle h1TextStyle = TextStyle(
    fontFamily: 'PermanentMarker',
    color: Colors.orange.shade400,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
  );

  TextStyle h2TextStyle = TextStyle(
    fontFamily: 'PermanentMarker',
    color: Colors.orange.shade400,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
  );

  MyStyle();
}

class MyConstant {
  String urlHost = 'http://desktop-pkdogbs:3001/';

  MyConstant();
}
