import 'package:oc_demo/models/productDetail/add_product_wishlist_model.dart';
import 'package:oc_demo/network_manager/apis.dart';

import '../../../../helper/app_shared_pref.dart';
import '../../../../network_manager/api_client.dart';

abstract class ItemCardRepository {
  Future<AddProductToWishListModel?> addToWishList(String productId);
}

class ItemCardRepositoryImp extends ItemCardRepository {
  /// ****AddToWishList**/
  @override
  Future<AddProductToWishListModel?> addToWishList(String productId) async {
    AddProductToWishListModel model = await ApiClient()
        .addProductToWishlist(productId, await AppSharedPref.getWkToken());
    return model;
  }
}
