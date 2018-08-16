import 'package:flutter/material.dart'; // widgits etc
import 'package:flutter/rendering.dart'; // rendering methods

import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/product_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './models/product.dart';
import './scope_models/products.dart';

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
    return ScopedModel<ProductModel>(
      model: ProductModel(),
      child: MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            accentColor: Colors.lightGreen,
            buttonColor: Colors.lightGreen),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/products': (BuildContext context) => ProductsPage(),
          '/admin': (BuildContext context) => ProductAdminPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final int index = int.parse(pathElements[2]);
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) =>
                    ProductPage(index));
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage());
        },
      ),
    );
  }
}
