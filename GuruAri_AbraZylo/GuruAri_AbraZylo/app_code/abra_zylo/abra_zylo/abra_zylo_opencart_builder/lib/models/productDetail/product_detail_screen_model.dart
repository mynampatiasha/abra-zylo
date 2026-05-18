import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../hive/hive_constant.dart';

part 'product_detail_screen_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveConstant.Twelve)
class ProductDetailScreenModel {
  /*@HiveField( HiveConstant.One)
  LangArray? langArray;*/

  @HiveField(100)
  @JsonKey(name: "etag")
  String? eTag = "";

  @JsonKey(name: "tab_review")
  @HiveField(HiveConstant.One)
  String? tabReview;

  @HiveField(HiveConstant.Two)
  @JsonKey(name: "ios_url")
  String? ios_ar = "";
  @HiveField(HiveConstant.FourtySix)
  @JsonKey(name: "android_url")
  String? android_ar = "";

  /*@JsonKey(name: "ar_url")
  @HiveField( HiveConstant.Two)
  String? arUrl = "";*/
  @JsonKey(name: "is_ar")
  @HiveField(HiveConstant.Three)
  bool? isAr;
  @JsonKey(name: "product_id")
  @HiveField(HiveConstant.Four)
  int? productId;
  @HiveField(HiveConstant.Five)
  String? name;
  @HiveField(HiveConstant.Six)
  String? manufacturer;
  @JsonKey(name: "manufacturer_id")
  @HiveField(HiveConstant.Seven)
  String? manufacturerId;
  @HiveField(HiveConstant.Eight)
  String? model;
  @HiveField(HiveConstant.Nine)
  String? seller_name;
  @HiveField(HiveConstant.Ten)
  String? reward;
  @HiveField(HiveConstant.Eleven)
  String? points;

  @HiveField(HiveConstant.Twelve)
  String? stock;
  @HiveField(HiveConstant.Thirten)
  String? popup;
  @HiveField(HiveConstant.Fourteen)
  String? thumb;
  @JsonKey(name: "dominant_color")
  @HiveField(HiveConstant.Fifteen)
  String? dominantColor;
  @JsonKey(name: "wishlist_status")
  @HiveField(HiveConstant.Sixteen)
  bool? wishlistStatus;
  @HiveField(HiveConstant.Seventeen)
  List<Images>? images;
  @HiveField(HiveConstant.Eighteen)
  String? price;
  @HiveField(HiveConstant.Ninteen)
  dynamic? special;
  @JsonKey(name: "formatted_special")
  @HiveField(HiveConstant.Twenty)
  String? formattedSpecial;
  @HiveField(HiveConstant.TwentyOnee)
  String? tax;
  @HiveField(HiveConstant.TwentyTwo)
  List<Discount>? discounts;
  @HiveField(HiveConstant.TwentyThree)
  List<Option>? options;
  @HiveField(HiveConstant.TwentyFour)
  dynamic? quantity;
  @HiveField(HiveConstant.TwentyFive)
  dynamic? minimum;
  @JsonKey(name: "review_status")
  @HiveField(HiveConstant.TwentySix)
  String? reviewStatus;
  @JsonKey(name: "review_guest")
  @HiveField(HiveConstant.TwentyEight)
  bool? reviewGuest;
  @JsonKey(name: "customer_name")
  @HiveField(HiveConstant.TwentyNine)
  String? customerName;
  @HiveField(HiveConstant.Thirty)
  String? reviews;
  @HiveField(HiveConstant.ThirtyOne)
  double? rating;
  @JsonKey(name: "description")
  @HiveField(HiveConstant.ThirtyTwo)
  String? description;
  @JsonKey(name: "attribute_groups")
  @HiveField(HiveConstant.ThirtyThree)
  List<AttributeGroup>? attributeGroups;
  @HiveField(HiveConstant.ThirtyFour)
  @JsonKey(name: "relatedProducts")
  List<RelatedProduct>? relatedProducts;

