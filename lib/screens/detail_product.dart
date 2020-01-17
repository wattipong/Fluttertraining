import 'package:flutter/material.dart';
import 'package:stafbuiding/models/product_model.dart';

class DetailProduct extends StatefulWidget {
  final ProductModel productModel;
  DetailProduct({Key key, this.productModel}) : super(key: key);

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  //Field
  String nameProdcut = '';
  ProductModel myProductModel;

  //Method
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myProductModel = widget.productModel;
    if (myProductModel != null) {
      nameProdcut = myProductModel.producrt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$nameProdcut'),
      ),
    );
  }
}
