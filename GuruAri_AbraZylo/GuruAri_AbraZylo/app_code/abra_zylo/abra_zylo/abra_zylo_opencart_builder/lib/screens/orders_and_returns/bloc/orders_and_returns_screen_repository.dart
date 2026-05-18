/*
 *
 *  Webkul Software.
 * @package Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html
 *  @link https://store.webkul.com/license.html
 *
 * /
 */

import '../../../helper/app_shared_pref.dart';
import '../../../models/guestOrderReturn/GuestOrderReturn.dart';
import '../../../network_manager/api_client.dart';

abstract class OrdersAndReturnsRepository {
  Future<GuestOrderReturn> getGuestOrdersData(
      String incrementId, String email, String lastName, String zipCode);
}

class OrdersAndReturnsRepositoryImp implements OrdersAndReturnsRepository {
  @override
  Future<GuestOrderReturn> getGuestOrdersData(
      String incrementId, String email, String lastName, String zipCode) async {
    GuestOrderReturn? response;
    try {
      response = await ApiClient().getGuestOrders(
          await AppSharedPref.getWkToken(),
          incrementId,
          lastName,
          email,
          zipCode);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
    return response;
  }
}
