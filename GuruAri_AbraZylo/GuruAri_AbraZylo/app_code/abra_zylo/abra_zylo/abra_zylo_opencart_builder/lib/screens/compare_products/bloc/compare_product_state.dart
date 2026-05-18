import '../../../models/base_model.dart';
import '../../../models/compare_products/compare_product_model.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';

abstract class CompareProductState {
  const CompareProductState();

  @override
  List<Object> get props => [];
}

class CompareProductInitial extends CompareProductState {}

class CompareProductSuccess extends CompareProductState {
  CompareProduct? model;

  CompareProductSuccess(this.model);
  @override
  List<Object> get props => [];
}

class CompareProductError extends CompareProductState {
  final String? message;
  const CompareProductError(this.message);
}

class AddToWishlistStates extends CompareProductState {
  AddToWishlistStates(this.baseModel, this.position);

  AddProductToWishListModel? baseModel;
  int? position;

  @override
  List<Object> get props => [];
}

class RemoveFromCompareStateSuccess extends CompareProductState {
  final BaseModel baseModel;
  final String productId;
  final int index;

  const RemoveFromCompareStateSuccess(
      this.baseModel, this.productId, this.index);

  @override
  List<Object> get props => [];
}

class AddProductToCartSuccess extends CompareProductState {
  AddProductToCartSuccess(this.baseModel);

  BaseModel baseModel;

  @override
  List<Object> get props => [];
}
