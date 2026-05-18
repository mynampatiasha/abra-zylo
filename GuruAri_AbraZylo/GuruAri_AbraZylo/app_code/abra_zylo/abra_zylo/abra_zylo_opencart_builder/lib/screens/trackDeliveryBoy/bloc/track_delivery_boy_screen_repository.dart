import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/models/catalog/catalog_model.dart';
import 'package:oc_demo/models/catalog/request/catalog_product_request.dart';
import 'package:oc_demo/models/locationModel/location_model.dart';
import 'package:oc_demo/models/sub_category/sub_category_model.dart';

import '../../../helper/app_shared_pref.dart';
import '../../../network_manager/api_client.dart';

abstract class TrackDeliveryBoyRepository {
  Future<LocationModel?> getTrackDeliveryBoyData(String id);
}

class TrackDeliveryBoyRepositoryImp implements TrackDeliveryBoyRepository {
  @override
  Future<LocationModel?> getTrackDeliveryBoyData(String id) async {
    return await ApiClient().getDboyLocation(
      await AppSharedPref.getWkToken(),
      id,
    );
  }
}
