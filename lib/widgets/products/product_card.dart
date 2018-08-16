import 'package:flutter/material.dart';

import 'price_tag.dart';
import '../ui_elements/title_default.dart';
import '../ui_elements/address_tag.dart';
import '../../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow(){
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleDefault(product.title),
            SizedBox(width: 10.0),
            PriceTag(product.price.toString())
          ],
        )
    );
  }

  Widget _buildButtonBar(BuildContext context){
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.info),
            color: Theme.of(context).accentColor,
            onPressed: () => Navigator.pushNamed<bool>(
                context, '/product/' + productIndex.toString())),
        IconButton(
            icon: Icon(Icons.favorite_border),
            color: Theme.of(context).primaryColor,
            onPressed: () => Navigator.pushNamed<bool>(
                context, '/product/' + productIndex.toString()))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product.image),
          _buildTitlePriceRow(),
          AddressTag('Dunedin Central, Dunedin, New Zealand'),
          _buildButtonBar(context)
        ],
      ),
    );
  }

}