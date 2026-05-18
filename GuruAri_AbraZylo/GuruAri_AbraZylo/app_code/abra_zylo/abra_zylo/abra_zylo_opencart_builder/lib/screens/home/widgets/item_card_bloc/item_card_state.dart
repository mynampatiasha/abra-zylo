import 'package:equatable/equatable.dart';

import '../../../../models/productDetail/add_product_wishlist_model.dart';

abstract class ItemCardState extends Equatable {
  const ItemCardState();

  @override
  List<Object> get props => [];
}

class ItemCardInitial extends ItemCardState {}

class AddProductToWishlistStateSuccess extends ItemCardState {
  final AddProductToWishListModel wishListModel;
  final String productId;

  const AddProductToWishlistStateSuccess(this.wishListModel, this.productId);

  @override
  List<Object> get props => [];
}

class WishlistIdleState extends ItemCardState {}

//Error State
class ItemCardErrorState extends ItemCardState {
  ItemCardErrorState(this._message);

  String? _message;

  String? get message => _message;

  set message(String? message) {
    _message = message;
  }

  @override
  List<Object> get props => [];
}