  @HiveField(HiveConstant.ThirtyFive)
  List<dynamic>? tags;
  @HiveField(HiveConstant.ThirtySix)
  String? href;
  @JsonKey(name: "text_payment_recurring")
  @HiveField(HiveConstant.ThirtySeven)
  String? textPaymentRecurring;

  @HiveField(HiveConstant.ThirtyEight)
  List<dynamic>? recurrings;

  @JsonKey(name: "reviewData")
  @HiveField(HiveConstant.Fourty)
  ReviewData? reviewData;

  @JsonKey(name: "productPrev")
  @HiveField(HiveConstant.FourtyOne)
  List<ProductNext>? productPrev;

  @JsonKey(name: "productNext")
  @HiveField(HiveConstant.FourtyTwo)
  List<ProductNext>? productNext;
  @JsonKey(name: "out_of_stock_checkout")
  @HiveField(HiveConstant.FourtyThree)
  bool? outOfStockCheckout;

  @JsonKey(name: "gdpr_status")
  @HiveField(HiveConstant.FourtyFour)
  num? gdprStatus;

  @JsonKey(name: "gdpr_content")
  @HiveField(HiveConstant.FourtyFive)
  String? gdprContent;

  String? seller_id;

  ProductDetailScreenModel(
      {/*this.langArray,*/
      this.eTag,
      this.tabReview,
      /* this.arUrl,*/
      this.ios_ar,
      this.android_ar,
      this.isAr,
      this.productId,
      this.name,
      this.manufacturer,
      this.manufacturerId,
      this.model,
      this.seller_name,
      this.reward,
      this.points,
      this.stock,
      this.popup,
      this.thumb,
      this.dominantColor,
      this.wishlistStatus,
      this.images,
      this.price,
      this.special,
      this.formattedSpecial,
      this.tax,
      this.discounts,
      this.options,
      this.quantity,
      this.minimum,
      this.reviewStatus,
      this.reviewGuest,
      this.customerName,
      this.reviews,
      this.rating,
      this.description,
      this.attributeGroups,
      this.relatedProducts,
      this.tags,
      this.href,
      this.textPaymentRecurring,
      this.recurrings,
      this.reviewData,
      this.productPrev,
      this.productNext,
      this.seller_id,
      this.outOfStockCheckout});

  factory ProductDetailScreenModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailScreenModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailScreenModelToJson(this);
}

