import 'package:equatable/equatable.dart';

abstract class ItemCardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//add to wishlist
class AddToWishlistEvent extends ItemCardEvent {
  String? productId;
  AddToWishlistEvent(this.productId);
}
