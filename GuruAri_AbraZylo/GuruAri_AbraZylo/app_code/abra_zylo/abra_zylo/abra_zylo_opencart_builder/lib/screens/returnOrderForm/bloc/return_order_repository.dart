import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/models/orderDetailModel/return_order_request.dart';
import 'package:oc_demo/network_manager/api_client.dart';

abstract class ReturnOrderRepository {
  Future<ReturnOrderRequest> getReturnOrderInfo(
      String orderId, String orderProductId);

  Future<BaseModel> submitReturn(
      String order_id,
      String product_id,
      String firstname,
      String lastname,
      String email,
      String telephone,
      String date_ordered,
      String product,
      String model,
      String quantity,
      String return_reason_id,
      String opened,
      String comment);
}

class ReturnOrderRepositoryImp extends ReturnOrderRepository {
  @override
  Future<ReturnOrderRequest> getReturnOrderInfo(
      String orderId, String orderProductId) async {
    return await ApiClient().addReturnData(
        await AppSharedPref.getWkToken(), orderId, orderProductId);
  }

  @override
  Future<BaseModel> submitReturn(
      String order_id,
      String product_id,
      String firstname,
      String lastname,
      String email,
      String telephone,
      String date_ordered,
      String product,
      String model,
      String quantity,
      String return_reason_id,
      String opened,
      String comment) async {
    return await AppSharedPref.isLogin()
        ? await ApiClient().addReturn(
            await AppSharedPref.getWkToken(),
            order_id,
            product_id,
            firstname,
            lastname,
            email,
            telephone,
            date_ordered,
            product,
            model,
            quantity,
            return_reason_id,
            opened,
            comment)
        : await ApiClient().guestOrdersAndReturnsData(
            await AppSharedPref.getWkToken(),
            order_id,
            product_id,
            firstname,
            lastname,
            email,
            telephone,
            date_ordered,
            product,
            model,
            quantity,
            return_reason_id,
            opened,
            comment);
  }
}
