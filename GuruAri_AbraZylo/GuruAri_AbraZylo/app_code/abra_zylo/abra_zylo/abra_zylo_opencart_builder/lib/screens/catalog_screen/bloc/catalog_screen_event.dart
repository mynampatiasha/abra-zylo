import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/catalog/request/catalog_product_request.dart';

abstract class CatalogScreenEvent {}

class OnClickLoaderCatalogEvent extends CatalogScreenEvent {
  final bool? isReqToShowLoader;

  OnClickLoaderCatalogEvent({this.isReqToShowLoader});
}

class ChangeViewEvent extends CatalogScreenEvent {
  final bool isGrid;

  ChangeViewEvent(this.isGrid);
}

class LoadingEvent extends CatalogScreenEvent {
  LoadingEvent();

  @override
  List<Object?> get props => [];
}

class FetchCatalogEvent extends CatalogScreenEvent {
  FetchCatalogEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}

class FetchCatalogBrandEvent extends CatalogScreenEvent {
  FetchCatalogBrandEvent(this.request);

  final CatalogProductRequest request;
}

class FetchPopularEvent extends CatalogScreenEvent {
  FetchPopularEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}

class FetchBestEvent extends CatalogScreenEvent {
  FetchBestEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}

class FetchFeatureEvent extends CatalogScreenEvent {
  FetchFeatureEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}

class FetchLatestEvent extends CatalogScreenEvent {
  FetchLatestEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}

class FetchCarouselsEvent extends CatalogScreenEvent {
  FetchCarouselsEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}

class FetchCustomCollection extends CatalogScreenEvent {
  FetchCustomCollection(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}

class FetchCatalogMoreProductEvent extends CatalogScreenEvent {
  FetchCatalogMoreProductEvent(
    this.object, {
    this.selectedFilters,
    this.page,
    this.blockId,
  });

  final String? object;
  final int? page;
  final String? selectedFilters;
  final String? blockId;
}

class FetchCatalogSearchedEvent extends CatalogScreenEvent {
  FetchCatalogSearchedEvent(this.key, {this.selectedFilters, this.page});

  final String? key;
  final int? page;
  final String? selectedFilters;
}

//add to wishlist
class AddToWishlistEvent extends CatalogScreenEvent {
  String? productId;
  AddToWishlistEvent(this.productId);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetSearchResultEvent extends CatalogScreenEvent {
  String? search;
  String? category_id;
  String? currentSearch;
  GetSearchResultEvent(this.search, this.category_id, this.currentSearch);
}
