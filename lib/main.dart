import 'package:flutter/material.dart';
import 'package:stafbuiding/screens/authen.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     // home: Test(),
      home: Authen(),
    );
  }
}
