import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stafbuiding/screens/authen.dart';
import 'package:stafbuiding/utility/my_style.dart';
import 'package:stafbuiding/widget/information.dart';
import 'package:stafbuiding/widget/show_list_product.dart';

class Building extends StatefulWidget {
  @override
  _BuildingState createState() => _BuildingState();
}

class _BuildingState extends State<Building> {
// field
  String nameLogin = '...';
  Widget currentWidget = ShowListProduct();

//Mesthod
  @override
  void initState() {
    super.initState();
    findDataLogin();
  }

  Future<String> findUrlApi() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String user = sharedPreferences.getString('User');

    String url = '${MyConstant().urlHost}api/users/getuser/$user';
    return url;
  }

  Future<void> findDataLogin() async {
    String url = await findUrlApi();
    print('URL = $url');

    Response response = await Dio().get(url);
    // print('Response = $response');
    var result = response.data['data'];
    print('result $result');

    for (var map in result) {
      setState(() {
        nameLogin = map['name'];
      });
      print('NameLogin === $nameLogin');
    }
  }

  Widget menuListProduct() {
    return ListTile(
      leading: Icon(Icons.filter_1),
      title: Text('List Product'),
      subtitle: Text('Descrip List Product'),
      onTap: () {
        setState(() {
          currentWidget = ShowListProduct();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuInformation() {
    return ListTile(
      leading: Icon(Icons.filter_1),
      title: Text('Information'),
      subtitle: Text('Descrip Information'),
      onTap: () {
        setState(() {
          currentWidget = Information();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuSignOut() {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        color: Colors.red,
      ),
      title: Text(
        'Sign Out',
        style: TextStyle(color: Colors.red),
      ),
      subtitle: Text(
        ' Sing out and Black to Authen Page',
        style: TextStyle(color: Colors.red.shade300),
      ),
      onTap: () {
        Navigator.of(context).pop();
        clearPrefereance();
      },
    );
  }

  Future<void> clearPrefereance() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.clear().then((response) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext buildContext) {
        return Authen();
      });
      Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
          (Route<dynamic> route) {
        return false;
      });
    });
  }

  Widget showNameLogin() {
    return Text('Log in by $nameLogin');
  }

  Widget showAppName() {
    return Text(
      'Staf Building',
      style: MyStyle().h2TextStyle,
    );
  }

  Widget showLogo() {
    return Container(
      height: 80.0,
      width: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showHead() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          showLogo(),
          showAppName(),
          showNameLogin(),
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHead(),
          menuListProduct(),
          menuInformation(),
          menuSignOut(),
        ],
      ),
    );
  }

  Widget searchForm() {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
          color: Colors.black38, borderRadius: BorderRadius.circular(12.0)),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white),
            hintText: 'Search Build',
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentWidget,
      drawer: showDrawer(),
      appBar: AppBar(
        backgroundColor: MyStyle().barColor,
        title: searchForm(),
      ),
    );
  }
}
