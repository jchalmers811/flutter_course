import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'product_card.dart';
import '../../models/product.dart';
import '../../scope_models/products.dart';

// where possible use stateless widgets
// re-renders when input data changes
// constructor and build methods
class Products extends StatelessWidget {

  // build conditional list
  Widget _buildProductList(List<Product> products) {
    Widget productCards;
    if (products.length > 0) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductModel>(
      builder: (BuildContext context, Widget child, ProductModel model) {
        return _buildProductList(model.products);
      },
    );
  }
}
