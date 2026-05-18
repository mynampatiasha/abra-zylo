import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/wishlist/get_wish_list.dart';

abstract class WishlistState /* extends Equatable*/ {
  const WishlistState();

  /* @override
  List<Object> get props => [];*/
}

class WishlistInitialState extends WishlistState {}

class WishlistCompleteState extends WishlistState {}

class WishlistScreenSuccess extends WishlistState {
  GetWishlist? wishlistModel;

  WishlistScreenSuccess(this.wishlistModel);

  /* @override
  List<Object> get props => [];*/
}

class MoveToCartSuccess extends WishlistState {
  BaseModel? baseModel;

  MoveToCartSuccess(this.baseModel);

  /* @override
  List<Object> get props => [];*/
}

class WishlistActionState extends WishlistState {}

class RemoveItemSuccess extends WishlistState {
  BaseModel? baseModel;

  RemoveItemSuccess(this.baseModel);

  /*@override
  List<Object> get props => [];*/
}

class WishlistShareCollectionSuccess extends WishlistState {
  BaseModel? baseModel;

  WishlistShareCollectionSuccess(this.baseModel);

  /*@override
  List<Object> get props => [];*/
}

// ignore: must_be_immutable
class WishlistScreenError extends WishlistState {
  WishlistScreenError(this._message);

  String? _message;

  // ignore: unnecessary_getters_setters
  String? get message => _message;

  // ignore: unnecessary_getters_setters
  set message(String? message) {
    _message = message;
  }

  /*@override
  List<Object> get props => [];*/
}

class emptyState extends WishlistState {}
