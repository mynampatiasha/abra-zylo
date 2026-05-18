import 'dart:convert';

import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/models/orderListModel/order_list_model.dart';

import '../../../hive/hive_constant.dart';
import '../../../hive/hive_service.dart';
import '../../../models/base_model.dart';
import '../../../network_manager/api_client.dart';

abstract class OrderScreenRepository {
  Future<OrderListModel> getOrderList(String wkToken, String page, String eTag);

  Future<OrderDetailModel> getOrderDetails(String orderId);
  Future<OrderListModel?> getOrderListFromDb(String page);
}

class OrderScreenRepositoryImp implements OrderScreenRepository {
  /**/

  Future<OrderListModel?> getOrderListFromDb(String page) async {
    OrderListModel? orderListModel;
    String boxname = HiveConstant.orderList + page;
    print("pankaj ---->>>>>>>>" + boxname);
    await HiveService.getHive().isExists(boxName: boxname).then((value) async {
      if (value) {
        await HiveService.getHive().getBoxes(boxname).then((value) {
          if (value is OrderListModel) {
            print("pankaj getOrderListFromDb()-- " + "${value}");
            orderListModel = value as OrderListModel;
          }
        });
      }
    });

    return orderListModel;
  }

  @override
  Future<OrderListModel> getOrderList(
      String wkToken, String page, String eTag) async {
    OrderListModel? model =
        await ApiClient().getAllOrderList(wkToken, page, eTag);
    await HiveService.getHive().addBoxes(
        model, HiveConstant.orderList + page); //save order list data in hive db
    return model;
  }

  @override
  Future<OrderDetailModel> getOrderDetails(String orderId) async {
    try {
      return await ApiClient()
          .getOrderDetails(await AppSharedPref.getWkToken(), orderId);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
