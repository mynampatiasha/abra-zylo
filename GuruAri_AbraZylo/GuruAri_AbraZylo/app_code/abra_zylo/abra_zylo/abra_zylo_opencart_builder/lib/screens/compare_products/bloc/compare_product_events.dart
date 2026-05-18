import 'package:equatable/equatable.dart';

abstract class CompareProductEvent extends Equatable {
  const CompareProductEvent();

  @override
  List<Object> get props => [];
}

class CompareProductDataFetchEvent extends CompareProductEvent {
  const CompareProductDataFetchEvent();

  @override
  List<Object> get props => [];
}

//add to wishlist
class AddToWishlistEvent extends CompareProductEvent {
  String productId;
  int position;
  AddToWishlistEvent(this.productId, this.position);
}

//remove from wishlist
class RemoveFromCompareEvent extends CompareProductEvent {
  String? productId;
  int? index;
  String? action;
  RemoveFromCompareEvent(this.productId, this.index, this.action);
}

//add to cart
class AddProductToCartEvent extends CompareProductEvent {
  String? productId;
  String? quantity;
  String? productOptions;
  AddProductToCartEvent(this.productId, this.quantity, this.productOptions);
}
