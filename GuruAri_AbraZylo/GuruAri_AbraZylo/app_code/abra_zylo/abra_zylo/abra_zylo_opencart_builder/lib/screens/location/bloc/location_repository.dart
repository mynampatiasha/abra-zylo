import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/models/google_place_model.dart';
import 'package:oc_demo/network_manager/api_client.dart';

abstract class LocationRepository {
  Future<GooglePlaceModel> getPlace(String text);
}

class LocationRepositoryImp implements LocationRepository {
  @override
  Future<GooglePlaceModel> getPlace(String text) async {
    GooglePlaceModel? model;
    String endPoint = "$text&key=${AppConstant.googleKey}";
    model = await ApiClient(baseUrl: "https://maps.googleapis.com/maps/api/")
        .getGooglePlace(endPoint);
    return model;
  }
}
