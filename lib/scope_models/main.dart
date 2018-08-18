import 'package:scoped_model/scoped_model.dart';

import './connected_products.dart';

// main model that merges all other models
class MainModel extends Model with ConnectedProductsModel, UserModel, ProductModel, UtilityModel {


}