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
import '../../../models/reviewListModel/reviews_list_model.dart';
import '../../../network_manager/api_client.dart';

abstract class ReviewsScreenRepository {
  Future<ReviewsListModel> getReviewsList(int customerId);
}

class ReviewsScreenRepositoryImp implements ReviewsScreenRepository {
  @override
  Future<ReviewsListModel> getReviewsList(int pageNo) async {
    ReviewsListModel? responseData;
    try {
      responseData = await ApiClient()
          .getReviewsList(await AppSharedPref.getWkToken(), pageNo, 10);
    } catch (error, stacktrace) {
      print("Error --> $error");
      print("StackTrace --> $stacktrace");
    }
    return responseData!;
  }
}
