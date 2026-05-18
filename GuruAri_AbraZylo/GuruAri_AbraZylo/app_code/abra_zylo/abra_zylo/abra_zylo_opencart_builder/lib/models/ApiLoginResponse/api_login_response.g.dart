// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiLoginResponseModel _$ApiLoginResponseModelFromJson(
        Map<String, dynamic> json) =>
    ApiLoginResponseModel(
      error: json['error'] as int?,
      wkToken: json['wkToken'] as String?,
      language: json['language'] as String?,
      currency: json['currency'] as String?,
      status: json['status'] as String?,
      walkThroughStatus: json['walkThroughStatus'] as String?,
      lightThemeConfig: json['lightThemeConfig'] == null
          ? null
          : ThemeConfig.fromJson(
              json['lightThemeConfig'] as Map<String, dynamic>),
      darkThemeConfig: json['darkThemeConfig'] == null
          ? null
          : ThemeConfig.fromJson(
              json['darkThemeConfig'] as Map<String, dynamic>),
      appLauncherType: json['appLauncherType'] as String?,
    );

Map<String, dynamic> _$ApiLoginResponseModelToJson(
        ApiLoginResponseModel instance) =>
    <String, dynamic>{
      'error': instance.error,
      'wkToken': instance.wkToken,
      'language': instance.language,
      'currency': instance.currency,
      'status': instance.status,
      'walkThroughStatus': instance.walkThroughStatus,
      'lightThemeConfig': instance.lightThemeConfig,
      'darkThemeConfig': instance.darkThemeConfig,
      'appLauncherType': instance.appLauncherType,
    };

ThemeConfig _$ThemeConfigFromJson(Map<String, dynamic> json) => ThemeConfig(
      fontStyle: json['font_style'] as String?,
      navigationColor: json['navigation_color'] as String?,
      navigationTitleColor: json['navigation_title_color'] as String?,
      buttonTextColor: json['button_text_color'] as String?,
      buttonBackgroundColor: json['button_background_color'] as String?,
      screenBackgroundColor: json['screen_background_color'] as String?,
      appLogo: json['app_logo'] as String?,
      splashImage: json['splash_image'] as String?,
    );

Map<String, dynamic> _$ThemeConfigToJson(ThemeConfig instance) =>
    <String, dynamic>{
      'font_style': instance.fontStyle,
      'navigation_color': instance.navigationColor,
      'navigation_title_color': instance.navigationTitleColor,
      'button_text_color': instance.buttonTextColor,
      'button_background_color': instance.buttonBackgroundColor,
      'screen_background_color': instance.screenBackgroundColor,
      'app_logo': instance.appLogo,
      'splash_image': instance.splashImage,
    };
