
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stafbuiding/utility/my_style.dart';
import 'package:stafbuiding/utility/normal_dailog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
//field
  String name = '', user = '', password = '';

//Method
  Widget nameForm() {
    Color color = Colors.purple;
    return TextField(
      onChanged: (String string) {
        name = string.trim();
      },
      style: TextStyle(color: color),
      decoration: InputDecoration(
        helperStyle: TextStyle(color: color),
        helperText: 'Type Your Name In Blank',
        labelStyle: TextStyle(color: color),
        labelText: 'Name :',
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color)),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: color,
        ),
      ),
    );
  }

  Widget userForm() {
    Color color = Colors.blue;
    return TextField(
      onChanged: (String string) {
        user = string.trim();
      },
      style: TextStyle(color: color),
      decoration: InputDecoration(
        helperStyle: TextStyle(color: color),
        helperText: 'Type Your User In Blank',
        labelStyle: TextStyle(color: color),
        labelText: 'User :',
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color)),
        icon: Icon(
          Icons.account_circle,
          size: 36.0,
          color: color,
        ),
      ),
    );
  }

  Widget passwordForm() {
    Color color = Colors.orange;
    return TextField(
      onChanged: (String string) {
        password = string.trim();
      },
      style: TextStyle(color: color),
      decoration: InputDecoration(
        helperStyle: TextStyle(color: color),
        helperText: 'Type Your password In Blank',
        labelStyle: TextStyle(color: color),
        labelText: 'password :',
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color)),
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: color,
        ),
      ),
    );
  }

  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('Name : $name, user: $user,passowrd: $password');

        if (name.isEmpty || user.isEmpty || password.isEmpty) {
          normalDialog(context, 'Have Space', 'Pleas Fill Every Blank');
        } else {
          registerThead();
        }
      },
    );
  }

  Future<void> registerThead() async {
    String url = 'http://desktop-pkdogbs:3001/api/users/register';

    Map<String, dynamic> map = Map();
    map['username'] = user;
    map['password'] = password;
    map['name'] = name;
    map['department'] = 'Sales';
    map['position'] = 'Sales';
    map['employee_id'] = '999999';
    map['role_id'] = 1;

    try {
      Response response = await Dio().post(url, data: map);
      if (response.statusCode < 400) {
        print('response Success Regis ==> $response');

        Navigator.of(context).pop();

        // var mapData = response.data['data'];
        // print('mapData = $mapData');

        // int id = mapData['id'];
        // print('id ===>>> $id');
      } else {
        print('Status Code ==> ${response.statusCode}');
      }
    } catch (e) {
      print('e ===>>> ${e.toString()}');
      normalDialog(context, 'User false', 'This User Already in User');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          registerButton(),
        ],
        title: Text('Register'),
        backgroundColor: MyStyle().mainColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          nameForm(),
          userForm(),
          passwordForm(),
        ],
      ),
    );
  }
}
