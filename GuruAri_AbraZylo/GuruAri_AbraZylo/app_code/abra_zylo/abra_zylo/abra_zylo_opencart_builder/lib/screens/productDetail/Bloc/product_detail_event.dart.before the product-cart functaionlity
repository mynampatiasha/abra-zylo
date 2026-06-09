import 'package:equatable/equatable.dart';

abstract class ProductDetailScreenEvent extends Equatable {
  const ProductDetailScreenEvent();

  @override
  List<Object> get props => [];
}

/*
* Event to fetch the product detail
* */
class GetProductDetailEvent extends ProductDetailScreenEvent {
  String? productId;
//  String? eTag;
  GetProductDetailEvent(this.productId /*,this.eTag*/);

  @override
  List<Object> get props => [];
}

/*
* Event to add product review
*
* */

class AddProductReviewEvent extends ProductDetailScreenEvent {
  String? productId;
  String? reviewComment;
  String? rating;
  String? name;
  AddProductReviewEvent(
      this.productId, this.name, this.reviewComment, this.rating);

  @override
  List<Object> get props => [];
}

/*
*
* Get product review
* */
class GetProductReviewEvent extends ProductDetailScreenEvent {
  String? productId;
  String? page;
  GetProductReviewEvent(this.productId, this.page);

  @override
  List<Object> get props => [];
}

/*
*
* Add Product to cart Event
* * */
class AddProductToCartEvent extends ProductDetailScreenEvent {
  String? productId;
  String? quantity;
  String? productOptions;
  AddProductToCartEvent(this.productId, this.quantity, this.productOptions);
}

/*
* Buy Now Event
*
* */
class BuyNowEvent extends ProductDetailScreenEvent {
  String? productId;
  String? quantity;
  String? productOptions;
  BuyNowEvent(this.productId, this.quantity, this.productOptions);
}
/*
* Add Product to compare event
*
* */

class AddCompareProduct extends ProductDetailScreenEvent {
  String? productId;

  AddCompareProduct(this.productId);
}

/*
* Add Product to wishlist event
*
* */
class AddProductToWishListEvent extends ProductDetailScreenEvent {
  String? productId;
  AddProductToWishListEvent(this.productId);
}

class AddListProductToWishListEvent extends ProductDetailScreenEvent {
  String? productId;
  AddListProductToWishListEvent(this.productId);
}
