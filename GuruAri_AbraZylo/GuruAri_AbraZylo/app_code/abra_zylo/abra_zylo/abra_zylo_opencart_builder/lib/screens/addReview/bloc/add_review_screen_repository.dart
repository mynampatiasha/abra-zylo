import 'dart:convert';

import '../../../helper/app_shared_pref.dart';
import '../../../models/base_model.dart';
import '../../../network_manager/api_client.dart';

abstract class AddReviewRepository {
  Future<BaseModel> addReview(
      String name, String productId, String reviewComment, String Rating);
}

class AddReviewRepositoryImp implements AddReviewRepository {
  @override
  Future<BaseModel> addReview(String name, String productId,
      String reviewComment, String Rating) async {
    BaseModel model = await ApiClient().writeReview(name, reviewComment, Rating,
        productId, await AppSharedPref.getWkToken());
    return model;
  }
}
