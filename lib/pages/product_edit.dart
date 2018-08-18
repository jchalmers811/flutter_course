import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scope_models/main.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image':
        'http://cheersbar.com.au/wp-content/uploads/2016/01/CheersBar-Food-76.jpg'
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      initialValue: product == null ? '' : product.title.toString(),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Title must be 5 characters or over';
        }
      },
      onSaved: (String value) {
        setState(() {
          _formData['title'] = value;
        });
      },
    );
  }

  Widget _buildDescriptionField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Description'),
      maxLines: 3,
      initialValue: product == null ? '' : product.description.toString(),
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Description must be 10 characters or over';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Price'),
      keyboardType: TextInputType.number,
      initialValue: product == null ? '' : product.price.toString(),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price must be a valid positive number';
        }
      },
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text('SAVE'),
                onPressed: () => _submitForm(
                    model.addProduct,
                    model.updateProduct,
                    model.selectProduct,
                    model.selectedProductIndex),
              );
      },
    );
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == -1) {
      addProduct(
        _formData['title'],
        _formData['description'],
        _formData['price'],
        _formData['image'],
      ).then((bool success) {
        if (success) {
          return Navigator
              .pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Something went wrong'),
              content: Text('Please try again'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Okay'),
                    onPressed: () => Navigator.of(context).pop())
              ],
            );
          });
        }
      });
    } else {
      updateProduct(
        _formData['title'],
        _formData['description'],
        _formData['price'],
        _formData['image'],
      ).then((_) => Navigator
          .pushReplacementNamed(context, '/products')
          .then((_) => setSelectedProduct(null)));
      ;
    }
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(
            FocusNode()); // tap outside of keyboard removes keyboard
      },
      child: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleField(product),
              _buildDescriptionField(product),
              _buildPriceField(product),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: pageContent,
              );
      },
    );
  }
}

// modal code
//showModalBottomSheet(context: context, builder: (BuildContext context) {
//return Center(child: Text('Modal Slide!') ,);
//});
