import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/productDetail/add_product_wishlist_model.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';

abstract class ProductDetailScreenState /*extends Equatable */ {
  const ProductDetailScreenState();

  /* @override
  List<Object> get props => [];*/
}

/*
* Initial state
* */
class ProductDetailStateInitial extends ProductDetailScreenState {}

/*
*
* Get product details state
* */
class ProductDetailStateSuccess extends ProductDetailScreenState {
  ProductDetailStateSuccess(this.productDetailScreenModel);

  ProductDetailScreenModel productDetailScreenModel;

  /*@override
  List<Object> get props => [];*/
}

/*
* State to add product  review
*
* */
class AddProductReviewStateSuccess extends ProductDetailScreenState {
  AddProductReviewStateSuccess(this.baseModel);

  BaseModel baseModel;

  @override
  List<Object> get props => [];
}

/*
* State to add product to cart
*
* */
class AddProductToCartStateSuccess extends ProductDetailScreenState {
  AddProductToCartStateSuccess(this.baseModel);

  BaseModel baseModel;

  @override
  List<Object> get props => [];
}

/*
* Buy product state
*
* */
class BuyProductStateSuccess extends ProductDetailScreenState {
  BuyProductStateSuccess(this.baseModel);

  BaseModel baseModel;

  @override
  List<Object> get props => [];
}

/*
* Add product to wishlist state
*
* */
class AddProductToWishlistStateSuccess extends ProductDetailScreenState {
  AddProductToWishlistStateSuccess(this.wishListModel);

  AddProductToWishListModel wishListModel;

  /*@override
  List<Object> get props => [];*/
}

/*
* Add product to compareProduct
*
* */
class AddProductCompareSuccessState extends ProductDetailScreenState {
  AddProductCompareSuccessState(this.model);

  BaseModel model;

/*@override
  List<Object> get props => [];*/
}

class CompleteState extends ProductDetailScreenState {
  CompleteState();

/*@override
  List<Object> get props => [];*/
}

/*
*
* Error state
* */
class ProductDetailStateError extends ProductDetailScreenState {
  ProductDetailStateError(this._message);

  String? _message;
  String? get message => _message;

  set message(String? message) {
    _message = message;
  }

  /*@override
  List<Object> get props => [];*/
}

class AddListProductToWishlistStateSuccess extends ProductDetailScreenState {
  final AddProductToWishListModel wishListModel;
  final String productId;

  AddListProductToWishlistStateSuccess(this.wishListModel, this.productId);

/*@override
  List<Object> get props => [];*/
}
