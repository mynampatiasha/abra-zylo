import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/address/get_address.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/network_manager/api_client.dart';

import '../../../hive/hive_constant.dart';
import '../../../hive/hive_service.dart';

abstract class AddressBookRepository {
  Future<GetAddress> getAddressList(String etag);

  Future<BaseModel> deleteAddress(String addressId);
  Future<GetAddress?> getAddressListFromDb();
}

class AddressBookRepositoryImp extends AddressBookRepository {
  Future<GetAddress?> getAddressListFromDb() async {
    GetAddress? getAddress;
    String boxname = HiveConstant.getAddress;
    print("pankaj ---->>>>>>>>" + boxname);
    await HiveService.getHive().isExists(boxName: boxname).then((value) async {
      if (value) {
        await HiveService.getHive().getBoxes(boxname).then((value) {
          print("pankaj getAddressListFromDb()-- " + "${value}");

          if (value is GetAddress) {
            getAddress = value as GetAddress;
          }
        });
      }
    });

    return getAddress;
  }

  @override
  Future<GetAddress> getAddressList(String etag) async {
    GetAddress? getAddress = await ApiClient()
        .getAddressList(await AppSharedPref.getWkToken(), etag);
    await HiveService.getHive().addBoxes(
        getAddress, HiveConstant.getAddress); //save order list data in hive db

    return getAddress;
  }

  // @override
  // Future<AddressListModel> getAddressList() async {
  //   AddressListModel model;
  //   model = await ApiClient().getAddressList();
  //   print("qwdqwd--${model.defaultShippingAddressId?.toJson()}");
  //   return model;
  // }

  @override
  Future<BaseModel> deleteAddress(String addressId) async {
    return await ApiClient().deleteAddress(
      addressId,
      await AppSharedPref.getWkToken(),
    );
  }
}
