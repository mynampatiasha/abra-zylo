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

import 'package:json_annotation/json_annotation.dart';

import '../base_model.dart';

part 'splash_screen_model.g.dart';

@JsonSerializable()
class SplashScreenModel extends BaseModel {
  @JsonKey(name: "walkthroughVersion")
  double? walkthroughVersion;

  @JsonKey(name: "WalkthroughData")
  WalkthroughDataResponse? walkthroughDataResponse;

  @JsonKey(name: "light_theme_config")
  LightThemeConfigure? light_theme_config;

  @JsonKey(name: "dark_theme_config")
  DarkThemeConfigure? dark_theme_config;

  @JsonKey(name: "launcher_icon_configuration")
  String? launcherIconConfiguration;

  @JsonKey(name: "app_category_view_configuration")
  String? appCategoryViewConfiguration;

  SplashScreenModel(
      {this.walkthroughVersion,
      this.walkthroughDataResponse,
      this.launcherIconConfiguration,
      this.appCategoryViewConfiguration});

  factory SplashScreenModel.fromJson(Map<String, dynamic> json) =>
      _$SplashScreenModelFromJson(json);

  Map<String, dynamic> toJson() => _$SplashScreenModelToJson(this);
}

@JsonSerializable()
class WalkthroughDataResponse {
  @JsonKey(name: "walkthrough_list")
  List<WalkthroughData>? walkthroughData;

  WalkthroughDataResponse({this.walkthroughData});

  factory WalkthroughDataResponse.fromJson(Map<String, dynamic> json) =>
      _$WalkthroughDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalkthroughDataResponseToJson(this);
}

@JsonSerializable()
class DarkThemeConfigure {
  @JsonKey(name: "mobikul_theme_dark_app_button_color")
  String? buttonColorDark;

  @JsonKey(name: "mobikul_theme_dark_app_button_text_theme_color")
  String? buttonTextColorDark;

  @JsonKey(name: "mobikul_theme_dark_app_theme_color")
  String? appThemeColorDark;

  @JsonKey(name: "mobikul_theme_dark_theme_text_color")
  String? themeTextColorDark;

  @JsonKey(name: "mobikul_theme_dark_background_color")
  String? backgroundColor;

  @JsonKey(name: "mobikul_theme_dark_splash")
  String? darkSplashScreen;

  @JsonKey(name: "mobikul_theme_dark_logo")
  String? mobikulThemeDarkLogo;

  DarkThemeConfigure(
      {this.buttonColorDark,
      this.buttonTextColorDark,
      this.appThemeColorDark,
      this.darkSplashScreen,
      this.themeTextColorDark,
      this.mobikulThemeDarkLogo,
      this.backgroundColor});

  factory DarkThemeConfigure.fromJson(Map<String, dynamic> json) =>
      _$DarkThemeConfigureFromJson(json);

  Map<String, dynamic> toJson() => _$DarkThemeConfigureToJson(this);
}

@JsonSerializable()
class LightThemeConfigure {
  @JsonKey(name: "mobikul_theme_bright_app_button_color")
  String? buttonColor;

  @JsonKey(name: "mobikul_theme_bright_app_button_text_theme_color")
  String? buttonTextColor;

  @JsonKey(name: "mobikul_theme_bright_app_theme_color")
  String? appThemeColor;

  @JsonKey(name: "mobikul_theme_bright_background_color")
  String? backgroundColor;

  @JsonKey(name: "mobikul_theme_bright_theme_text_color")
  String? themeTextColor;

  @JsonKey(name: "mobikul_theme_bright_splash")
  String? lightSplashScreen;

  @JsonKey(name: "mobikul_theme_bright_logo")
  String? mobikulThemeBrightLogo;

  LightThemeConfigure(
      {this.buttonColor,
      this.appThemeColor,
      this.buttonTextColor,
      this.lightSplashScreen,
      this.themeTextColor,
      this.mobikulThemeBrightLogo,
      this.backgroundColor});

  factory LightThemeConfigure.fromJson(Map<String, dynamic> json) =>
      _$LightThemeConfigureFromJson(json);

  Map<String, dynamic> toJson() => _$LightThemeConfigureToJson(this);
}

@JsonSerializable()
class WalkthroughData {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "image")
  String? image;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "sort_order")
  String? sort_order;

  @JsonKey(name: "description")
  String? content;

  WalkthroughData(this.id, this.image, this.title, this.status, this.sort_order,
      this.content);

  factory WalkthroughData.fromJson(Map<String, dynamic> json) =>
      _$WalkthroughDataFromJson(json);

  Map<String, dynamic> toJson() => _$WalkthroughDataToJson(this);
}
