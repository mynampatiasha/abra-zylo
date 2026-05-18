import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/network_manager/api_client.dart';

abstract class OrderDetailRepository {
  Future<OrderDetailModel> getOrderDetails(String orderEndpoint);
  Future<BaseModel> reorderProduct(
    String orderId,
    String orderProductId,
  );
}

class OrderDetailRepositoryImp implements OrderDetailRepository {
  @override
  Future<OrderDetailModel> getOrderDetails(String orderId) async {
    try {
      OrderDetailModel? model;
      model = await ApiClient()
          .dashboarOrderInfo(orderId, await AppSharedPref.getWkToken());
      return model;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  Future<BaseModel> reorderProduct(
      String orderId, String orderProductId) async {
    try {
      BaseModel? model;
      model = await ApiClient().reOrderProduct(
          await AppSharedPref.getWkToken(), orderId, orderProductId);
      return model;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