@JsonSerializable()
class LangArray {
  String? code;
  String? direction;
  String? dateFormatShort;
  String? dateFormatLong;
  String? timeFormat;
  String? datetimeFormat;
  String? decimalPoint;
  String? thousandPoint;
  String? textHome;
  String? textYes;
  String? textNo;
  String? textNone;
  String? textSelect;
  String? textAllZones;
  String? textPagination;
  String? textLoading;
  String? textNoResults;
  String? buttonAddressAdd;
  String? buttonBack;
  String? buttonContinue;
  String? buttonCart;
  String? buttonCancel;
  String? buttonCompare;
  String? buttonWishlist;
  String? buttonCheckout;
  String? buttonConfirm;
  String? buttonCoupon;
  String? buttonDelete;
  String? buttonDownload;
  String? buttonEdit;
  String? buttonFilter;
  String? buttonNewAddress;
  String? buttonChangeAddress;
  String? buttonReviews;
  String? buttonWrite;
  String? buttonLogin;
  String? buttonUpdate;
  String? buttonRemove;
  String? buttonReorder;
  String? buttonReturn;
  String? buttonShopping;
  String? buttonSearch;
  String? buttonShipping;
  String? buttonSubmit;
  String? buttonGuest;
  String? buttonView;
  String? buttonVoucher;
  String? buttonUpload;
  String? buttonReward;
  String? buttonQuote;
  String? buttonList;
  String? buttonGrid;
  String? buttonMap;
  String? errorException;
  String? errorUpload1;
  String? errorUpload2;
  String? errorUpload3;
  String? errorUpload4;
  String? errorUpload6;
  String? errorUpload7;
  String? errorUpload8;
  String? errorUpload999;
  String? errorCurl;
  String? textTokenMessage;
  String? textApiLogoutMessage;
  String? textApiLoginMessage;
  String? textLanguageMessage;
  String? textCustomerLoginMessage;
  String? textEditPasswordMessage;
  String? textCouponMessage;
  String? textVoucherMessage;
  String? textRewardMessage;
  String? textProductMessage;
  String? textKeyMessage;
  String? textUpdateCartMessage;
  String? textUpdateCartError;
  String? textOrderIdError;
  String? textOrderStatusIdError;
  String? textNotifyError;
  String? textSellerIdError;
  String? textSubjectError;
  String? textMessageError;
  String? textPathError;
  String? textAddressIdError;
  String? textLoginError;
  String? textCollectionMessage;
  String? textComplete;
  String? textPending;
  String? textNoData;
  String? textReturn;
  String? textVerify;
  String? textStockError;
  String? textPassword;
  String? textNoProduct;
  String? textSuccessDelete;
  String? textNoAddress;
  String? textMailSuccess;
  String? textCartClear;
  String? textFeatured;
  String? textBestSeller;
  String? textPopular;
  String? textLatest;
  String? textAll;
  String? orderNotificationTitle;
  String? orderNotificationDesc;
  String? orderNotificationOrderPlaced;
  String? orderNotificationOrderPlacedDesc;
  String? errorOwnProduct;
  String? textEmpty;
  String? textSearch;
  String? textBrand;
  String? textManufacturer;
  String? textModel;
  String? textReward;
  String? textPoints;
  String? textStock;
  String? textInstock;
  String? textTax;
  String? textDiscount;
  String? textOption;
  String? textMinimum;
  String? textReviews;
  String? textWrite;
  String? textLogin;
  String? textNoReviews;
  String? textNote;
  String? textSuccess;
  String? textRelated;
  String? textTags;
  String? textError;
  String? textPaymentRecurring;
  String? textTrialDescription;
  String? textPaymentDescription;
  String? textPaymentCancel;
  String? textDay;
  String? textWeek;
  String? textSemiMonth;
  String? textMonth;
  String? textYear;
  String? entryQty;
  String? entryName;
  String? entryReview;
  String? entryRating;
  String? entryGood;
  String? entryBad;
  String? tabDescription;
  String? tabAttribute;
  String? tabReview;
  String? errorName;
  String? errorText;
  String? errorRating;

