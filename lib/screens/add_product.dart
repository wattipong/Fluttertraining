import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stafbuiding/utility/my_style.dart';
import 'package:stafbuiding/utility/normal_dailog.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
// field
  File file;
  double lat, lng;
  String name, detail, urlPic, userPost;

// Method
  @override
  void initState() {
    super.initState();
    findLatLng();
    findUser();
  }

  Future<void> findUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userPost = sharedPreferences.getString('User');
  }

  Future<void> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print('lat = $lat , Lng = $lng ');
    });
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {}
  }

  Widget nameForm() {
    return TextField(
      onChanged: (String string) {
        name = string.trim();
      },
      decoration: InputDecoration(
        labelText: 'Name Product :',
        icon: Icon(Icons.android),
      ),
    );
  }

  Widget detailForm() {
    return TextField(
      onChanged: (String string) {
        detail = string.trim();
      },
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: 'Detail Product :',
        icon: Icon(Icons.details),
      ),
    );
  }

  Widget cameraButton() {
    return OutlineButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      icon: Icon(Icons.add_a_photo),
      label: Text('Camera'),
      onPressed: () {
        cameraAndGallery(ImageSource.camera);
      },
    );
  }

  Future<void> cameraAndGallery(ImageSource imageSource) async {
    await ImagePicker.pickImage(
      source: imageSource,
      maxWidth: 800.0,
      maxHeight: 800.0,
    ).then((response) {
      setState(() {
        file = response;
      });
    });
  }

  Widget galleryButton() {
    return OutlineButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      icon: Icon(Icons.add_photo_alternate),
      label: Text('Gallery'),
      onPressed: () {
        cameraAndGallery(ImageSource.gallery);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showPic() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: file == null ? Image.asset('images/pic.png') : Image.file(file),
    );
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        position: LatLng(lat, lng),
        markerId: MarkerId('idProduct'),
      ),
    ].toSet();
  }

  Widget contentOfMap() {
    return lat == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : showMap();
  }

  Widget showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: GoogleMap(
        markers: myMarker(),
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController googleMapController) {},
      ),
    );
  }

  Widget addProductButton() {
    return Container(
      child: RaisedButton(
        color: MyStyle().barColor,
        child: Text(
          'Add Product',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if (file == null) {
            normalDialog(context, 'Non Choose Picture',
                'Please Click Camera or Gallery');
          } else if (name == null ||
              name.isEmpty ||
              detail == null ||
              detail.isEmpty) {
            normalDialog(context, 'Have Space', 'Please Fill Every Blank');
          } else {
            confirmDialog();
          }
        },
      ),
    );
  }

  Widget showTitleAlert() {
    return ListTile(
      leading: Icon(
        Icons.supervisor_account,
        size: 36.0,
        color: MyStyle().mainColor,
      ),
      title: Text('Comfirm Value', style: MyStyle().h2TextStyle),
    );
  }

  Widget showNameAler() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name  = $name',
          style: MyStyle().h2Title,
        ),
      ],
    );
  }

  Widget showDetailAler() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 230.0,
          child: Text('Detail  = $detail'),
        ),
      ],
    );
  }

  Widget showlatAler() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 230.0,
          child: Text('latitude  = $lat'),
        ),
      ],
    );
  }

  Widget showlngAler() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 230.0,
          child: Text('longtitude  = $lng'),
        ),
      ],
    );
  }

  Widget showPicAlert() {
    return Container(
      width: 230,
      height: 230,
      child: Image.file(
        file,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget showContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showNameAler(),
        mySizedBox(),
        showDetailAler(),
        showPicAlert(),
        showlatAler(),
        showlngAler(),
      ],
    );
  }

  SizedBox mySizedBox() {
    return SizedBox(
      height: 5.0,
    );
  }

  Widget confirmButton() {
    return FlatButton(
      child: Text(
        'Confirm',
      ),
      onPressed: () {
        Navigator.of(context).pop();
        uploadImageToServer();
      },
    );
  }

  Future<void> insertValueToServer() async {
    print('url = $urlPic');

    Map<String, dynamic> map = Map();
    map['producrt'] = name;
    map['detail'] = detail;
    map['lat'] = lat.toString();
    map['lng'] = lng.toString();
    map['picture'] = urlPic;
    map['username'] = userPost;

    Response response =
        await Dio().post(MyConstant().urlInsertProduct, data: map);
    if (response.statusCode == 200) {
      
      Navigator.of(context).pop();

    } else {
      normalDialog(context, 'Cannot Upload', 'Please Try Again');
    }
  }

  Future<void> uploadImageToServer() async {
    Random random = Random();
    int i = random.nextInt(10000);
    String nameFile = 'pic$i.jpg';
    try {
      Map<String, dynamic> map = Map();
      map['file'] = UploadFileInfo(file, nameFile);
      FormData formData = FormData.from(map);

      await Dio().post(MyConstant().urlUpload, data: formData).then((response) {
        print('Response = $response');
        urlPic = '${MyConstant().urlPic}$nameFile';
        insertValueToServer();
      });
    } catch (e) {}
  }

  Widget cancelButton() {
    return FlatButton(
      child: Text(
        'Cancel',
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> confirmDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: showTitleAlert(),
            content: showContent(),
            actions: <Widget>[
              confirmButton(),
              cancelButton(),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
        backgroundColor: MyStyle().barColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          showPic(),
          showButton(),
          nameForm(),
          detailForm(),
          contentOfMap(),
          addProductButton(),
        ],
      ),
    );
  }
}
