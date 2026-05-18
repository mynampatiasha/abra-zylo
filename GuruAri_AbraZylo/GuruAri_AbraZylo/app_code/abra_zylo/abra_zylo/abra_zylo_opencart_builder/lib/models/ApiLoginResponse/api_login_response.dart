import 'package:json_annotation/json_annotation.dart';

part 'api_login_response.g.dart';

@JsonSerializable()
class ApiLoginResponseModel {
  int? error;
  String? wkToken;
  String? language;
  String? currency;
  String? status;
  String? walkThroughStatus;
  ThemeConfig? lightThemeConfig;
  ThemeConfig? darkThemeConfig;
  String? appLauncherType;

  ApiLoginResponseModel(
      {this.error,
      this.wkToken,
      this.language,
      this.currency,
      this.status,
      this.walkThroughStatus,
      this.lightThemeConfig,
      this.darkThemeConfig,
      this.appLauncherType});

  ApiLoginResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    wkToken = json['wk_token'];
    language = json['language'];
    currency = json['currency'];
    status = json['status'];
    walkThroughStatus = json['walkthrough_status'];
    lightThemeConfig = json['light_theme_config'];
    darkThemeConfig = json['dark_theme_config'];
    darkThemeConfig = json['app_launcher_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['wk_token'] = this.wkToken;
    data['language'] = this.language;
    data['currency'] = this.currency;
    data['status'] = this.status;
    data['walkthrough_status'] = walkThroughStatus;
    return data;
  }
}

@JsonSerializable()
class ThemeConfig {
  @JsonKey(name: "font_style")
  String? fontStyle;

  @JsonKey(name: "navigation_color")
  String? navigationColor;

  @JsonKey(name: "navigation_title_color")
  String? navigationTitleColor;

  @JsonKey(name: "button_text_color")
  String? buttonTextColor;

  @JsonKey(name: "button_background_color")
  String? buttonBackgroundColor;

  @JsonKey(name: "screen_background_color")
  String? screenBackgroundColor;

  @JsonKey(name: "app_logo")
  String? appLogo;

  @JsonKey(name: "splash_image")
  String? splashImage;

  ThemeConfig(
      {this.fontStyle,
      this.navigationColor,
      this.navigationTitleColor,
      this.buttonTextColor,
      this.buttonBackgroundColor,
      this.screenBackgroundColor,
      this.appLogo,
      this.splashImage});

  factory ThemeConfig.fromJson(Map<String, dynamic> json) =>
      _$ThemeConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ThemeConfigToJson(this);

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is ThemeConfig &&
          runtimeType == other.runtimeType &&
          fontStyle == other.fontStyle &&
          navigationColor == other.navigationColor &&
          navigationTitleColor == other.navigationTitleColor &&
          buttonTextColor == other.buttonTextColor &&
          buttonBackgroundColor == other.buttonBackgroundColor &&
          screenBackgroundColor == other.screenBackgroundColor &&
          splashImage == other.splashImage &&
          appLogo == other.appLogo;

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