  LangArray(
      {this.code,
      this.direction,
      this.dateFormatShort,
      this.dateFormatLong,
      this.timeFormat,
      this.datetimeFormat,
      this.decimalPoint,
      this.thousandPoint,
      this.textHome,
      this.textYes,
      this.textNo,
      this.textNone,
      this.textSelect,
      this.textAllZones,
      this.textPagination,
      this.textLoading,
      this.textNoResults,
      this.buttonAddressAdd,
      this.buttonBack,
      this.buttonContinue,
      this.buttonCart,
      this.buttonCancel,
      this.buttonCompare,
      this.buttonWishlist,
      this.buttonCheckout,
      this.buttonConfirm,
      this.buttonCoupon,
      this.buttonDelete,
      this.buttonDownload,
      this.buttonEdit,
      this.buttonFilter,
      this.buttonNewAddress,
      this.buttonChangeAddress,
      this.buttonReviews,
      this.buttonWrite,
      this.buttonLogin,
      this.buttonUpdate,
      this.buttonRemove,
      this.buttonReorder,
      this.buttonReturn,
      this.buttonShopping,
      this.buttonSearch,
      this.buttonShipping,
      this.buttonSubmit,
      this.buttonGuest,
      this.buttonView,
      this.buttonVoucher,
      this.buttonUpload,
      this.buttonReward,
      this.buttonQuote,
      this.buttonList,
      this.buttonGrid,
      this.buttonMap,
      this.errorException,
      this.errorUpload1,
      this.errorUpload2,
      this.errorUpload3,
      this.errorUpload4,
      this.errorUpload6,
      this.errorUpload7,
      this.errorUpload8,
      this.errorUpload999,
      this.errorCurl,
      this.textTokenMessage,
      this.textApiLogoutMessage,
      this.textApiLoginMessage,
      this.textLanguageMessage,
      this.textCustomerLoginMessage,
      this.textEditPasswordMessage,
      this.textCouponMessage,
      this.textVoucherMessage,
      this.textRewardMessage,
      this.textProductMessage,
      this.textKeyMessage,
      this.textUpdateCartMessage,
      this.textUpdateCartError,
      this.textOrderIdError,
      this.textOrderStatusIdError,
      this.textNotifyError,
      this.textSellerIdError,
      this.textSubjectError,
      this.textMessageError,
      this.textPathError,
      this.textAddressIdError,
      this.textLoginError,
      this.textCollectionMessage,
      this.textComplete,
      this.textPending,
      this.textNoData,
      this.textReturn,
      this.textVerify,
      this.textStockError,
      this.textPassword,
      this.textNoProduct,
      this.textSuccessDelete,
      this.textNoAddress,
      this.textMailSuccess,
      this.textCartClear,
      this.textFeatured,
      this.textBestSeller,
      this.textPopular,
      this.textLatest,
      this.textAll,
      this.orderNotificationTitle,
      this.orderNotificationDesc,
      this.orderNotificationOrderPlaced,
      this.orderNotificationOrderPlacedDesc,
      this.errorOwnProduct,
      this.textEmpty,
      this.textSearch,
      this.textBrand,
      this.textManufacturer,
      this.textModel,
      this.textReward,
      this.textPoints,
      this.textStock,
      this.textInstock,
      this.textTax,
      this.textDiscount,
      this.textOption,
      this.textMinimum,
      this.textReviews,
      this.textWrite,
      this.textLogin,
      this.textNoReviews,
      this.textNote,
      this.textSuccess,
      this.textRelated,
      this.textTags,
      this.textError,
      this.textPaymentRecurring,
      this.textTrialDescription,
      this.textPaymentDescription,
      this.textPaymentCancel,
      this.textDay,
      this.textWeek,
      this.textSemiMonth,
      this.textMonth,
      this.textYear,
      this.entryQty,
      this.entryName,
      this.entryReview,
      this.entryRating,
      this.entryGood,
      this.entryBad,
      this.tabDescription,
      this.tabAttribute,
      this.tabReview,
      this.errorName,
      this.errorText,
      this.errorRating});

