import 'package:equatable/equatable.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class WishlistDataFetchEvent extends WishlistEvent {}

class MoveToCartEvent extends WishlistEvent {
  String? productId;
  String? quantity;
  String? productOptions;
  MoveToCartEvent(this.productId, this.quantity, this.productOptions);

  @override
  List<Object> get props => [];
}

class RemoveItemEvent extends WishlistEvent {
  final String productId;

  const RemoveItemEvent(this.productId);

  @override
  List<Object> get props => [];
}

class ShareWishlistCollectionEvent extends WishlistEvent {
  String? email;
  ShareWishlistCollectionEvent(this.email);
  @override
  List<Object> get props => [];
}
