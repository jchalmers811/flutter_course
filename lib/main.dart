import 'package:flutter/material.dart'; // widgits etc
import 'package:flutter/rendering.dart'; // rendering methods

import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/product_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './scope_models/main.dart';
import './models/product.dart';


void main() {
  //debugPaintSizeEnabled = true;
  runApp(MyApp());
}

// where possible use stateless widgets
// re-renders when input data changes
// constructor and build methods

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _myAppState();
  }
}

class _myAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            accentColor: Colors.lightGreen,
            buttonColor: Colors.lightGreen),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/products': (BuildContext context) => ProductsPage(model),
          '/admin': (BuildContext context) => ProductAdminPage(model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product = model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) =>
                    ProductPage(product));
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(model));
        },
      ),
    );
  }
}
