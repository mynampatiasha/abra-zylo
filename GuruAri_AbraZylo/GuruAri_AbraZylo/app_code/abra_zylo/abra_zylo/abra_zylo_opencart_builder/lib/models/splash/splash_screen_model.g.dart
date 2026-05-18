// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_screen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SplashScreenModel _$SplashScreenModelFromJson(Map<String, dynamic> json) =>
    SplashScreenModel(
      walkthroughVersion: (json['walkthroughVersion'] as num?)?.toDouble(),
      walkthroughDataResponse: json['WalkthroughData'] == null
          ? null
          : WalkthroughDataResponse.fromJson(
              json['WalkthroughData'] as Map<String, dynamic>),
      launcherIconConfiguration: json['launcher_icon_configuration'] as String?,
      appCategoryViewConfiguration:
          json['app_category_view_configuration'] as String?,
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total']
      ..light_theme_config = json['light_theme_config'] == null
          ? null
          : LightThemeConfigure.fromJson(
              json['light_theme_config'] as Map<String, dynamic>)
      ..dark_theme_config = json['dark_theme_config'] == null
          ? null
          : DarkThemeConfigure.fromJson(
              json['dark_theme_config'] as Map<String, dynamic>);

Map<String, dynamic> _$SplashScreenModelToJson(SplashScreenModel instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'walkthroughVersion': instance.walkthroughVersion,
      'WalkthroughData': instance.walkthroughDataResponse,
      'light_theme_config': instance.light_theme_config,
      'dark_theme_config': instance.dark_theme_config,
      'launcher_icon_configuration': instance.launcherIconConfiguration,
      'app_category_view_configuration': instance.appCategoryViewConfiguration,
    };

WalkthroughDataResponse _$WalkthroughDataResponseFromJson(
        Map<String, dynamic> json) =>
    WalkthroughDataResponse(
      walkthroughData: (json['walkthrough_list'] as List<dynamic>?)
          ?.map((e) => WalkthroughData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalkthroughDataResponseToJson(
        WalkthroughDataResponse instance) =>
    <String, dynamic>{
      'walkthrough_list': instance.walkthroughData,
    };

DarkThemeConfigure _$DarkThemeConfigureFromJson(Map<String, dynamic> json) =>
    DarkThemeConfigure(
      buttonColorDark: json['mobikul_theme_dark_app_button_color'] as String?,
      buttonTextColorDark:
          json['mobikul_theme_dark_app_button_text_theme_color'] as String?,
      appThemeColorDark: json['mobikul_theme_dark_app_theme_color'] as String?,
      darkSplashScreen: json['mobikul_theme_dark_splash'] as String?,
      themeTextColorDark:
          json['mobikul_theme_dark_theme_text_color'] as String?,
      mobikulThemeDarkLogo: json['mobikul_theme_dark_logo'] as String?,
      backgroundColor: json['mobikul_theme_dark_background_color'] as String?,
    );

Map<String, dynamic> _$DarkThemeConfigureToJson(DarkThemeConfigure instance) =>
    <String, dynamic>{
      'mobikul_theme_dark_app_button_color': instance.buttonColorDark,
      'mobikul_theme_dark_app_button_text_theme_color':
          instance.buttonTextColorDark,
      'mobikul_theme_dark_app_theme_color': instance.appThemeColorDark,
      'mobikul_theme_dark_theme_text_color': instance.themeTextColorDark,
      'mobikul_theme_dark_background_color': instance.backgroundColor,
      'mobikul_theme_dark_splash': instance.darkSplashScreen,
      'mobikul_theme_dark_logo': instance.mobikulThemeDarkLogo,
    };

LightThemeConfigure _$LightThemeConfigureFromJson(Map<String, dynamic> json) =>
    LightThemeConfigure(
      buttonColor: json['mobikul_theme_bright_app_button_color'] as String?,
      appThemeColor: json['mobikul_theme_bright_app_theme_color'] as String?,
      buttonTextColor:
          json['mobikul_theme_bright_app_button_text_theme_color'] as String?,
      lightSplashScreen: json['mobikul_theme_bright_splash'] as String?,
      themeTextColor: json['mobikul_theme_bright_theme_text_color'] as String?,
      mobikulThemeBrightLogo: json['mobikul_theme_bright_logo'] as String?,
      backgroundColor: json['mobikul_theme_bright_background_color'] as String?,
    );

Map<String, dynamic> _$LightThemeConfigureToJson(
        LightThemeConfigure instance) =>
    <String, dynamic>{
      'mobikul_theme_bright_app_button_color': instance.buttonColor,
      'mobikul_theme_bright_app_button_text_theme_color':
          instance.buttonTextColor,
      'mobikul_theme_bright_app_theme_color': instance.appThemeColor,
      'mobikul_theme_bright_background_color': instance.backgroundColor,
      'mobikul_theme_bright_theme_text_color': instance.themeTextColor,
      'mobikul_theme_bright_splash': instance.lightSplashScreen,
      'mobikul_theme_bright_logo': instance.mobikulThemeBrightLogo,
    };

WalkthroughData _$WalkthroughDataFromJson(Map<String, dynamic> json) =>
    WalkthroughData(
      json['id'] as String?,
      json['image'] as String?,
      json['title'] as String?,
      json['status'] as String?,
      json['sort_order'] as String?,
      json['description'] as String?,
    );

Map<String, dynamic> _$WalkthroughDataToJson(WalkthroughData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'title': instance.title,
      'status': instance.status,
      'sort_order': instance.sort_order,
      'description': instance.content,
    };
