import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  Cart? cart;
  int? wishlist;
  Coupon? coupon;
  Voucher? voucher;
  Reward? reward;
  String? shipping;

  CartModel(
      {this.cart,
      this.wishlist,
      this.coupon,
      this.voucher,
      this.reward,
      this.shipping});
  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  /* CartModel.fromJson(Map<String, dynamic> json) {
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
    wishlist = json['wishlist'];
    coupon =
    json['coupon'] != null ? new Coupon.fromJson(json['coupon']) : null;
    voucher =
    json['voucher'] != null ? new Voucher.fromJson(json['voucher']) : null;
    reward =
    json['reward'] != null ? new Reward.fromJson(json['reward']) : null;
    shipping = json['shipping'];
  }*/
}

@JsonSerializable()
class Cart {
  @JsonKey(name: "error_warning")
  String? errorWarning;
  @JsonKey(name: "checkout_eligible")
  int? checkoutEligible;
  @JsonKey(name: "voucher_status")
  int? voucherStatus;
  @JsonKey(name: "coupon_status")
  int? couponStatus;
  @JsonKey(name: "guest_status")
  bool? guestStatus;
  @JsonKey(name: "download_status")
  int? downloadStatus;
  @JsonKey(name: "checkout")
  dynamic? checkout;
  @JsonKey(name: "attention")
  String? attention;
  @JsonKey(name: "success")
  String? success;
  @JsonKey(name: "action")
  String? action;
  @JsonKey(name: "weight")
  String? weight;
  @JsonKey(name: "products")
  List<Products>? products;
  @JsonKey(name: "vouchers")
  List<dynamic>? vouchers;
  @JsonKey(name: "totals")
  List<Totals>? totals;
  @JsonKey(name: "total_products")
  int? totalProducts;

  Cart(
      {this.errorWarning,
      this.checkoutEligible,
      this.voucherStatus,
      this.couponStatus,
      this.guestStatus,
      this.downloadStatus,
      this.checkout,
      this.attention,
      this.success,
      this.action,
      this.weight,
      this.products,
      this.vouchers,
      this.totals,
      this.totalProducts});
  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  /* Cart.fromJson(Map<String, dynamic> json) {
    errorWarning = json['error_warning'];
    checkoutEligible = json['checkout_eligible'];
    voucherStatus = json['voucher_status'];
    couponStatus = json['coupon_status'];
    guestStatus = json['guest_status'];
    downloadStatus = json['download_status'];
    checkout = json['checkout'];
    attention = json['attention'];
    success = json['success'];
    action = json['action'];
    weight = json['weight'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    if (json['vouchers'] != null) {
      vouchers = <Null>[];
      json['vouchers'].forEach((v) {
        vouchers!.add(new Null.fromJson(v));
      });
    }
    if (json['totals'] != null) {
      totals = <Totals>[];
      json['totals'].forEach((v) {
        totals!.add(new Totals.fromJson(v));
      });
    }
    totalProducts = json['total_products'];
  }*/
}

@JsonSerializable()
class Products {
  String? key;
  String? thumb;
  @JsonKey(name: "dominant_color")
  String? dominantColor;
  String? name;
  String? model;
  List<Option>? option;
  String? recurring;
  String? quantity;
  bool? stock;
  String? reward;
  dynamic? points;
  String? price;
  String? total;
  @JsonKey(name: "product_id")
  String? productId;
  @JsonKey(name: "wishlist_status")
  bool? wishlistStatus;

  Products(
      {this.key,
      this.thumb,
      this.dominantColor,
      this.name,
      this.model,
      this.option,
      this.recurring,
      this.quantity,
      this.stock,
      this.reward,
      this.points,
      this.price,
      this.total,
      this.productId,
      this.wishlistStatus});
  factory Products.fromJson(Map<String, dynamic> json) =>
      _$ProductsFromJson(json);
/*  Products.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    thumb = json['thumb'];
    dominantColor = json['dominant_color'];
    name = json['name'];
    model = json['model'];
    if (json['option'] != null) {
      option = <Option>[];
      json['option'].forEach((v) {
        option!.add(new Option.fromJson(v));
      });
    }
    recurring = json['recurring'];
    quantity = json['quantity'];
    stock = json['stock'];
    reward = json['reward'];
    points = json['points'];
    price = json['price'];
    total = json['total'];
    productId = json['product_id'];
    wishlistStatus = json['wishlist_status'];
  }*/
}

@JsonSerializable()
class Option {
  String? name;
  String? value;

  Option({this.name, this.value});
  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
  /* Option.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }*/
}

@JsonSerializable()
class Totals {
  String? title;
  String? text;

  Totals({this.title, this.text});

  factory Totals.fromJson(Map<String, dynamic> json) => _$TotalsFromJson(json);
  /* Totals.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
  }*/
}

@JsonSerializable()
class Coupon {
  @JsonKey(name: "heading_title")
  String? headingTitle;
  @JsonKey(name: "text_loading")
  String? textLoading;
  @JsonKey(name: "entry_coupon")
  String? entryCoupon;
  @JsonKey(name: "button_coupon")
  String? buttonCoupon;
  @JsonKey(name: "coupon")
  String? coupon;

  Coupon(
      {this.headingTitle,
      this.textLoading,
      this.entryCoupon,
      this.buttonCoupon,
      this.coupon});
  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
/*
  Coupon.fromJson(Map<String, dynamic> json) {
    headingTitle = json['heading_title'];
    textLoading = json['text_loading'];
    entryCoupon = json['entry_coupon'];
    buttonCoupon = json['button_coupon'];
    coupon = json['coupon'];
  }
*/
}

@JsonSerializable()
class Voucher {
  @JsonKey(name: "heading_title")
  String? headingTitle;
  @JsonKey(name: "text_loading")
  String? textLoading;
  @JsonKey(name: "entry_voucher")
  String? entryVoucher;
  @JsonKey(name: "button_voucher")
  String? buttonVoucher;
  @JsonKey(name: "voucher")
  String? voucher;

  Voucher(
      {this.headingTitle,
      this.textLoading,
      this.entryVoucher,
      this.buttonVoucher,
      this.voucher});
  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);
  /*
  Voucher.fromJson(Map<String, dynamic> json) {
    headingTitle = json['heading_title'];
    textLoading = json['text_loading'];
    entryVoucher = json['entry_voucher'];
    buttonVoucher = json['button_voucher'];
    voucher = json['voucher'];
  }*/
}

@JsonSerializable()
class Reward {
  @JsonKey(name: "heading_title")
  String? headingTitle;
  @JsonKey(name: "text_loading")
  String? textLoading;
  @JsonKey(name: "entry_reward")
  String? entryReward;
  @JsonKey(name: "button_reward")
  String? buttonReward;
  @JsonKey(name: "reward")
  dynamic? reward;

  Reward(
      {this.headingTitle,
      this.textLoading,
      this.entryReward,
      this.buttonReward,
      this.reward});
  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);
/*  Reward.fromJson(Map<String, dynamic> json) {
    headingTitle = json['heading_title'];
    textLoading = json['text_loading'];
    entryReward = json['entry_reward'];
    buttonReward = json['button_reward'];
    reward = json['reward'];
  }*/
}
