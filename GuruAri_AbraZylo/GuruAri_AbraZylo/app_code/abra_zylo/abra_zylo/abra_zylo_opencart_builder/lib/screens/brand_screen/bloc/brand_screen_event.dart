import 'package:equatable/equatable.dart';

import '../../../models/catalog/request/catalog_product_request.dart';

abstract class BrandScreenEvent extends Equatable {
  const BrandScreenEvent();

  @override
  List<Object> get props => [];
}

class BrandScreenFetchCarousel extends BrandScreenEvent {
  BrandScreenFetchCarousel(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}
