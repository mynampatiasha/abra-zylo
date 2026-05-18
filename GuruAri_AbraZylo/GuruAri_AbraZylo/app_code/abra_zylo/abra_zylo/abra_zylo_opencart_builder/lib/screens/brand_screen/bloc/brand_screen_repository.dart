import '../../../models/carousel/carousel_model.dart';
import '../../../models/catalog/request/catalog_product_request.dart';
import '../../../network_manager/api_client.dart';

abstract class BrandScreenRepository {
  Future<CarouselModel> getCarouselProducts(CatalogProductRequest request);
}

class BrandScreenRepositoryImp implements BrandScreenRepository {
  @override
  Future<CarouselModel> getCarouselProducts(
      CatalogProductRequest request) async {
    return await ApiClient().getCarouselManufacture(
      request.page!,
      request.limit!,
      request.width!,
      request.path!,
      request.sort,
      request.order,
      request.token!,
    );
  }
}
