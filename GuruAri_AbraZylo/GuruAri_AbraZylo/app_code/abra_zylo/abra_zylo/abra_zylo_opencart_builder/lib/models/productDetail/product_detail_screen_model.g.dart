// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_screen_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductDetailScreenModelAdapter
    extends TypeAdapter<ProductDetailScreenModel> {
  @override
  final int typeId = 12;

  @override
  ProductDetailScreenModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductDetailScreenModel(
      eTag: fields[100] as String?,
      tabReview: fields[1] as String?,
      ios_ar: fields[2] as String?,
      android_ar: fields[46] as String?,
      isAr: fields[3] as bool?,
      productId: fields[4] as int?,
      name: fields[5] as String?,
      manufacturer: fields[6] as String?,
      manufacturerId: fields[7] as String?,
      model: fields[8] as String?,
      seller_name: fields[9] as String?,
      reward: fields[10] as String?,
      points: fields[11] as String?,
      stock: fields[12] as String?,
      popup: fields[13] as String?,
      thumb: fields[14] as String?,
      dominantColor: fields[15] as String?,
      wishlistStatus: fields[16] as bool?,
      images: (fields[17] as List?)?.cast<Images>(),
      price: fields[18] as String?,
      special: fields[19] as dynamic,
      formattedSpecial: fields[20] as String?,
      tax: fields[21] as String?,
      discounts: (fields[22] as List?)?.cast<Discount>(),
      options: (fields[23] as List?)?.cast<Option>(),
      quantity: fields[24] as dynamic,
      minimum: fields[25] as dynamic,
      reviewStatus: fields[26] as String?,
      reviewGuest: fields[28] as bool?,
      customerName: fields[29] as String?,
      reviews: fields[30] as String?,
      rating: fields[31] as double?,
      description: fields[32] as String?,
      attributeGroups: (fields[33] as List?)?.cast<AttributeGroup>(),
      relatedProducts: (fields[34] as List?)?.cast<RelatedProduct>(),
      tags: (fields[35] as List?)?.cast<dynamic>(),
      href: fields[36] as String?,
      textPaymentRecurring: fields[37] as String?,
      recurrings: (fields[38] as List?)?.cast<dynamic>(),
      reviewData: fields[40] as ReviewData?,
      productPrev: (fields[41] as List?)?.cast<ProductNext>(),
      productNext: (fields[42] as List?)?.cast<ProductNext>(),
      outOfStockCheckout: fields[43] as bool?,
    )
      ..gdprStatus = fields[44] as num?
      ..gdprContent = fields[45] as String?;
  }

  @override
  void write(BinaryWriter writer, ProductDetailScreenModel obj) {
    writer
      ..writeByte(45)
      ..writeByte(100)
      ..write(obj.eTag)
      ..writeByte(1)
      ..write(obj.tabReview)
      ..writeByte(2)
      ..write(obj.ios_ar)
      ..writeByte(46)
      ..write(obj.android_ar)
      ..writeByte(3)
      ..write(obj.isAr)
      ..writeByte(4)
      ..write(obj.productId)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.manufacturer)
      ..writeByte(7)
      ..write(obj.manufacturerId)
      ..writeByte(8)
      ..write(obj.model)
      ..writeByte(9)
      ..write(obj.seller_name)
      ..writeByte(10)
      ..write(obj.reward)
      ..writeByte(11)
      ..write(obj.points)
      ..writeByte(12)
      ..write(obj.stock)
      ..writeByte(13)
      ..write(obj.popup)
      ..writeByte(14)
      ..write(obj.thumb)
      ..writeByte(15)
      ..write(obj.dominantColor)
      ..writeByte(16)
      ..write(obj.wishlistStatus)
      ..writeByte(17)
      ..write(obj.images)
      ..writeByte(18)
      ..write(obj.price)
      ..writeByte(19)
      ..write(obj.special)
      ..writeByte(20)
      ..write(obj.formattedSpecial)
      ..writeByte(21)
      ..write(obj.tax)
      ..writeByte(22)
      ..write(obj.discounts)
      ..writeByte(23)
      ..write(obj.options)
      ..writeByte(24)
      ..write(obj.quantity)
      ..writeByte(25)
      ..write(obj.minimum)
      ..writeByte(26)
      ..write(obj.reviewStatus)
      ..writeByte(28)
      ..write(obj.reviewGuest)
      ..writeByte(29)
      ..write(obj.customerName)
      ..writeByte(30)
      ..write(obj.reviews)
      ..writeByte(31)
      ..write(obj.rating)
      ..writeByte(32)
      ..write(obj.description)
      ..writeByte(33)
      ..write(obj.attributeGroups)
      ..writeByte(34)
      ..write(obj.relatedProducts)
      ..writeByte(35)
      ..write(obj.tags)
      ..writeByte(36)
      ..write(obj.href)
      ..writeByte(37)
      ..write(obj.textPaymentRecurring)
      ..writeByte(38)
      ..write(obj.recurrings)
      ..writeByte(40)
      ..write(obj.reviewData)
      ..writeByte(41)
      ..write(obj.productPrev)
      ..writeByte(42)
      ..write(obj.productNext)
      ..writeByte(43)
      ..write(obj.outOfStockCheckout)
      ..writeByte(44)
      ..write(obj.gdprStatus)
      ..writeByte(45)
      ..write(obj.gdprContent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDetailScreenModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImagesAdapter extends TypeAdapter<Images> {
  @override
  final int typeId = 14;

  @override
  Images read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Images(
      popup: fields[1] as String?,
      thumb: fields[2] as String?,
      dominantColor: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Images obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.popup)
      ..writeByte(2)
      ..write(obj.thumb)
      ..writeByte(3)
      ..write(obj.dominantColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OptionAdapter extends TypeAdapter<Option> {
  @override
  final int typeId = 15;

  @override
  Option read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Option(
      productOptionId: fields[1] as String?,
      productOptionValue: (fields[2] as List?)?.cast<ProductOptionValue>(),
      optionId: fields[3] as String?,
      name: fields[4] as String?,
      type: fields[5] as String?,
      value: fields[6] as String?,
      required: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Option obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.productOptionId)
      ..writeByte(2)
      ..write(obj.productOptionValue)
      ..writeByte(3)
      ..write(obj.optionId)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.value)
      ..writeByte(7)
      ..write(obj.required);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductOptionValueAdapter extends TypeAdapter<ProductOptionValue> {
  @override
  final int typeId = 16;

  @override
  ProductOptionValue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductOptionValue(
      productOptionValueId: fields[1] as String?,
      optionValueId: fields[2] as String?,
      name: fields[3] as String?,
      image: fields[4] as String?,
      price: fields[5] as String?,
      pricePrefix: fields[6] as String?,
    )..isSelected = fields[7] as bool?;
  }

  @override
  void write(BinaryWriter writer, ProductOptionValue obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.productOptionValueId)
      ..writeByte(2)
      ..write(obj.optionValueId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.pricePrefix)
      ..writeByte(7)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductOptionValueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewDataAdapter extends TypeAdapter<ReviewData> {
  @override
  final int typeId = 17;

  @override
  ReviewData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewData(
      textNoReviews: fields[1] as String?,
      reviews: (fields[2] as List?)?.cast<Reviews>(),
      total: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewData obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.textNoReviews)
      ..writeByte(2)
      ..write(obj.reviews)
      ..writeByte(3)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewsAdapter extends TypeAdapter<Reviews> {
  @override
  final int typeId = 18;

  @override
  Reviews read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reviews(
      author: fields[1] as String?,
      text: fields[2] as String?,
      rating: fields[3] as int?,
      dateAdded: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Reviews obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.dateAdded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductNextAdapter extends TypeAdapter<ProductNext> {
  @override
  final int typeId = 19;

  @override
  ProductNext read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductNext(
      productId: fields[1] as String?,
      name: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductNext obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductNextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DiscountAdapter extends TypeAdapter<Discount> {
  @override
  final int typeId = 20;

  @override
  Discount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Discount(
      quantity: fields[1] as String?,
      price: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Discount obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttributeGroupAdapter extends TypeAdapter<AttributeGroup> {
  @override
  final int typeId = 21;

  @override
  AttributeGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttributeGroup(
      attributeGroupId: fields[1] as String?,
      name: fields[2] as String?,
      attribute: (fields[3] as List?)?.cast<Attribute>(),
    );
  }

  @override
  void write(BinaryWriter writer, AttributeGroup obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.attributeGroupId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.attribute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttributeGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttributeAdapter extends TypeAdapter<Attribute> {
  @override
  final int typeId = 22;

  @override
  Attribute read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attribute(
      attributeId: fields[1] as String?,
      name: fields[2] as String?,
      text: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Attribute obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.attributeId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttributeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RelatedProductAdapter extends TypeAdapter<RelatedProduct> {
  @override
  final int typeId = 23;

  @override
  RelatedProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RelatedProduct(
      productId: fields[1] as String?,
      thumb: fields[2] as String?,
      dominantColor: fields[3] as String?,
      name: fields[4] as String?,
      description: fields[5] as String?,
      price: fields[6] as String?,
      special: fields[7] as int?,
      formattedSpecial: fields[8] as String?,
      tax: fields[9] as String?,
      hasOption: fields[10] as bool?,
      stock: fields[11] as String?,
      minimum: fields[12] as dynamic,
      rating: fields[13] as int?,
      href: fields[14] as String?,
      wishlistStatus: fields[15] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, RelatedProduct obj) {
    writer
      ..writeByte(15)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.thumb)
      ..writeByte(3)
      ..write(obj.dominantColor)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.special)
      ..writeByte(8)
      ..write(obj.formattedSpecial)
      ..writeByte(9)
      ..write(obj.tax)
      ..writeByte(10)
      ..write(obj.hasOption)
      ..writeByte(11)
      ..write(obj.stock)
      ..writeByte(12)
      ..write(obj.minimum)
      ..writeByte(13)
      ..write(obj.rating)
      ..writeByte(14)
      ..write(obj.href)
      ..writeByte(15)
      ..write(obj.wishlistStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelatedProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetailScreenModel _$ProductDetailScreenModelFromJson(
        Map<String, dynamic> json) =>
    ProductDetailScreenModel(
      eTag: json['etag'] as String?,
      tabReview: json['tab_review'] as String?,
      ios_ar: json['ios_url'] as String?,
      android_ar: json['android_url'] as String?,
      isAr: json['is_ar'] as bool?,
      productId: json['product_id'] as int?,
      name: json['name'] as String?,
      manufacturer: json['manufacturer'] as String?,
      manufacturerId: json['manufacturer_id'] as String?,
      model: json['model'] as String?,
      seller_name: json['seller_name'] as String?,
      reward: json['reward'] as String?,
      points: json['points'] as String?,
      stock: json['stock'] as String?,
      popup: json['popup'] as String?,
      thumb: json['thumb'] as String?,
      dominantColor: json['dominant_color'] as String?,
      wishlistStatus: json['wishlist_status'] as bool?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: json['price'] as String?,
      special: json['special'],
      formattedSpecial: json['formatted_special'] as String?,
      tax: json['tax'] as String?,
      discounts: (json['discounts'] as List<dynamic>?)
          ?.map((e) => Discount.fromJson(e as Map<String, dynamic>))
          .toList(),
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
      quantity: json['quantity'],
      minimum: json['minimum'],
      reviewStatus: json['review_status'] as String?,
      reviewGuest: json['review_guest'] as bool?,
      customerName: json['customer_name'] as String?,
      reviews: json['reviews'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      description: json['description'] as String?,
      attributeGroups: (json['attribute_groups'] as List<dynamic>?)
          ?.map((e) => AttributeGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      relatedProducts: (json['relatedProducts'] as List<dynamic>?)
          ?.map((e) => RelatedProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: json['tags'] as List<dynamic>?,
      href: json['href'] as String?,
      textPaymentRecurring: json['text_payment_recurring'] as String?,
      recurrings: json['recurrings'] as List<dynamic>?,
      reviewData: json['reviewData'] == null
          ? null
          : ReviewData.fromJson(json['reviewData'] as Map<String, dynamic>),
      productPrev: (json['productPrev'] as List<dynamic>?)
          ?.map((e) => ProductNext.fromJson(e as Map<String, dynamic>))
          .toList(),
      productNext: (json['productNext'] as List<dynamic>?)
          ?.map((e) => ProductNext.fromJson(e as Map<String, dynamic>))
          .toList(),
      seller_id: json['seller_id'] as String?,
      outOfStockCheckout: json['out_of_stock_checkout'] as bool?,
    )
      ..gdprStatus = json['gdpr_status'] as num?
      ..gdprContent = json['gdpr_content'] as String?;

Map<String, dynamic> _$ProductDetailScreenModelToJson(
        ProductDetailScreenModel instance) =>
    <String, dynamic>{
      'etag': instance.eTag,
      'tab_review': instance.tabReview,
      'ios_url': instance.ios_ar,
      'android_url': instance.android_ar,
      'is_ar': instance.isAr,
      'product_id': instance.productId,
      'name': instance.name,
      'manufacturer': instance.manufacturer,
      'manufacturer_id': instance.manufacturerId,
      'model': instance.model,
      'seller_name': instance.seller_name,
      'reward': instance.reward,
      'points': instance.points,
      'stock': instance.stock,
      'popup': instance.popup,
      'thumb': instance.thumb,
      'dominant_color': instance.dominantColor,
      'wishlist_status': instance.wishlistStatus,
      'images': instance.images,
      'price': instance.price,
      'special': instance.special,
      'formatted_special': instance.formattedSpecial,
      'tax': instance.tax,
      'discounts': instance.discounts,
      'options': instance.options,
      'quantity': instance.quantity,
      'minimum': instance.minimum,
      'review_status': instance.reviewStatus,
      'review_guest': instance.reviewGuest,
      'customer_name': instance.customerName,
      'reviews': instance.reviews,
      'rating': instance.rating,
      'description': instance.description,
      'attribute_groups': instance.attributeGroups,
      'relatedProducts': instance.relatedProducts,
      'tags': instance.tags,
      'href': instance.href,
      'text_payment_recurring': instance.textPaymentRecurring,
      'recurrings': instance.recurrings,
      'reviewData': instance.reviewData,
      'productPrev': instance.productPrev,
      'productNext': instance.productNext,
      'out_of_stock_checkout': instance.outOfStockCheckout,
      'gdpr_status': instance.gdprStatus,
      'gdpr_content': instance.gdprContent,
      'seller_id': instance.seller_id,
    };

LangArray _$LangArrayFromJson(Map<String, dynamic> json) => LangArray(
      code: json['code'] as String?,
      direction: json['direction'] as String?,
      dateFormatShort: json['dateFormatShort'] as String?,
      dateFormatLong: json['dateFormatLong'] as String?,
      timeFormat: json['timeFormat'] as String?,
      datetimeFormat: json['datetimeFormat'] as String?,
      decimalPoint: json['decimalPoint'] as String?,
      thousandPoint: json['thousandPoint'] as String?,
      textHome: json['textHome'] as String?,
      textYes: json['textYes'] as String?,
      textNo: json['textNo'] as String?,
      textNone: json['textNone'] as String?,
      textSelect: json['textSelect'] as String?,
      textAllZones: json['textAllZones'] as String?,
      textPagination: json['textPagination'] as String?,
      textLoading: json['textLoading'] as String?,
      textNoResults: json['textNoResults'] as String?,
      buttonAddressAdd: json['buttonAddressAdd'] as String?,
      buttonBack: json['buttonBack'] as String?,
      buttonContinue: json['buttonContinue'] as String?,
      buttonCart: json['buttonCart'] as String?,
      buttonCancel: json['buttonCancel'] as String?,
      buttonCompare: json['buttonCompare'] as String?,
      buttonWishlist: json['buttonWishlist'] as String?,
      buttonCheckout: json['buttonCheckout'] as String?,
      buttonConfirm: json['buttonConfirm'] as String?,
      buttonCoupon: json['buttonCoupon'] as String?,
      buttonDelete: json['buttonDelete'] as String?,
      buttonDownload: json['buttonDownload'] as String?,
      buttonEdit: json['buttonEdit'] as String?,
      buttonFilter: json['buttonFilter'] as String?,
      buttonNewAddress: json['buttonNewAddress'] as String?,
      buttonChangeAddress: json['buttonChangeAddress'] as String?,
      buttonReviews: json['buttonReviews'] as String?,
      buttonWrite: json['buttonWrite'] as String?,
      buttonLogin: json['buttonLogin'] as String?,
      buttonUpdate: json['buttonUpdate'] as String?,
      buttonRemove: json['buttonRemove'] as String?,
      buttonReorder: json['buttonReorder'] as String?,
      buttonReturn: json['buttonReturn'] as String?,
      buttonShopping: json['buttonShopping'] as String?,
      buttonSearch: json['buttonSearch'] as String?,
      buttonShipping: json['buttonShipping'] as String?,
      buttonSubmit: json['buttonSubmit'] as String?,
      buttonGuest: json['buttonGuest'] as String?,
      buttonView: json['buttonView'] as String?,
      buttonVoucher: json['buttonVoucher'] as String?,
      buttonUpload: json['buttonUpload'] as String?,
      buttonReward: json['buttonReward'] as String?,
      buttonQuote: json['buttonQuote'] as String?,
      buttonList: json['buttonList'] as String?,
      buttonGrid: json['buttonGrid'] as String?,
      buttonMap: json['buttonMap'] as String?,
      errorException: json['errorException'] as String?,
      errorUpload1: json['errorUpload1'] as String?,
      errorUpload2: json['errorUpload2'] as String?,
      errorUpload3: json['errorUpload3'] as String?,
      errorUpload4: json['errorUpload4'] as String?,
      errorUpload6: json['errorUpload6'] as String?,
      errorUpload7: json['errorUpload7'] as String?,
      errorUpload8: json['errorUpload8'] as String?,
      errorUpload999: json['errorUpload999'] as String?,
      errorCurl: json['errorCurl'] as String?,
      textTokenMessage: json['textTokenMessage'] as String?,
      textApiLogoutMessage: json['textApiLogoutMessage'] as String?,
      textApiLoginMessage: json['textApiLoginMessage'] as String?,
      textLanguageMessage: json['textLanguageMessage'] as String?,
      textCustomerLoginMessage: json['textCustomerLoginMessage'] as String?,
      textEditPasswordMessage: json['textEditPasswordMessage'] as String?,
      textCouponMessage: json['textCouponMessage'] as String?,
      textVoucherMessage: json['textVoucherMessage'] as String?,
      textRewardMessage: json['textRewardMessage'] as String?,
      textProductMessage: json['textProductMessage'] as String?,
      textKeyMessage: json['textKeyMessage'] as String?,
      textUpdateCartMessage: json['textUpdateCartMessage'] as String?,
      textUpdateCartError: json['textUpdateCartError'] as String?,
      textOrderIdError: json['textOrderIdError'] as String?,
      textOrderStatusIdError: json['textOrderStatusIdError'] as String?,
      textNotifyError: json['textNotifyError'] as String?,
      textSellerIdError: json['textSellerIdError'] as String?,
      textSubjectError: json['textSubjectError'] as String?,
      textMessageError: json['textMessageError'] as String?,
      textPathError: json['textPathError'] as String?,
      textAddressIdError: json['textAddressIdError'] as String?,
      textLoginError: json['textLoginError'] as String?,
      textCollectionMessage: json['textCollectionMessage'] as String?,
      textComplete: json['textComplete'] as String?,
      textPending: json['textPending'] as String?,
      textNoData: json['textNoData'] as String?,
      textReturn: json['textReturn'] as String?,
      textVerify: json['textVerify'] as String?,
      textStockError: json['textStockError'] as String?,
      textPassword: json['textPassword'] as String?,
      textNoProduct: json['textNoProduct'] as String?,
      textSuccessDelete: json['textSuccessDelete'] as String?,
      textNoAddress: json['textNoAddress'] as String?,
      textMailSuccess: json['textMailSuccess'] as String?,
      textCartClear: json['textCartClear'] as String?,
      textFeatured: json['textFeatured'] as String?,
      textBestSeller: json['textBestSeller'] as String?,
      textPopular: json['textPopular'] as String?,
      textLatest: json['textLatest'] as String?,
      textAll: json['textAll'] as String?,
      orderNotificationTitle: json['orderNotificationTitle'] as String?,
      orderNotificationDesc: json['orderNotificationDesc'] as String?,
      orderNotificationOrderPlaced:
          json['orderNotificationOrderPlaced'] as String?,
      orderNotificationOrderPlacedDesc:
          json['orderNotificationOrderPlacedDesc'] as String?,
      errorOwnProduct: json['errorOwnProduct'] as String?,
      textEmpty: json['textEmpty'] as String?,
      textSearch: json['textSearch'] as String?,
      textBrand: json['textBrand'] as String?,
      textManufacturer: json['textManufacturer'] as String?,
      textModel: json['textModel'] as String?,
      textReward: json['textReward'] as String?,
      textPoints: json['textPoints'] as String?,
      textStock: json['textStock'] as String?,
      textInstock: json['textInstock'] as String?,
      textTax: json['textTax'] as String?,
      textDiscount: json['textDiscount'] as String?,
      textOption: json['textOption'] as String?,
      textMinimum: json['textMinimum'] as String?,
      textReviews: json['textReviews'] as String?,
      textWrite: json['textWrite'] as String?,
      textLogin: json['textLogin'] as String?,
      textNoReviews: json['textNoReviews'] as String?,
      textNote: json['textNote'] as String?,
      textSuccess: json['textSuccess'] as String?,
      textRelated: json['textRelated'] as String?,
      textTags: json['textTags'] as String?,
      textError: json['textError'] as String?,
      textPaymentRecurring: json['textPaymentRecurring'] as String?,
      textTrialDescription: json['textTrialDescription'] as String?,
      textPaymentDescription: json['textPaymentDescription'] as String?,
      textPaymentCancel: json['textPaymentCancel'] as String?,
      textDay: json['textDay'] as String?,
      textWeek: json['textWeek'] as String?,
      textSemiMonth: json['textSemiMonth'] as String?,
      textMonth: json['textMonth'] as String?,
      textYear: json['textYear'] as String?,
      entryQty: json['entryQty'] as String?,
      entryName: json['entryName'] as String?,
      entryReview: json['entryReview'] as String?,
      entryRating: json['entryRating'] as String?,
      entryGood: json['entryGood'] as String?,
      entryBad: json['entryBad'] as String?,
      tabDescription: json['tabDescription'] as String?,
      tabAttribute: json['tabAttribute'] as String?,
      tabReview: json['tabReview'] as String?,
      errorName: json['errorName'] as String?,
      errorText: json['errorText'] as String?,
      errorRating: json['errorRating'] as String?,
    );

Map<String, dynamic> _$LangArrayToJson(LangArray instance) => <String, dynamic>{
      'code': instance.code,
      'direction': instance.direction,
      'dateFormatShort': instance.dateFormatShort,
      'dateFormatLong': instance.dateFormatLong,
      'timeFormat': instance.timeFormat,
      'datetimeFormat': instance.datetimeFormat,
      'decimalPoint': instance.decimalPoint,
      'thousandPoint': instance.thousandPoint,
      'textHome': instance.textHome,
      'textYes': instance.textYes,
      'textNo': instance.textNo,
      'textNone': instance.textNone,
      'textSelect': instance.textSelect,
      'textAllZones': instance.textAllZones,
      'textPagination': instance.textPagination,
      'textLoading': instance.textLoading,
      'textNoResults': instance.textNoResults,
      'buttonAddressAdd': instance.buttonAddressAdd,
      'buttonBack': instance.buttonBack,
      'buttonContinue': instance.buttonContinue,
      'buttonCart': instance.buttonCart,
      'buttonCancel': instance.buttonCancel,
      'buttonCompare': instance.buttonCompare,
      'buttonWishlist': instance.buttonWishlist,
      'buttonCheckout': instance.buttonCheckout,
      'buttonConfirm': instance.buttonConfirm,
      'buttonCoupon': instance.buttonCoupon,
      'buttonDelete': instance.buttonDelete,
      'buttonDownload': instance.buttonDownload,
      'buttonEdit': instance.buttonEdit,
      'buttonFilter': instance.buttonFilter,
      'buttonNewAddress': instance.buttonNewAddress,
      'buttonChangeAddress': instance.buttonChangeAddress,
      'buttonReviews': instance.buttonReviews,
      'buttonWrite': instance.buttonWrite,
      'buttonLogin': instance.buttonLogin,
      'buttonUpdate': instance.buttonUpdate,
      'buttonRemove': instance.buttonRemove,
      'buttonReorder': instance.buttonReorder,
      'buttonReturn': instance.buttonReturn,
      'buttonShopping': instance.buttonShopping,
      'buttonSearch': instance.buttonSearch,
      'buttonShipping': instance.buttonShipping,
      'buttonSubmit': instance.buttonSubmit,
      'buttonGuest': instance.buttonGuest,
      'buttonView': instance.buttonView,
      'buttonVoucher': instance.buttonVoucher,
      'buttonUpload': instance.buttonUpload,
      'buttonReward': instance.buttonReward,
      'buttonQuote': instance.buttonQuote,
      'buttonList': instance.buttonList,
      'buttonGrid': instance.buttonGrid,
      'buttonMap': instance.buttonMap,
      'errorException': instance.errorException,
      'errorUpload1': instance.errorUpload1,
      'errorUpload2': instance.errorUpload2,
      'errorUpload3': instance.errorUpload3,
      'errorUpload4': instance.errorUpload4,
      'errorUpload6': instance.errorUpload6,
      'errorUpload7': instance.errorUpload7,
      'errorUpload8': instance.errorUpload8,
      'errorUpload999': instance.errorUpload999,
      'errorCurl': instance.errorCurl,
      'textTokenMessage': instance.textTokenMessage,
      'textApiLogoutMessage': instance.textApiLogoutMessage,
      'textApiLoginMessage': instance.textApiLoginMessage,
      'textLanguageMessage': instance.textLanguageMessage,
      'textCustomerLoginMessage': instance.textCustomerLoginMessage,
      'textEditPasswordMessage': instance.textEditPasswordMessage,
      'textCouponMessage': instance.textCouponMessage,
      'textVoucherMessage': instance.textVoucherMessage,
      'textRewardMessage': instance.textRewardMessage,
      'textProductMessage': instance.textProductMessage,
      'textKeyMessage': instance.textKeyMessage,
      'textUpdateCartMessage': instance.textUpdateCartMessage,
      'textUpdateCartError': instance.textUpdateCartError,
      'textOrderIdError': instance.textOrderIdError,
      'textOrderStatusIdError': instance.textOrderStatusIdError,
      'textNotifyError': instance.textNotifyError,
      'textSellerIdError': instance.textSellerIdError,
      'textSubjectError': instance.textSubjectError,
      'textMessageError': instance.textMessageError,
      'textPathError': instance.textPathError,
      'textAddressIdError': instance.textAddressIdError,
      'textLoginError': instance.textLoginError,
      'textCollectionMessage': instance.textCollectionMessage,
      'textComplete': instance.textComplete,
      'textPending': instance.textPending,
      'textNoData': instance.textNoData,
      'textReturn': instance.textReturn,
      'textVerify': instance.textVerify,
      'textStockError': instance.textStockError,
      'textPassword': instance.textPassword,
      'textNoProduct': instance.textNoProduct,
      'textSuccessDelete': instance.textSuccessDelete,
      'textNoAddress': instance.textNoAddress,
      'textMailSuccess': instance.textMailSuccess,
      'textCartClear': instance.textCartClear,
      'textFeatured': instance.textFeatured,
      'textBestSeller': instance.textBestSeller,
      'textPopular': instance.textPopular,
      'textLatest': instance.textLatest,
      'textAll': instance.textAll,
      'orderNotificationTitle': instance.orderNotificationTitle,
      'orderNotificationDesc': instance.orderNotificationDesc,
      'orderNotificationOrderPlaced': instance.orderNotificationOrderPlaced,
      'orderNotificationOrderPlacedDesc':
          instance.orderNotificationOrderPlacedDesc,
      'errorOwnProduct': instance.errorOwnProduct,
      'textEmpty': instance.textEmpty,
      'textSearch': instance.textSearch,
      'textBrand': instance.textBrand,
      'textManufacturer': instance.textManufacturer,
      'textModel': instance.textModel,
      'textReward': instance.textReward,
      'textPoints': instance.textPoints,
      'textStock': instance.textStock,
      'textInstock': instance.textInstock,
      'textTax': instance.textTax,
      'textDiscount': instance.textDiscount,
      'textOption': instance.textOption,
      'textMinimum': instance.textMinimum,
      'textReviews': instance.textReviews,
      'textWrite': instance.textWrite,
      'textLogin': instance.textLogin,
      'textNoReviews': instance.textNoReviews,
      'textNote': instance.textNote,
      'textSuccess': instance.textSuccess,
      'textRelated': instance.textRelated,
      'textTags': instance.textTags,
      'textError': instance.textError,
      'textPaymentRecurring': instance.textPaymentRecurring,
      'textTrialDescription': instance.textTrialDescription,
      'textPaymentDescription': instance.textPaymentDescription,
      'textPaymentCancel': instance.textPaymentCancel,
      'textDay': instance.textDay,
      'textWeek': instance.textWeek,
      'textSemiMonth': instance.textSemiMonth,
      'textMonth': instance.textMonth,
      'textYear': instance.textYear,
      'entryQty': instance.entryQty,
      'entryName': instance.entryName,
      'entryReview': instance.entryReview,
      'entryRating': instance.entryRating,
      'entryGood': instance.entryGood,
      'entryBad': instance.entryBad,
      'tabDescription': instance.tabDescription,
      'tabAttribute': instance.tabAttribute,
      'tabReview': instance.tabReview,
      'errorName': instance.errorName,
      'errorText': instance.errorText,
      'errorRating': instance.errorRating,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      popup: json['popup'] as String?,
      thumb: json['thumb'] as String?,
      dominantColor: json['dominantColor'] as String?,
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'popup': instance.popup,
      'thumb': instance.thumb,
      'dominantColor': instance.dominantColor,
    };

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      productOptionId: json['productOptionId'] as String?,
      productOptionValue: (json['productOptionValue'] as List<dynamic>?)
          ?.map((e) => ProductOptionValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      optionId: json['optionId'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      value: json['value'] as String?,
      required: json['required'] as String?,
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'productOptionId': instance.productOptionId,
      'productOptionValue': instance.productOptionValue,
      'optionId': instance.optionId,
      'name': instance.name,
      'type': instance.type,
      'value': instance.value,
      'required': instance.required,
    };

ProductOptionValue _$ProductOptionValueFromJson(Map<String, dynamic> json) =>
    ProductOptionValue(
      productOptionValueId: json['productOptionValueId'] as String?,
      optionValueId: json['optionValueId'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      price: json['price'] as String?,
      pricePrefix: json['pricePrefix'] as String?,
    );

Map<String, dynamic> _$ProductOptionValueToJson(ProductOptionValue instance) =>
    <String, dynamic>{
      'productOptionValueId': instance.productOptionValueId,
      'optionValueId': instance.optionValueId,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'pricePrefix': instance.pricePrefix,
    };

ReviewData _$ReviewDataFromJson(Map<String, dynamic> json) => ReviewData(
      textNoReviews: json['textNoReviews'] as String?,
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Reviews.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as String?,
    );

Map<String, dynamic> _$ReviewDataToJson(ReviewData instance) =>
    <String, dynamic>{
      'textNoReviews': instance.textNoReviews,
      'reviews': instance.reviews,
      'total': instance.total,
    };

Reviews _$ReviewsFromJson(Map<String, dynamic> json) => Reviews(
      author: json['author'] as String?,
      text: json['text'] as String?,
      rating: json['rating'] as int?,
      dateAdded: json['dateAdded'] as String?,
    );

Map<String, dynamic> _$ReviewsToJson(Reviews instance) => <String, dynamic>{
      'author': instance.author,
      'text': instance.text,
      'rating': instance.rating,
      'dateAdded': instance.dateAdded,
    };

ProductNext _$ProductNextFromJson(Map<String, dynamic> json) => ProductNext(
      productId: json['productId'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ProductNextToJson(ProductNext instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
    };

Discount _$DiscountFromJson(Map<String, dynamic> json) => Discount(
      quantity: json['quantity'] as String?,
      price: json['price'] as String?,
    );

Map<String, dynamic> _$DiscountToJson(Discount instance) => <String, dynamic>{
      'quantity': instance.quantity,
      'price': instance.price,
    };

AttributeGroup _$AttributeGroupFromJson(Map<String, dynamic> json) =>
    AttributeGroup(
      attributeGroupId: json['attribute_group_id'] as String?,
      name: json['name'] as String?,
      attribute: (json['attribute'] as List<dynamic>?)
          ?.map((e) => Attribute.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttributeGroupToJson(AttributeGroup instance) =>
    <String, dynamic>{
      'attribute_group_id': instance.attributeGroupId,
      'name': instance.name,
      'attribute': instance.attribute,
    };

Attribute _$AttributeFromJson(Map<String, dynamic> json) => Attribute(
      attributeId: json['attribute_id'] as String?,
      name: json['name'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$AttributeToJson(Attribute instance) => <String, dynamic>{
      'attribute_id': instance.attributeId,
      'name': instance.name,
      'text': instance.text,
    };

RelatedProduct _$RelatedProductFromJson(Map<String, dynamic> json) =>
    RelatedProduct(
      productId: json['productId'] as String?,
      thumb: json['thumb'] as String?,
      dominantColor: json['dominantColor'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price'] as String?,
      special: json['special'] as int?,
      formattedSpecial: json['formattedSpecial'] as String?,
      tax: json['tax'] as String?,
      hasOption: json['hasOption'] as bool?,
      stock: json['stock'] as String?,
      minimum: json['minimum'],
      rating: json['rating'] as int?,
      href: json['href'] as String?,
      wishlistStatus: json['wishlistStatus'] as bool?,
    );

Map<String, dynamic> _$RelatedProductToJson(RelatedProduct instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'thumb': instance.thumb,
      'dominantColor': instance.dominantColor,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'special': instance.special,
      'formattedSpecial': instance.formattedSpecial,
      'tax': instance.tax,
      'hasOption': instance.hasOption,
      'stock': instance.stock,
      'minimum': instance.minimum,
      'rating': instance.rating,
      'href': instance.href,
      'wishlistStatus': instance.wishlistStatus,
    };
