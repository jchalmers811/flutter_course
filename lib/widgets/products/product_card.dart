import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'price_tag.dart';
import '../ui_elements/title_default.dart';
import '../ui_elements/address_tag.dart';
import '../../models/product.dart';
import '../../scope_models/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleDefault(product.title),
            SizedBox(width: 10.0),
            PriceTag(product.price.toString())
          ],
        ));
  }

  Widget _buildButtonBar(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(
                    context, '/product/' + model.allProducts[productIndex].id)),
            IconButton(
              icon: Icon(model.allProducts[productIndex].isFavourite
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                model.selectProduct(model.allProducts[productIndex].id);
                model.toggleProductFavouriteStatus();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(product.image),
            height: 300.0, //
            fit: BoxFit.cover, // zooms in to fit
            placeholder: AssetImage(
                'assets/food_background.jpg'), //display default image before loading from cache/server
          ),
          _buildTitlePriceRow(),
          AddressTag('Dunedin Central, Dunedin, New Zealand'),
          Text(product.userEmail),
          _buildButtonBar(context)
        ],
      ),
    );
  }
}
