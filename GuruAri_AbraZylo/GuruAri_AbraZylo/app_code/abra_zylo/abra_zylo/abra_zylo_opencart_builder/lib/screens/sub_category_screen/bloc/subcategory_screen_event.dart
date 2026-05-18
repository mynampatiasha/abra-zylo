import 'package:equatable/equatable.dart';

import '../../../models/catalog/request/catalog_product_request.dart';

abstract class SubCategoryScreenEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SubCategoryScreenDatFetchEvent extends SubCategoryScreenEvent {
  SubCategoryScreenDatFetchEvent(this.categoryId);

  final String categoryId;

  @override
  List<Object> get props => [];
}

class SubCategoriesProductEvent extends SubCategoryScreenEvent {
  SubCategoriesProductEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object?> get props => [request];
}

class AddToWishlistEvent extends SubCategoryScreenEvent {
  String? productId;
  AddToWishlistEvent(this.productId);

  @override
  List<Object?> get props => throw UnimplementedError();
}
