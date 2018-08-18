import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selProductId;
  bool _isLoading = false;

  // add new product added by user, returns false if error and true if success

}

class ProductModel extends ConnectedProductsModel {
  bool _showFavourites = false;

  //create new list same as existing products - immutability
  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    // if show favourites selected, filter list by isFavourite as below otherwise return whole list
    if (_showFavourites) {
      return _products.where((Product product) => product.isFavourite).toList();
    }
    return List.from(_products);
  }

  String get selectedProductId {
    return _selProductId;
  }

  // returns product index
  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      //returns first instance of product in list of
      return product.id == _selProductId;
    });
  }

  bool get displayFavouritesOnly {
    return _showFavourites;
  }

  Future<bool> addProduct(
      String title, String description, double price, String image) async {
    // create map of data for post request
    _isLoading = true;
    notifyListeners(); //notify listeners of important changes like this
    final Map<String, dynamic> productData = {
      'title': title,
      'descriptiom': description,
      'price': price,
      'image': image, // MIGHT NEED TO CHANGE TO WEB ADDRESS
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    try {
      // post http request then wait for response
      final http.Response response = await http.post(
          'https://flutter-products-d6223.firebaseio.com/products.json',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        // for catching errors in response
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      // catches many types of erros
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // replace product at index with new updated product
  Future<bool> updateProduct(
      String title, String description, double price, String image) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    return http
        .put(
            'https://flutter-products-d6223.firebaseio.com/products/${selectedProduct
            .id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          // may need to change
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    }).catchError((error) {
      //for catching a myriad of other errors
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  // delete product at index
  Future<bool> deleteProduct() {
    _isLoading = true;
    final String deleteProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutter-products-d6223.firebaseio.com/products/${selectedProduct
            .id}.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      //for catching a myriad of other errors
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://flutter-products-d6223.firebaseio.com/products.json')
        .then<Null>((http.Response response) {
      // async event so use then to wait for response

      final List<Product> fetchedProducts = []; // make list to add products too
      final Map<String, dynamic> productListData = json.decode(response
          .body); // stored as map of maps type <String, dynamic> but dynamic is sufficient
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        // for each product and its map of attributes (dynamic)
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);
        fetchedProducts.add(product); // add to list
      });
      _products =
          fetchedProducts; // replace existing products list with fetched products
      _isLoading = false;
      notifyListeners(); // update UI
      _selProductId = null;
    }).catchError((error) {
      //for catching a myriad of other errors
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  // so element index can be retrieved
  void selectProduct(String productId) {
    _selProductId = productId;
    if (selectedProduct != null) {
      notifyListeners();
    }
  }

  void toggleProductFavouriteStatus() {
    final bool isCurrentlyFavourite =
        _products[selectedProductIndex].isFavourite;
    final bool newFavouriteStatus = !isCurrentlyFavourite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavourite: newFavouriteStatus);

    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavourites = !_showFavourites;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: 'meow', email: email, password: password);
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