  LangArray.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    direction = json['direction'];
    dateFormatShort = json['date_format_short'];
    dateFormatLong = json['date_format_long'];
    timeFormat = json['time_format'];
    datetimeFormat = json['datetime_format'];
    decimalPoint = json['decimal_point'];
    thousandPoint = json['thousand_point'];
    textHome = json['text_home'];
    textYes = json['text_yes'];
    textNo = json['text_no'];
    textNone = json['text_none'];
    textSelect = json['text_select'];
    textAllZones = json['text_all_zones'];
    textPagination = json['text_pagination'];
    textLoading = json['text_loading'];
    textNoResults = json['text_no_results'];
    buttonAddressAdd = json['button_address_add'];
    buttonBack = json['button_back'];
    buttonContinue = json['button_continue'];
    buttonCart = json['button_cart'];
    buttonCancel = json['button_cancel'];
    buttonCompare = json['button_compare'];
    buttonWishlist = json['button_wishlist'];
    buttonCheckout = json['button_checkout'];
    buttonConfirm = json['button_confirm'];
    buttonCoupon = json['button_coupon'];
    buttonDelete = json['button_delete'];
    buttonDownload = json['button_download'];
    buttonEdit = json['button_edit'];
    buttonFilter = json['button_filter'];
    buttonNewAddress = json['button_new_address'];
    buttonChangeAddress = json['button_change_address'];
    buttonReviews = json['button_reviews'];
    buttonWrite = json['button_write'];
    buttonLogin = json['button_login'];
    buttonUpdate = json['button_update'];
    buttonRemove = json['button_remove'];
    buttonReorder = json['button_reorder'];
    buttonReturn = json['button_return'];
    buttonShopping = json['button_shopping'];
    buttonSearch = json['button_search'];
    buttonShipping = json['button_shipping'];
    buttonSubmit = json['button_submit'];
    buttonGuest = json['button_guest'];
    buttonView = json['button_view'];
    buttonVoucher = json['button_voucher'];
    buttonUpload = json['button_upload'];
    buttonReward = json['button_reward'];
    buttonQuote = json['button_quote'];
    buttonList = json['button_list'];
    buttonGrid = json['button_grid'];
    buttonMap = json['button_map'];
    errorException = json['error_exception'];
    errorUpload1 = json['error_upload_1'];
    errorUpload2 = json['error_upload_2'];
    errorUpload3 = json['error_upload_3'];
    errorUpload4 = json['error_upload_4'];
    errorUpload6 = json['error_upload_6'];
    errorUpload7 = json['error_upload_7'];
    errorUpload8 = json['error_upload_8'];
    errorUpload999 = json['error_upload_999'];
    errorCurl = json['error_curl'];
    textTokenMessage = json['text_token_message'];
    textApiLogoutMessage = json['text_api_logout_message'];
    textApiLoginMessage = json['text_api_login_message'];
    textLanguageMessage = json['text_language_message'];
    textCustomerLoginMessage = json['text_customer_login_message'];
    textEditPasswordMessage = json['text_edit_password_message'];
    textCouponMessage = json['text_coupon_message'];
    textVoucherMessage = json['text_voucher_message'];
    textRewardMessage = json['text_reward_message'];
    textProductMessage = json['text_product_message'];
    textKeyMessage = json['text_key_message'];
    textUpdateCartMessage = json['text_update_cart_message'];
    textUpdateCartError = json['text_update_cart_error'];
    textOrderIdError = json['text_order_id_error'];
    textOrderStatusIdError = json['text_order_status_id_error'];
    textNotifyError = json['text_notify_error'];
    textSellerIdError = json['text_seller_id_error'];
    textSubjectError = json['text_subject_error'];
    textMessageError = json['text_message_error'];
    textPathError = json['text_path_error'];
    textAddressIdError = json['text_address_id_error'];
    textLoginError = json['text_login_error'];
    textCollectionMessage = json['text_collection_message'];
    textComplete = json['text_complete'];
    textPending = json['text_pending'];
    textNoData = json['text_no_data'];
    textReturn = json['text_return'];
    textVerify = json['text_verify'];
    textStockError = json['text_stock_error'];
    textPassword = json['text_password'];
    textNoProduct = json['text_no_product'];
    textSuccessDelete = json['text_success_delete'];
    textNoAddress = json['text_no_address'];
    textMailSuccess = json['text_mail_success'];
    textCartClear = json['text_cart_clear'];
    textFeatured = json['text_featured'];
    textBestSeller = json['text_best_seller'];
    textPopular = json['text_popular'];
    textLatest = json['text_latest'];
    textAll = json['text_all'];
    orderNotificationTitle = json['order_notification_title'];
    orderNotificationDesc = json['order_notification_desc'];
    orderNotificationOrderPlaced = json['order_notification_order_placed'];
    orderNotificationOrderPlacedDesc =
        json['order_notification_order_placed_desc'];
    errorOwnProduct = json['error_own_product'];
    textEmpty = json['text_empty'];
    textSearch = json['text_search'];
    textBrand = json['text_brand'];
    textManufacturer = json['text_manufacturer'];
    textModel = json['text_model'];
    textReward = json['text_reward'];
    textPoints = json['text_points'];
    textStock = json['text_stock'];
    textInstock = json['text_instock'];
    textTax = json['text_tax'];
    textDiscount = json['text_discount'];
    textOption = json['text_option'];
    textMinimum = json['text_minimum'];
    textReviews = json['text_reviews'];
    textWrite = json['text_write'];
    textLogin = json['text_login'];
    textNoReviews = json['text_no_reviews'];
    textNote = json['text_note'];
    textSuccess = json['text_success'];
    textRelated = json['text_related'];
    textTags = json['text_tags'];
    textError = json['text_error'];
    textPaymentRecurring = json['text_payment_recurring'];
    textTrialDescription = json['text_trial_description'];
    textPaymentDescription = json['text_payment_description'];
    textPaymentCancel = json['text_payment_cancel'];
    textDay = json['text_day'];
    textWeek = json['text_week'];
    textSemiMonth = json['text_semi_month'];
    textMonth = json['text_month'];
    textYear = json['text_year'];
    entryQty = json['entry_qty'];
    entryName = json['entry_name'];
    entryReview = json['entry_review'];
    entryRating = json['entry_rating'];
    entryGood = json['entry_good'];
    entryBad = json['entry_bad'];
    tabDescription = json['tab_description'];
    tabAttribute = json['tab_attribute'];
    tabReview = json['tab_review'];
    errorName = json['error_name'];
    errorText = json['error_text'];
    errorRating = json['error_rating'];
  }
  Map<String, dynamic> toJson() => _$LangArrayToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.Fourteen)
