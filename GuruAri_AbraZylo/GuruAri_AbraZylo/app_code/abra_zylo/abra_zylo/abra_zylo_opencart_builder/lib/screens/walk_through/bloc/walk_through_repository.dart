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

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:oc_demo/constants/app_constants.dart';

import '../../../models/walk_through/walk_through_model.dart';
import '../../../network_manager/api_client.dart';

abstract class WalkThroughRepository {
  Future<WalkThroughModel> getWalkThroughData();
}

class WalkThroughRepositoryImp implements WalkThroughRepository {
  @override
  Future<WalkThroughModel> getWalkThroughData() async {
    WalkThroughModel? data;
    try {
      data = await ApiClient().getWalkThrough(
          AppSizes.deviceHeight.toString(), AppSizes.deviceWidth.toString());
    } catch (e) {
      print(e);
      throw Exception(e);
    }
    return data!;
  }
}
