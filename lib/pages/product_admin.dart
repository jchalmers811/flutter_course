import 'package:flutter/material.dart';

import './product_edit.dart';
import './product_list.dart';
import '../scope_models/main.dart';

class ProductAdminPage extends StatelessWidget {

  final MainModel model;

  ProductAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Choose'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
              leading: Icon(Icons.shop),
              title: Text('All Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/products');
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Manage Products'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.create), text: 'Create Product'),
              Tab(icon: Icon(Icons.list), text: 'My Productss'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ProductEditPage(),
            ProductListPage(model),
          ],
        ),
      ),
    );
  }
}