class Images {
  @HiveField(HiveConstant.One)
  String? popup;
  @HiveField(HiveConstant.Two)
  String? thumb;
  @HiveField(HiveConstant.Three)
  String? dominantColor;

  Images({this.popup, this.thumb, this.dominantColor});

  Images.fromJson(Map<String, dynamic> json) {
    popup = json['popup'];
    thumb = json['thumb'];
    dominantColor = json['dominant_color'];
  }
  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.Fifteen)
class Option {
  @HiveField(HiveConstant.One)
  String? productOptionId;
  @HiveField(HiveConstant.Two)
  List<ProductOptionValue>? productOptionValue;
  @HiveField(HiveConstant.Three)
  String? optionId;
  @HiveField(HiveConstant.Four)
  String? name;
  @HiveField(HiveConstant.Five)
  String? type;
  @HiveField(HiveConstant.Six)
  String? value;
  @HiveField(HiveConstant.Seven)
  String? required;

  Option(
      {this.productOptionId,
      this.productOptionValue,
      this.optionId,
      this.name,
      this.type,
      this.value,
      this.required});

  Option.fromJson(Map<String, dynamic> json) {
    productOptionId = json['product_option_id'];
    if (json['product_option_value'] != null) {
      productOptionValue = <ProductOptionValue>[];
      json['product_option_value'].forEach((v) {
        productOptionValue!.add(new ProductOptionValue.fromJson(v));
      });
    }
    optionId = json['option_id'];
    name = json['name'];
    type = json['type'];
    value = json['value'];
    required = json['required'];
  }
  Map<String, dynamic> toJson() => _$OptionToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.Sixteen)
class ProductOptionValue {
  @HiveField(HiveConstant.One)
  String? productOptionValueId;
  @HiveField(HiveConstant.Two)
  String? optionValueId;
  @HiveField(HiveConstant.Three)
  String? name;
  @HiveField(HiveConstant.Four)
  String? image;
  @HiveField(HiveConstant.Five)
  String? price;
  @HiveField(HiveConstant.Six)
  String? pricePrefix;
  @JsonKey(ignore: true)
  @HiveField(HiveConstant.Seven)
  bool? isSelected = false;

  ProductOptionValue(
      {this.productOptionValueId,
      this.optionValueId,
      this.name,
      this.image,
      this.price,
      this.pricePrefix});

  ProductOptionValue.fromJson(Map<String, dynamic> json) {
    productOptionValueId = json['product_option_value_id'];
    optionValueId = json['option_value_id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    pricePrefix = json['price_prefix'];
  }
  Map<String, dynamic> toJson() => _$ProductOptionValueToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.Seventeen)
class ReviewData {
  @HiveField(HiveConstant.One)
  String? textNoReviews;
  @HiveField(HiveConstant.Two)
  List<Reviews>? reviews;
  @HiveField(HiveConstant.Three)
  String? total;
  ReviewData({this.textNoReviews, this.reviews, this.total});

  ReviewData.fromJson(Map<String, dynamic> json) {
    textNoReviews = json['text_no_reviews'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
    total = json['total'];
  }
  Map<String, dynamic> toJson() => _$ReviewDataToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.Eighteen)
class Reviews {
  @HiveField(HiveConstant.One)
  String? author;
  @HiveField(HiveConstant.Two)
  String? text;
  @HiveField(HiveConstant.Three)
  int? rating;
  @HiveField(HiveConstant.Four)
  String? dateAdded;

