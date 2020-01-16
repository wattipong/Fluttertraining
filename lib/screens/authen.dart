import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stafbuiding/screens/building.dart';
import 'package:stafbuiding/screens/register.dart';
import 'package:stafbuiding/utility/my_style.dart';
import 'package:stafbuiding/utility/normal_dailog.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
//  Field
  bool remember = false;
  String user, password;

// Method

  @override
  void initState() {
    super.initState();
    checkPreferance();
  }

  Future<void> checkPreferance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool remember = sharedPreferences.getBool('Remember');

    if (remember) {
      String user = sharedPreferences.getString('User');
      String password = sharedPreferences.getString('Password');
      checkAuthen(user, password, remember);
    }
  }

  Widget signInButton() {
    return RaisedButton(
      color: MyStyle().textColor,
      child: Text(
        'Sing In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        if (user == null ||
            password == null ||
            user.isEmpty ||
            password.isEmpty) {
          normalDialog(context, 'Have Space', 'Plesae Fill Every Blank');
        } else {
          checkAuthen(user, password, remember);
        }
      },
    );
  }

  Future<void> checkAuthen(String user, String password, bool remember) async {
    print('User = $user, password = $password');
    String url = '${MyConstant().urlHost}api/users/login';
    // var myJson = '{ "username": $user, "password": $password }';
    // Map<String, dynamic> map = json.decode(myJson);

    Map<String, dynamic> map = Map();
    map['username'] = user;
    map['password'] = password;
    try {
      Response response = await Dio().post(url, data: map);
      if (response.statusCode == 200) {
        var desciption = response.data['description'];
        normalDialog(context, 'Login False', desciption.toString());
      } else if (response.statusCode == 201) {
        var accesstoken = response.data['access_token'];
        // Success Login
        print('access_token ==> $accesstoken');
        savePrefarence(accesstoken.toString(), user, password, remember);
      } else {}
    } catch (e) {
      print('e == ${e.toString()}');
    }
  }

  Future<void> savePrefarence(
      String token, String user, String password, bool remember) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('Remember', remember);
    sharedPreferences.setString('User', user);
    sharedPreferences.setString('Password', password);
    sharedPreferences.setString('Token', token);

    routeToBuilding();
  }

  void routeToBuilding() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return Building();
    });

    Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
        (Route<dynamic> route) {
      return false;
    });
  }

  Widget signUpButton() {
    return OutlineButton(
      borderSide: BorderSide(color: MyStyle().textColor),
      child: Text(
        'Sing Up',
        style: TextStyle(color: MyStyle().textColor),
      ),
      onPressed: () {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext buildContext) {
          return Register();
        });
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget showButtion() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        signInButton(),
        SizedBox(
          width: 5.0,
        ),
        signUpButton(),
      ],
    );
  }

  Widget rememberCheck() {
    return Container(
      width: 250.0,
      child: CheckboxListTile(
        activeColor: MyStyle().textColor,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (bool value) {
          setState(() {
            remember = value;
          });
          print('remember = $remember');
        },
        title: Text(
          'Remenber Me',
          style: TextStyle(color: MyStyle().textColor),
        ),
        value: remember,
      ),
    );
  }

  Widget userForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (String string) {
          user = string.trim();
        },
        style: TextStyle(color: MyStyle().textColor),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyStyle().textColor)),
          hintText: 'User : ',
          hintStyle: TextStyle(color: MyStyle().textColor),
        ),
      ),
    );
  }

  Widget passwordForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (String string) {
          password = string.trim();
        },
        style: TextStyle(color: MyStyle().textColor),
        obscureText: true,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyStyle().textColor)),
          hintText: 'Password : ',
          hintStyle: TextStyle(color: MyStyle().textColor),
        ),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'Seiko Building',
      style: TextStyle(
        fontFamily: 'PermanentMarker',
        color: MyStyle().textColor,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontSize: 30.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: <Color>[Colors.white, MyStyle().mainColor],
            radius: 0.8,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showLogo(),
                showAppName(),
                userForm(),
                passwordForm(),
                rememberCheck(),
                showButtion(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
