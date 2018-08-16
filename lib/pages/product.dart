import 'package:flutter/material.dart';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/ui_elements/title_default.dart';
import '../widgets/ui_elements/address_tag.dart';
import '../models/product.dart';
import '../scope_models/products.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<ProductModel>(
        builder: (BuildContext context, Widget child, ProductModel model) {
          final Product product = model.products[productIndex];
          return Scaffold(
            appBar: AppBar(
              title: Text(product.title),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(product.image),
                Container(
                    padding: EdgeInsets.all(10.0), child: TitleDefault(product.title)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AddressTag('Dunedin Central, Dunedin, New Zealand'),
                    SizedBox(width: 10.0),
                    Text(
                      '\$' + product.price.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    product.description,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