  Reviews({this.author, this.text, this.rating, this.dateAdded});

  Reviews.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    text = json['text'];
    rating = json['rating'];
    dateAdded = json['date_added'];
  }
  Map<String, dynamic> toJson() => _$ReviewsToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.Ninteen)
class ProductNext {
  @HiveField(HiveConstant.One)
  String? productId;
  @HiveField(HiveConstant.Two)
  String? name;

  ProductNext({this.productId, this.name});

  ProductNext.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() => _$ProductNextToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.Twenty)
class Discount {
  @JsonKey(name: "quantity")
  @HiveField(HiveConstant.One)
  String? quantity;

  @JsonKey(name: "price")
  @HiveField(HiveConstant.Two)
  String? price;

  Discount({this.quantity, this.price});

  factory Discount.fromJson(Map<String, dynamic> json) =>
      _$DiscountFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.TwentyOnee)
class AttributeGroup {
  @JsonKey(name: "attribute_group_id")
  @HiveField(HiveConstant.One)
  String? attributeGroupId;

  @JsonKey(name: "name")
  @HiveField(HiveConstant.Two)
  String? name;
  @JsonKey(name: "attribute")
  @HiveField(HiveConstant.Three)
  List<Attribute>? attribute;

  AttributeGroup({this.attributeGroupId, this.name, this.attribute});

  factory AttributeGroup.fromJson(Map<String, dynamic> json) =>
      _$AttributeGroupFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeGroupToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.TwentyTwo)
class Attribute {
  @JsonKey(name: "attribute_id")
  @HiveField(HiveConstant.One)
  String? attributeId;

  @JsonKey(name: "name")
  @HiveField(HiveConstant.Two)
  String? name;
  @JsonKey(name: "text")
  @HiveField(HiveConstant.Three)
  String? text;

  Attribute({this.attributeId, this.name, this.text});

  factory Attribute.fromJson(Map<String, dynamic> json) =>
      _$AttributeFromJson(json);
  Map<String, dynamic> toJson() => _$AttributeToJson(this);
}

@JsonSerializable()
@HiveType(typeId: HiveConstant.TwentyThree)
class RelatedProduct {
  @HiveField(HiveConstant.One)
  String? productId;
  @HiveField(HiveConstant.Two)
  String? thumb;
  @HiveField(HiveConstant.Three)
  String? dominantColor;
  @HiveField(HiveConstant.Four)
  String? name;
  @HiveField(HiveConstant.Five)
  String? description;
  @HiveField(HiveConstant.Six)
  String? price;
  @HiveField(HiveConstant.Seven)
  int? special;
  @HiveField(HiveConstant.Eight)
  String? formattedSpecial;
  @HiveField(HiveConstant.Nine)
  String? tax;
  @HiveField(HiveConstant.Ten)
  bool? hasOption;
  @HiveField(HiveConstant.Eleven)
  String? stock;
  @HiveField(HiveConstant.Twelve)
  dynamic? minimum;
  @HiveField(HiveConstant.Thirten)
  int? rating;
  @HiveField(HiveConstant.Fourteen)
  String? href;
  @HiveField(HiveConstant.Fifteen)
  bool? wishlistStatus;

  RelatedProduct(
      {this.productId,
      this.thumb,
      this.dominantColor,
      this.name,
      this.description,
      this.price,
      this.special,
      this.formattedSpecial,
      this.tax,
      this.hasOption,
      this.stock,
      this.minimum,
      this.rating,
      this.href,
      this.wishlistStatus});

  RelatedProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    thumb = json['thumb'];
    dominantColor = json['dominant_color'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    special = json['special'];
    formattedSpecial = json['formatted_special'];
    tax = json['tax'];
    hasOption = json['hasOption'];
    stock = json['stock'];
    minimum = json['minimum'];
    rating = json['rating'];
    href = json['href'];
    wishlistStatus = json['wishlist_status'];
  }
  Map<String, dynamic> toJson() => _$RelatedProductToJson(this);
}
