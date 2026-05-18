part of 'categories_screen_bloc.dart';

abstract class CategoriesScreenState {}

class CategoriesInitialState extends CategoriesScreenState {}

class OnClickWishListLoaderState extends CategoriesScreenState {
  final bool? isReqToShowLoader;

  OnClickWishListLoaderState({this.isReqToShowLoader});
}

class CategoriesFetchState extends CategoriesScreenState {
  SubCategoryModel categoriesModel;

  CategoriesFetchState(this.categoriesModel);
}

class ProductsFetchState extends CategoriesScreenState {
  CatalogModel model;

  ProductsFetchState(this.model);
}

// ignore: must_be_immutable
class CategoriescreenErrorState extends CategoriesScreenState {
  CategoriescreenErrorState(this._message);

  String? _message;

  // ignore: unnecessary_getters_setters
  String? get message => _message;

  // ignore: unnecessary_getters_setters
  set message(String? message) {
    _message = message;
  }
}

class AddProductToWishlistStateSuccess extends CategoriesScreenState {
  final AddProductToWishListModel wishListModel;
  final String productId;

  AddProductToWishlistStateSuccess(this.wishListModel, this.productId);

/* @override
  List<Object> get props => [];*/
}

class WishlistIdleState extends CategoriesScreenState {}
