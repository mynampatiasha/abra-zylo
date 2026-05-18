import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/address/add_address_request.dart';
import 'package:oc_demo/models/address/country_datum.dart';
import 'package:oc_demo/models/address/edit_address_book.dart';
import 'package:oc_demo/models/base_model.dart';
import 'package:oc_demo/network_manager/api_client.dart';

abstract class AddEditAddressRepository {
  Future<CountryDatum> getCountryList();

  Future<EditAddressBook> getAddressDetails(String? addressId);

  Future<BaseModel> updateAddress(String endPoint, String name, String phone,
      String street, String city, String zip, String countryId, String stateId);

  Future<BaseModel> addNewAddress(AddAddressRequest request);
}

class AddEditAddressRepositoryImp extends AddEditAddressRepository {
  @override
  Future<BaseModel> addNewAddress(AddAddressRequest request) {
    return ApiClient().addAddress(
      request.customerId ?? "",
      request.addressId,
      request.firstName ?? "",
      request.lastName ?? "",
      request.company ?? "",
      request.address1 ?? "",
      request.address2 ?? "",
      request.city ?? "",
      request.zoneId ?? "",
      request.postcode ?? "",
      request.countryId ?? "",
      request.defaultValue ?? "0",
      request.wkToken ?? "",
    );
  }

  @override
  Future<EditAddressBook> getAddressDetails(String? addressId) async {
    return ApiClient()
        .addAddressBook(addressId, await AppSharedPref.getWkToken());
  }

  @override
  Future<CountryDatum> getCountryList() {
    // TODO: implement getCountryList
    throw UnimplementedError();
  }

  @override
  Future<BaseModel> updateAddress(
      String endPoint,
      String name,
      String phone,
      String street,
      String city,
      String zip,
      String countryId,
      String stateId) {
    // TODO: implement updateAddress
    throw UnimplementedError();
  }
}
