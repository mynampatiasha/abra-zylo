// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_screen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomePageData _$HomePageDataFromJson(Map<String, dynamic> json) => HomePageData(
      guestStatus: json['guestStatus'] as bool?,
      partner: json['partner'] as int?,
      partnerApproveRequired: json['partnerApproveRequired'] as bool?,
      home_sequence: (json['home_sequence'] as List<dynamic>?)
          ?.map((e) => HomeSequenceElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      banners: (json['banners'] as List<dynamic>?)
          ?.map((e) => Banners.fromJson(e as Map<String, dynamic>))
          .toList(),
      carousels: (json['carousels'] as List<dynamic>?)
          ?.map((e) => Carousels.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Categories.fromJson(e as Map<String, dynamic>))
          .toList(),
      languages: json['languages'] == null
          ? null
          : Languages.fromJson(json['languages'] as Map<String, dynamic>),
      currencies: json['currencies'] == null
          ? null
          : Currencies.fromJson(json['currencies'] as Map<String, dynamic>),
      cart: json['cart'] as int?,
      language: json['language'] as String?,
      footerMenu: (json['footerMenu'] as List<dynamic>?)
          ?.map((e) => FooterMenu.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..fault = json['fault'] as int?
      ..message = json['message'] as String?
      ..error = json['error'] as int?
      ..redirect = json['redirect'] as String?
      ..newsletter = json['newsletter']
      ..cartTotal = json['total'];

Map<String, dynamic> _$HomePageDataToJson(HomePageData instance) =>
    <String, dynamic>{
      'fault': instance.fault,
      'message': instance.message,
      'error': instance.error,
      'redirect': instance.redirect,
      'newsletter': instance.newsletter,
      'total': instance.cartTotal,
      'guestStatus': instance.guestStatus,
      'partner': instance.partner,
      'partnerApproveRequired': instance.partnerApproveRequired,
      'home_sequence': instance.home_sequence,
      'banners': instance.banners,
      'carousels': instance.carousels,
      'categories': instance.categories,
      'languages': instance.languages,
      'currencies': instance.currencies,
      'cart': instance.cart,
      'language': instance.language,
      'footerMenu': instance.footerMenu,
    };

Banners _$BannersFromJson(Map<String, dynamic> json) => Banners(
      title: json['title'] as String?,
      type: json['type'] as String?,
      link: json['link'] as String?,
      image: json['image'] as String?,
      dominantColor: json['dominant_color'] as String?,
      homeSequenceId: json['home_sequence_id'] as String?,
    );

Map<String, dynamic> _$BannersToJson(Banners instance) => <String, dynamic>{
      'home_sequence_id': instance.homeSequenceId,
      'title': instance.title,
      'type': instance.type,
      'link': instance.link,
      'image': instance.image,
      'dominant_color': instance.dominantColor,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productId: json['product_id'] as String?,
      thumb: json['thumb'] as String?,
      dominantColor: json['dominant_color'] as String?,
      name: json['name'] as String?,
      price: json['price'] as String?,
      quantity: json['quantity'] as String?,
      special: json['special'],
      formattedSpecial: json['formatted_special'] as String?,
      tax: json['tax'] as String?,
      rating: json['rating'] as int?,
      reviews: json['reviews'] as String?,
      hasOption: json['hasOption'] as bool?,
      wishlistStatus: json['wishlist_status'] as bool?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'product_id': instance.productId,
      'thumb': instance.thumb,
      'dominant_color': instance.dominantColor,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'special': instance.special,
      'formatted_special': instance.formattedSpecial,
      'tax': instance.tax,
      'rating': instance.rating,
      'reviews': instance.reviews,
      'hasOption': instance.hasOption,
      'wishlist_status': instance.wishlistStatus,
    };

Categories _$CategoriesFromJson(Map<String, dynamic> json) => Categories(
      name: json['name'] as String?,
      childStatus: json['child_status'] as bool?,
      path: json['path'] as String?,
      image: json['image'] as String?,
      dominantColor: json['dominant_color'] as String?,
      icon: json['icon'] as String?,
      dominantColorIcon: json['dominant_color_icon'] as String?,
    );

Map<String, dynamic> _$CategoriesToJson(Categories instance) =>
    <String, dynamic>{
      'name': instance.name,
      'child_status': instance.childStatus,
      'path': instance.path,
      'image': instance.image,
      'dominant_color': instance.dominantColor,
      'icon': instance.icon,
      'dominant_color_icon': instance.dominantColorIcon,
    };

Languages _$LanguagesFromJson(Map<String, dynamic> json) => Languages(
      textLanguage: json['child_status'] as String?,
      code: json['code'] as String?,
      image: json['image'] as String?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => Language.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LanguagesToJson(Languages instance) => <String, dynamic>{
      'child_status': instance.textLanguage,
      'code': instance.code,
      'image': instance.image,
      'languages': instance.languages,
    };

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
      name: json['name'] as String?,
      code: json['code'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$LanguageToJson(Language instance) => <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'image': instance.image,
    };

Currencies _$CurrenciesFromJson(Map<String, dynamic> json) => Currencies(
      textCurrency: json['textCurrency'] as String?,
      code: json['code'] as String?,
      currencies: (json['currencies'] as List<dynamic>?)
          ?.map((e) => Currency.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CurrenciesToJson(Currencies instance) =>
    <String, dynamic>{
      'textCurrency': instance.textCurrency,
      'code': instance.code,
      'currencies': instance.currencies,
    };

Currency _$CurrencyFromJson(Map<String, dynamic> json) => Currency(
      title: json['title'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'title': instance.title,
      'code': instance.code,
    };

FooterMenu _$FooterMenuFromJson(Map<String, dynamic> json) => FooterMenu(
      informationId: json['information_id'] as String?,
      title: json['title'] as String?,
      status: json['status'] as String?,
      sortOrder: json['sortOrder'] as String?,
    );

Map<String, dynamic> _$FooterMenuToJson(FooterMenu instance) =>
    <String, dynamic>{
      'information_id': instance.informationId,
      'title': instance.title,
      'status': instance.status,
      'sortOrder': instance.sortOrder,
    };

Carousels _$CarouselsFromJson(Map<String, dynamic> json) => Carousels(
      homeSequenceId: json['home_sequence_id'] as String?,
      id: json['id'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String?,
      imageSubType: json['image_sub_type'] as String?,
      productType: json['product_type'] as String?,
      sortOrder: json['sort_order'] as String?,
      product: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      slider: (json['image_carousel'] as List<dynamic>?)
          ?.map((e) => SliderImages.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageTypeCategoryCarousal:
          (json['image_all_parrent_category'] as List<dynamic>?)
              ?.map((e) => Categories.fromJson(e as Map<String, dynamic>))
              .toList(),
      imageCatagory: (json['image_catagory'] as List<dynamic>?)
          ?.map((e) => Categories.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageManufacturer: (json['image_manufacturer'] as List<dynamic>?)
          ?.map((e) => ImageManufacturer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CarouselsToJson(Carousels instance) => <String, dynamic>{
      'home_sequence_id': instance.homeSequenceId,
      'image_sub_type': instance.imageSubType,
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'product_type': instance.productType,
      'sort_order': instance.sortOrder,
      'products': instance.product,
      'image_all_parrent_category': instance.imageTypeCategoryCarousal,
      'image_catagory': instance.imageCatagory,
      'image_carousel': instance.slider,
      'image_manufacturer': instance.imageManufacturer,
    };

HomeSequenceElement _$HomeSequenceElementFromJson(Map<String, dynamic> json) =>
    HomeSequenceElement(
      id: json['id'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$HomeSequenceElementToJson(
        HomeSequenceElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
    };

SliderImages _$SliderImagesFromJson(Map<String, dynamic> json) => SliderImages(
      bannerTitle: json['banner_title'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String?,
      link: json['link'] as String?,
      image: json['image'] as String?,
      dominantColor: json['dominantColor'] as String?,
    );

Map<String, dynamic> _$SliderImagesToJson(SliderImages instance) =>
    <String, dynamic>{
      'banner_title': instance.bannerTitle,
      'title': instance.title,
      'type': instance.type,
      'link': instance.link,
      'image': instance.image,
      'dominantColor': instance.dominantColor,
    };

ImageTypeCategoryCarousal _$ImageTypeCategoryCarousalFromJson(
        Map<String, dynamic> json) =>
    ImageTypeCategoryCarousal(
      name: json['name'] as String?,
      childStatus: json['child_status'] as bool?,
      path: json['path'] as String?,
      image: json['image'] as String?,
      dominantColor: json['dominantColor'] as String?,
      icon: json['icon'] as String?,
      dominantColorIcon: json['dominantColorIcon'] as String?,
    );

Map<String, dynamic> _$ImageTypeCategoryCarousalToJson(
        ImageTypeCategoryCarousal instance) =>
    <String, dynamic>{
      'name': instance.name,
      'child_status': instance.childStatus,
      'path': instance.path,
      'image': instance.image,
      'dominantColor': instance.dominantColor,
      'icon': instance.icon,
      'dominantColorIcon': instance.dominantColorIcon,
    };

ImageManufacturer _$ImageManufacturerFromJson(Map<String, dynamic> json) =>
    ImageManufacturer(
      manufacturerId: json['manufacturer_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ImageManufacturerToJson(ImageManufacturer instance) =>
    <String, dynamic>{
      'manufacturer_id': instance.manufacturerId,
      'name': instance.name,
      'image': instance.image,
    };
