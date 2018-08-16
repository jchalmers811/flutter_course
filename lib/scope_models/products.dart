import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductModel extends Model {
  List<Product> _products = [];

  List<Product> get products {
    return List.from(_products); //create new list same as existing products
  }

  addProduct(Product product) {
      _products.add(product);
  }

  updateProduct(int index, Product product) {
      _products[index] = product;
  }

  deleteProduct(int index) {
      _products.removeAt(index);
  }
}