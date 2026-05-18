part of 'categories_screen_bloc.dart';

abstract class CategoriesScreenEvent /*extends Equatable*/ {}

class FetchCategoriesEvent extends CategoriesScreenEvent {
  FetchCategoriesEvent(this.id);

  String? id;
}

class FetchProductsEvent extends CategoriesScreenEvent {
  FetchProductsEvent(this.request);

  CatalogProductRequest request;
}

class OnClickWishListLoaderEvent extends CategoriesScreenEvent {
  final bool? isReqToShowLoader;

  OnClickWishListLoaderEvent({this.isReqToShowLoader});
}

class AddToWishlistEvent extends CategoriesScreenEvent {
  String? productId;
  AddToWishlistEvent(this.productId);

  @override
  List<Object?> get props => throw UnimplementedError();
}
