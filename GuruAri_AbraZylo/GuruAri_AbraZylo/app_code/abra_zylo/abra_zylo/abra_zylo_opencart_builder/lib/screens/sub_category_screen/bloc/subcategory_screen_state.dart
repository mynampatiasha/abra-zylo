import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/sub_category/sub_category_model.dart';

import '../../../models/catalog/catalog_model.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';

abstract class SubCategoryBaseState /*extends Equatable*/ {
  const SubCategoryBaseState();

  /* @override
  List<Object> get props => [];*/
}

class SubCategoryInitialState extends SubCategoryBaseState {}

class SubCategorySuccessState extends SubCategoryBaseState {
  final SubCategoryModel? categoryScreenModel;

  const SubCategorySuccessState(this.categoryScreenModel);
}

class SubCategoriesProductState extends SubCategoryBaseState {
  final CatalogModel model;

  const SubCategoriesProductState(this.model);
}

class SubCategoryErrorState extends SubCategoryBaseState {
  SubCategoryErrorState(this._message);

  String? _message;

  // ignore: unnecessary_getters_setters
  String? get message => _message;

  // ignore: unnecessary_getters_setters
  set message(String? message) {
    _message = message;
  }

  // @override
  // List<Object> get props => [];
}

class AddProductToWishlistStateSuccess extends SubCategoryBaseState {
  final AddProductToWishListModel wishListModel;
  final String productId;

  AddProductToWishlistStateSuccess(this.wishListModel, this.productId);

/* @override
  List<Object> get props => [];*/
}

class WishlistIdleState extends SubCategoryBaseState {}
