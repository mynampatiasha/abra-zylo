// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartModel _$CartModelFromJson(Map<String, dynamic> json) => CartModel(
      cart: json['cart'] == null
          ? null
          : Cart.fromJson(json['cart'] as Map<String, dynamic>),
      wishlist: json['wishlist'] as int?,
      coupon: json['coupon'] == null
          ? null
          : Coupon.fromJson(json['coupon'] as Map<String, dynamic>),
      voucher: json['voucher'] == null
          ? null
          : Voucher.fromJson(json['voucher'] as Map<String, dynamic>),
      reward: json['reward'] == null
          ? null
          : Reward.fromJson(json['reward'] as Map<String, dynamic>),
      shipping: json['shipping'] as String?,
    );

Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
      'cart': instance.cart,
      'wishlist': instance.wishlist,
      'coupon': instance.coupon,
      'voucher': instance.voucher,
      'reward': instance.reward,
      'shipping': instance.shipping,
    };

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
      errorWarning: json['error_warning'] as String?,
      checkoutEligible: json['checkout_eligible'] as int?,
      voucherStatus: json['voucher_status'] as int?,
      couponStatus: json['coupon_status'] as int?,
      guestStatus: json['guest_status'] as bool?,
      downloadStatus: json['download_status'] as int?,
      checkout: json['checkout'],
      attention: json['attention'] as String?,
      success: json['success'] as String?,
      action: json['action'] as String?,
      weight: json['weight'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Products.fromJson(e as Map<String, dynamic>))
          .toList(),
      vouchers: json['vouchers'] as List<dynamic>?,
      totals: (json['totals'] as List<dynamic>?)
          ?.map((e) => Totals.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalProducts: json['total_products'] as int?,
    );

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'error_warning': instance.errorWarning,
      'checkout_eligible': instance.checkoutEligible,
      'voucher_status': instance.voucherStatus,
      'coupon_status': instance.couponStatus,
      'guest_status': instance.guestStatus,
      'download_status': instance.downloadStatus,
      'checkout': instance.checkout,
      'attention': instance.attention,
      'success': instance.success,
      'action': instance.action,
      'weight': instance.weight,
      'products': instance.products,
      'vouchers': instance.vouchers,
      'totals': instance.totals,
      'total_products': instance.totalProducts,
    };

Products _$ProductsFromJson(Map<String, dynamic> json) => Products(
      key: json['key'] as String?,
      thumb: json['thumb'] as String?,
      dominantColor: json['dominant_color'] as String?,
      name: json['name'] as String?,
      model: json['model'] as String?,
      option: (json['option'] as List<dynamic>?)
          ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
      recurring: json['recurring'] as String?,
      quantity: json['quantity'] as String?,
      stock: json['stock'] as bool?,
      reward: json['reward'] as String?,
      points: json['points'],
      price: json['price'] as String?,
      total: json['total'] as String?,
      productId: json['product_id'] as String?,
      wishlistStatus: json['wishlist_status'] as bool?,
    );

Map<String, dynamic> _$ProductsToJson(Products instance) => <String, dynamic>{
      'key': instance.key,
      'thumb': instance.thumb,
      'dominant_color': instance.dominantColor,
      'name': instance.name,
      'model': instance.model,
      'option': instance.option,
      'recurring': instance.recurring,
      'quantity': instance.quantity,
      'stock': instance.stock,
      'reward': instance.reward,
      'points': instance.points,
      'price': instance.price,
      'total': instance.total,
      'product_id': instance.productId,
      'wishlist_status': instance.wishlistStatus,
    };

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      name: json['name'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };

Totals _$TotalsFromJson(Map<String, dynamic> json) => Totals(
      title: json['title'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$TotalsToJson(Totals instance) => <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
    };

Coupon _$CouponFromJson(Map<String, dynamic> json) => Coupon(
      headingTitle: json['heading_title'] as String?,
      textLoading: json['text_loading'] as String?,
      entryCoupon: json['entry_coupon'] as String?,
      buttonCoupon: json['button_coupon'] as String?,
      coupon: json['coupon'] as String?,
    );

Map<String, dynamic> _$CouponToJson(Coupon instance) => <String, dynamic>{
      'heading_title': instance.headingTitle,
      'text_loading': instance.textLoading,
      'entry_coupon': instance.entryCoupon,
      'button_coupon': instance.buttonCoupon,
      'coupon': instance.coupon,
    };

Voucher _$VoucherFromJson(Map<String, dynamic> json) => Voucher(
      headingTitle: json['heading_title'] as String?,
      textLoading: json['text_loading'] as String?,
      entryVoucher: json['entry_voucher'] as String?,
      buttonVoucher: json['button_voucher'] as String?,
      voucher: json['voucher'] as String?,
    );

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'heading_title': instance.headingTitle,
      'text_loading': instance.textLoading,
      'entry_voucher': instance.entryVoucher,
      'button_voucher': instance.buttonVoucher,
      'voucher': instance.voucher,
    };

Reward _$RewardFromJson(Map<String, dynamic> json) => Reward(
      headingTitle: json['heading_title'] as String?,
      textLoading: json['text_loading'] as String?,
      entryReward: json['entry_reward'] as String?,
      buttonReward: json['button_reward'] as String?,
      reward: json['reward'],
    );

Map<String, dynamic> _$RewardToJson(Reward instance) => <String, dynamic>{
      'heading_title': instance.headingTitle,
      'text_loading': instance.textLoading,
      'entry_reward': instance.entryReward,
      'button_reward': instance.buttonReward,
      'reward': instance.reward,
    };
