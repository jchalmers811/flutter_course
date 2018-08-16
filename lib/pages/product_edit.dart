import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scope_models/products.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final int productIndex;
  final Product product;

  ProductEditPage(
      {this.addProduct, this.product, this.updateProduct, this.productIndex});

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
    'image': 'assets/junk_food.jpg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      initialValue:
          widget.product == null ? '' : widget.product.title.toString(),
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

  Widget _buildDescriptionField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Description'),
      maxLines: 3,
      initialValue:
          widget.product == null ? '' : widget.product.description.toString(),
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

  Widget _buildPriceField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Price'),
      keyboardType: TextInputType.number,
      initialValue:
          widget.product == null ? '' : widget.product.price.toString(),
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

  _buildSubmitButton(){
    return ScopedModelDescendant<ProductModel>(builder: (BuildContext context, Widget child, ProductModel model) {
      return RaisedButton(
        color: Theme.of(context).accentColor,
        child: Text('SAVE'),
        onPressed: () =>  _submitForm(model.addProduct, model.updateProduct),
      );
    },);
  }

  void _submitForm(Function addProduct, Function updateProduct) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (widget.product == null) {
      widget.addProduct(Product(
          title: _formData['title'],
          description: _formData['description'],
          price: _formData['price'],
          image: _formData['image']));
    } else {
      widget.updateProduct(
          widget.productIndex,
          Product(
              title: _formData['title'],
              description: _formData['description'],
              price: _formData['price'],
              image: _formData['image']));
    }

    Navigator.pushReplacementNamed(context, '/products');
  }



  Widget _buildPageContent(BuildContext context) {
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
            padding: EdgeInsets.symmetric(horizontal: targetPadding),
            children: <Widget>[
              _buildTitleField(),
              _buildDescriptionField(),
              _buildPriceField(),
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
    final Widget pageContent = _buildPageContent(context);

    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Product'),
            ),
            body: pageContent,
          );
  }
}

// modal code
//showModalBottomSheet(context: context, builder: (BuildContext context) {
//return Center(child: Text('Modal Slide!') ,);
//});
