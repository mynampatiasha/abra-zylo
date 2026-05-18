import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/catalog/brand/manufacture_model.dart';

import '../../../models/catalog/catalog_model.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';

abstract class CatalogScreenState {}

enum CatalogStatus { success, fail }

class OnClickLoaderCatalogState extends CatalogScreenState {
  final bool? isReqToShowLoader;

  OnClickLoaderCatalogState({this.isReqToShowLoader});
}

class ChangeViewState extends CatalogScreenState {
  final bool isGrid;

  ChangeViewState(this.isGrid);

  @override
  List<Object> get props => [isGrid];
}

class CatalogFetchState extends CatalogScreenState {
  final CatalogModel model;
  final bool isFromDb;

  CatalogFetchState(this.model, this.isFromDb);
}

class BrandFetchState extends CatalogScreenState {
  final ManufactureModel manufactureModel;
  final bool isFromDb;
  BrandFetchState(this.manufactureModel, this.isFromDb);
}

class CatalogErrorState extends CatalogScreenState {
  CatalogErrorState(this._message);

  String? _message;

  // ignore: unnecessary_getters_setters
  String? get message => _message;

  // ignore: unnecessary_getters_setters
  set message(String? message) {
    _message = message;
  }
}

class CatalogInitialState extends CatalogScreenState {}

class WishlistIdleState extends CatalogScreenState {}

class AddProductToWishlistStateSuccess extends CatalogScreenState {
  final AddProductToWishListModel wishListModel;
  final String productId;

  AddProductToWishlistStateSuccess(this.wishListModel, this.productId);

  /* @override
  List<Object> get props => [];*/
}

class GetSearchStateSuccess extends CatalogScreenState {
  final CatalogModel model;
  final String currentText;

  GetSearchStateSuccess(this.model, this.currentText);

/* @override
  List<Object> get props => [];*/
}

class CommonState extends CatalogScreenState {}
