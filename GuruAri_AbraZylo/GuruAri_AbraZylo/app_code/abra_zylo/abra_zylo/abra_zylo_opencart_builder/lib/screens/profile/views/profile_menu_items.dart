import 'package:flutter/material.dart';
import 'package:oc_demo/models/homPage/home_screen_model.dart';

import '../../../constants/app_constants.dart';

class ProfileMenuItems {
  int id = 0;
  String title = '';
  String icon = AppImages.placeholder;
  IconData? iconData;
  FooterMenu? cmsData;
  bool? isCMS;

  ProfileMenuItems({
    required this.id,
    required this.title,
    required this.icon,
    this.cmsData,
    this.iconData,
    this.isCMS,
  });

  ProfileMenuItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
    isCMS = json['isCMS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon'] = icon;
    data['isCMS'] = isCMS;
    return data;
  }
}
