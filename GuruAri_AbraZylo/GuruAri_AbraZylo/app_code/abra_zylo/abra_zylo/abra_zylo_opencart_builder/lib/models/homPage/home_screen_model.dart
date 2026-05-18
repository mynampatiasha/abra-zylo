import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'home_screen_model.g.dart';

/*
@JsonSerializable()
@HiveType(typeId: 1)
class HomePageData extends BaseModel {
  @HiveField(100)
  @JsonKey(name:"etag")
  String? eTag = "";

  @HiveField(0)
  bool? guestStatus;
  @HiveField(1)
  int? partner;
  @HiveField(2)
  bool? partnerApproveRequired;

  @HiveField(3)
  List<String>? homeSequence;
  @HiveField(4)
  List<Banners>? banners;
  @HiveField(5)
  List<Product>? bestProduct;
  @HiveField(6)
  List<Product>? latestProduct;
  @HiveField(7)
  List<Product>? popularProduct;
  @HiveField(8)
  List<Product>? featuredProduct;
  @HiveField(9)
  List<Carousel>? carousel;
  @HiveField(10)
 // List<Categories>? categories;
  dynamic categories;
  @HiveField(11)
  Languages? languages;
  @HiveField(12)
  Currencies? currencies;
  @HiveField(13)
  int? cart;
  @HiveField(14)
  String? language;
  @HiveField(15)
  List<FooterMenu>? footerMenu;

  HomePageData(
      {this.eTag,
        this.guestStatus,
        this.partner,
        this.partnerApproveRequired,
        this.homeSequence,
        this.banners,
        this.bestProduct,
        this.latestProduct,
        this.popularProduct,
        this.featuredProduct,
        this.carousel,
        this.categories,
        this.languages,
        this.currencies,
        this.cart,
        this.language,
        this.footerMenu});

  List<Categories> getMenuCategory() {
    List<Categories> value = [];
    if (categories != null) {
      if (categories is List) {
        for (var e in (categories as List<dynamic>)) {
          value.add(e);
          // value.add(Categories.fromJson(e));
        }
      } else {
        value = [Categories.fromJson(categories)];
      }
    }
    return value;
  }


  HomePageData.fromJson(Map<String, dynamic> json) {
    guestStatus = json['guest_status'];
    eTag = json['etag'];
    partner = json['partner'];
    partnerApproveRequired = json['partner_approve_required'];
    homeSequence = json['home_sequence'].cast<String>();
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    if (json['best_product'] != null) {
      bestProduct = <Product>[];
      json['best_product'].forEach((v) {
        bestProduct!.add(new Product.fromJson(v));
      });
    }
    if (json['latest_product'] != null) {
      latestProduct = <Product>[];
      json['latest_product'].forEach((v) {
        latestProduct!.add(new Product.fromJson(v));
      });
    }
    if (json['popular_product'] != null) {
      popularProduct = <Product>[];
      json['popular_product'].forEach((v) {
        popularProduct!.add(new Product.fromJson(v));
      });
    }
    if (json['featured_product'] != null) {
      featuredProduct = <Product>[];
      json['featured_product'].forEach((v) {
        featuredProduct!.add(new Product.fromJson(v));
      });
    }
    if (json['carousel'] != null) {
      carousel = <Carousel>[];
      json['carousel'].forEach((v) {
        carousel!.add(new Carousel.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    languages = json['languages'] != null
        ? new Languages.fromJson(json['languages'])
        : null;
    currencies = json['currencies'] != null
        ? new Currencies.fromJson(json['currencies'])
        : null;
    cart = json['cart'];
    language = json['language'];
    if (json['footerMenu'] != null) {
      footerMenu = <FooterMenu>[];
      json['footerMenu'].forEach((v) {
        footerMenu!.add(new FooterMenu.fromJson(v));
      });
    }
  }
}

@JsonSerializable()
@HiveType(typeId: 2)
class Banners {
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? type;
  @HiveField(3)
  String? link;
  @HiveField(4)
  String? image;
  @HiveField(5)
  @JsonKey(name: "dominant_color")
  String? dominantColor;

  Banners({this.title, this.type, this.link, this.image, this.dominantColor});

  factory Banners.fromJson(Map<String, dynamic> json) =>
      _$BannersFromJson(json);
}

@JsonSerializable()
@HiveType(typeId: 3)
class Product {
  @HiveField(1)
  @JsonKey(name: "product_id")
  String? productId;
  @HiveField(2)
  String? thumb;
  @HiveField(3)
  @JsonKey(name: "dominant_color")
  String? dominantColor;
  @HiveField(4)
  String? name;
  @HiveField(5)
  String? price;
  @HiveField(6)
  String? quantity;
  @HiveField(7)
  int? special;
  @JsonKey(name: "formatted_special")
  @HiveField(8)
  String? formattedSpecial;
  @HiveField(9)
  String? tax;
  @HiveField(10)
  int? rating;
  @HiveField(11)
  String? reviews;
  @HiveField(12)
  bool? hasOption;
  @HiveField(13)
  @JsonKey(name: "wishlist_status")
  bool? wishlistStatus;

  Product(
      {this.productId,
        this.thumb,
        this.dominantColor,
        this.name,
        this.price,
        this.quantity,
        this.special,
        this.formattedSpecial,
        this.tax,
        this.rating,
        this.reviews,
        this.hasOption,
        this.wishlistStatus});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@JsonSerializable()
@HiveType(typeId: 4)
class Carousel {
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? link;
  @HiveField(3)
  String? image;
  @HiveField(4)
  String? dominantColor;

  Carousel({this.title, this.link, this.image, this.dominantColor});

  factory Carousel.fromJson(Map<String, dynamic> json) =>
      _$CarouselFromJson(json);
}

@JsonSerializable()
@HiveType(typeId: 5)
class Categories {
  @HiveField(1)
  String? name;
  @JsonKey(name: "child_status")
  @HiveField(2)
  bool? childStatus;
  @HiveField(3)
  String? path;
  @HiveField(4)
  String? image;
  @HiveField(5)
  @JsonKey(name: "dominant_color")
  String? dominantColor;
  @HiveField(6)
  String? icon;
  @HiveField(7)
  @JsonKey(name: "dominant_color_icon")
  String? dominantColorIcon;

  Categories(
      {this.name,
        this.childStatus,
        this.path,
        this.image,
        this.dominantColor,
        this.icon,
        this.dominantColorIcon});

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);
}

@JsonSerializable()
@HiveType(typeId: 6)
class Languages {
  @HiveField(1)
  @JsonKey(name: "child_status")
  String? textLanguage;
  @HiveField(2)
  String? code;
  @HiveField(3)
  String? image;
  @HiveField(4)
  List<Language>? languages;

  Languages({this.textLanguage, this.code, this.image, this.languages});

  Languages.fromJson(Map<String, dynamic> json) {
    textLanguage = json['text_language'];
    code = json['code'];
    image = json['image'];
    if (json['languages'] != null) {
      languages = <Language>[];
      json['languages'].forEach((v) {
        languages!.add(new Language.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => _$LanguagesToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 7)
class Language {
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? code;
  @HiveField(3)
  String? image;

  Language({this.name, this.code, this.image});

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 8)
class Currencies {
  @HiveField(1)
  String? textCurrency;
  @HiveField(2)
  String? code;
  @HiveField(3)
  List<Currency>? currencies;

  Currencies({this.textCurrency, this.code, this.currencies});

  Currencies.fromJson(Map<String, dynamic> json) {
    textCurrency = json['text_currency'];
    code = json['code'];
    if (json['currencies'] != null) {
      currencies = <Currency>[];
      json['currencies'].forEach((v) {
        currencies!.add(new Currency.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => _$CurrenciesToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 9)
class Currency {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? code;

  Currency({this.title, this.code});

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 10)
class FooterMenu {
  @HiveField(0)
  @JsonKey(name: "information_id")
  String? informationId;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? status;
  @HiveField(3)
  String? sortOrder;

  FooterMenu({this.informationId, this.title, this.status, this.sortOrder});

  factory FooterMenu.fromJson(Map<String, dynamic> json) =>
      _$FooterMenuFromJson(json);
}

*/

/*
@dao
abstract class HomePageDataDao {
  @Insert()
  Future<void> insertHomeData(HomePageData orderTable);



  @Query('SELECT * FROM HomePageData')
  Future<HomePageData?> getHomeData();
}*/

@JsonSerializable()
class HomePageData extends BaseModel {
  bool? guestStatus;
  int? partner;
  bool? partnerApproveRequired;
  List<HomeSequenceElement>? home_sequence;
  List<Banners>? banners;
  /*List<Product>? bestProduct;
  List<Product>? latestProduct;
  List<Product>? popularProduct;
  List<Product>? featuredProduct;*/
  List<Carousels>? carousels;
  List<Categories>? categories;
  Languages? languages;
  Currencies? currencies;
  int? cart;
  String? language;
  List<FooterMenu>? footerMenu;

  HomePageData(
      {this.guestStatus,
      this.partner,
      this.partnerApproveRequired,
      this.home_sequence,
      this.banners,
      /* this.bestProduct,
      this.latestProduct,
      this.popularProduct,
      this.featuredProduct,*/
      this.carousels,
      this.categories,
      this.languages,
      this.currencies,
      this.cart,
      this.language,
      this.footerMenu});

  factory HomePageData.fromJson(Map<String, dynamic> json) =>
      _$HomePageDataFromJson(json);

  // HomePageData.fromJson(Map<String, dynamic> json) {
  //   guestStatus = json['guest_status'];
  //   partner = json['partner'];
  //   partnerApproveRequired = json['partner_approve_required'];
  //   //homeSequence = json['home_sequence'].cast<>();
  //   if (json['banners'] != null) {
  //     banners = <Banners>[];
  //     json['banners'].forEach((v) {
  //       banners!.add(new Banners.fromJson(v));
  //     });
  //   }
  //   if (json['home_sequence'] != null) {
  //     homeSequence = <HomeSequenceElement>[];
  //     json['home_sequence'].forEach((v) {
  //       homeSequence!.add(new HomeSequenceElement.fromJson(v));
  //     });
  //   }
  //   /* if (json['best_product'] != null) {
  //     bestProduct = <Product>[];
  //     json['best_product'].forEach((v) {
  //       bestProduct!.add(new Product.fromJson(v));
  //     });
  //   }
  //   if (json['latest_product'] != null) {
  //     latestProduct = <Product>[];
  //     json['latest_product'].forEach((v) {
  //       latestProduct!.add(new Product.fromJson(v));
  //     });
  //   }
  //   if (json['popular_product'] != null) {
  //     popularProduct = <Product>[];
  //     json['popular_product'].forEach((v) {
  //       popularProduct!.add(new Product.fromJson(v));
  //     });
  //   }
  //   if (json['featured_product'] != null) {
  //     featuredProduct = <Product>[];
  //     json['featured_product'].forEach((v) {
  //       featuredProduct!.add(new Product.fromJson(v));
  //     });
  //   }*/
  //   if (json['carousels'] != null) {
  //     carousels = <Carousels>[];
  //     json['carousels'].forEach((v) {
  //       carousels!.add(new Carousels.fromJson(v));
  //     });
  //   }
  //   if (json['categories'] != null) {
  //     categories = <Categories>[];
  //     json['categories'].forEach((v) {
  //       categories!.add(new Categories.fromJson(v));
  //     });
  //   }
  //   languages = json['languages'] != null
  //       ? new Languages.fromJson(json['languages'])
  //       : null;
  //   currencies = json['currencies'] != null
  //       ? new Currencies.fromJson(json['currencies'])
  //       : null;
  //   cart = json['cart'];
  //   language = json['language'];
  //   if (json['footerMenu'] != null) {
  //     footerMenu = <FooterMenu>[];
  //     json['footerMenu'].forEach((v) {
  //       footerMenu!.add(new FooterMenu.fromJson(v));
  //     });
  //   }
  // }

  Map<String, dynamic> toJson() => _$HomePageDataToJson(this);
}

@JsonSerializable()
class Banners {
  @JsonKey(name: "home_sequence_id")
  String? homeSequenceId;
  String? title;
  String? type;
  String? link;
  String? image;
  @JsonKey(name: "dominant_color")
  String? dominantColor;

  Banners(
      {this.title,
      this.type,
      this.link,
      this.image,
      this.dominantColor,
      this.homeSequenceId});

  factory Banners.fromJson(Map<String, dynamic> json) =>
      _$BannersFromJson(json);

  Map<String, dynamic> toJson() => _$BannersToJson(this);
}

@JsonSerializable()
class Product {
  @JsonKey(name: "product_id")
  String? productId;
  String? thumb;
  @JsonKey(name: "dominant_color")
  String? dominantColor;
  String? name;
  String? price;
  String? quantity;
  dynamic? special;
  @JsonKey(name: "formatted_special")
  String? formattedSpecial;
  String? tax;
  int? rating;
  String? reviews;
  bool? hasOption;
  @JsonKey(name: "wishlist_status")
  bool? wishlistStatus;

  Product(
      {this.productId,
      this.thumb,
      this.dominantColor,
      this.name,
      this.price,
      this.quantity,
      this.special,
      this.formattedSpecial,
      this.tax,
      this.rating,
      this.reviews,
      this.hasOption,
      this.wishlistStatus});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

/*@JsonSerializable()
class Carousel {
  String? title;
  String? link;
  String? image;
  String? dominantColor;

  Carousel({this.title, this.link, this.image, this.dominantColor});

  factory Carousel.fromJson(Map<String, dynamic> json) =>
      _$CarouselFromJson(json);
}*/

@JsonSerializable()
class Categories {
  String? name;
  @JsonKey(name: "child_status")
  bool? childStatus;
  String? path;
  String? image;
  @JsonKey(name: "dominant_color")
  String? dominantColor;
  String? icon;
  @JsonKey(name: "dominant_color_icon")
  String? dominantColorIcon;

  Categories(
      {this.name,
      this.childStatus,
      this.path,
      this.image,
      this.dominantColor,
      this.icon,
      this.dominantColorIcon});

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
}

@JsonSerializable()
class Languages {
  @JsonKey(name: "child_status")
  String? textLanguage;
  String? code;
  String? image;
  List<Language>? languages;

  Languages({this.textLanguage, this.code, this.image, this.languages});

  Languages.fromJson(Map<String, dynamic> json) {
    textLanguage = json['text_language'];
    code = json['code'];
    image = json['image'];
    if (json['languages'] != null) {
      languages = <Language>[];
      json['languages'].forEach((v) {
        languages!.add(new Language.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => _$LanguagesToJson(this);
}

@JsonSerializable()
class Language {
  String? name;
  String? code;
  String? image;

  Language({this.name, this.code, this.image});

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}

@JsonSerializable()
class Currencies {
  String? textCurrency;
  String? code;
  List<Currency>? currencies;

  Currencies({this.textCurrency, this.code, this.currencies});

  Currencies.fromJson(Map<String, dynamic> json) {
    textCurrency = json['text_currency'];
    code = json['code'];
    if (json['currencies'] != null) {
      currencies = <Currency>[];
      json['currencies'].forEach((v) {
        currencies!.add(new Currency.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => _$CurrenciesToJson(this);
}

@JsonSerializable()
class Currency {
  String? title;
  String? code;

  Currency({this.title, this.code});

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}

@JsonSerializable()
class FooterMenu {
  @JsonKey(name: "information_id")
  String? informationId;
  String? title;
  String? status;
  String? sortOrder;

  FooterMenu({this.informationId, this.title, this.status, this.sortOrder});

  factory FooterMenu.fromJson(Map<String, dynamic> json) =>
      _$FooterMenuFromJson(json);

  Map<String, dynamic> toJson() => _$FooterMenuToJson(this);
}

@JsonSerializable()
class Carousels {
  @JsonKey(name: "home_sequence_id")
  String? homeSequenceId;
  @JsonKey(name: "image_sub_type")
  String? imageSubType;
  String? id;
  String? title;
  String? type;
  @JsonKey(name: "product_type")
  String? productType;
  @JsonKey(name: "sort_order")
  String? sortOrder;
  @JsonKey(name: "products")
  List<Product>? product;

  @JsonKey(name: "image_all_parrent_category")
  List<Categories>? imageTypeCategoryCarousal;

  @JsonKey(name: "image_catagory")
  List<Categories>? imageCatagory;

  @JsonKey(name: "image_carousel")
  List<SliderImages>? slider;
  @JsonKey(name: "image_manufacturer")
  List<ImageManufacturer>? imageManufacturer;

  /*
  *   List<Products>? products;
  List<ImageAllParrentCategory>? imageAllParrentCategory;
  List<ImageManufacturer>? imageManufacturer;
  List<ImageCatagory>? imageCatagory;
  List<ImageCarousel>? imageCarousel;
  * */

  Carousels(
      {this.homeSequenceId,
      this.id,
      this.title,
      this.type,
      this.imageSubType,
      this.productType,
      this.sortOrder,
      this.product,
      this.slider,
      this.imageTypeCategoryCarousal,
      this.imageCatagory,
      this.imageManufacturer});
  factory Carousels.fromJson(Map<String, dynamic> json) =>
      _$CarouselsFromJson(json);

  Map<String, dynamic> toJson() => _$CarouselsToJson(this);
}

@JsonSerializable()
class HomeSequenceElement {
  String? id;
  String? type;

  HomeSequenceElement({
    this.id,
    this.type,
  });

  factory HomeSequenceElement.fromJson(Map<String, dynamic> json) =>
      _$HomeSequenceElementFromJson(json);

  Map<String, dynamic> toJson() => _$HomeSequenceElementToJson(this);
}

@JsonSerializable()
class SliderImages {
  @JsonKey(name: "banner_title")
  String? bannerTitle;
  String? title;
  String? type;
  String? link;
  String? image;
  String? dominantColor;

  SliderImages(
      {this.bannerTitle,
      this.title,
      this.type,
      this.link,
      this.image,
      this.dominantColor});

  factory SliderImages.fromJson(Map<String, dynamic> json) =>
      _$SliderImagesFromJson(json);

  Map<String, dynamic> toJson() => _$SliderImagesToJson(this);
}

@JsonSerializable()
class ImageTypeCategoryCarousal {
  String? name;
  @JsonKey(name: "child_status")
  bool? childStatus;
  String? path;
  String? image;
  String? dominantColor;
  String? icon;
  String? dominantColorIcon;

  ImageTypeCategoryCarousal(
      {this.name,
      this.childStatus,
      this.path,
      this.image,
      this.dominantColor,
      this.icon,
      this.dominantColorIcon});

  factory ImageTypeCategoryCarousal.fromJson(Map<String, dynamic> json) =>
      _$ImageTypeCategoryCarousalFromJson(json);
}

@JsonSerializable()
class ImageManufacturer {
  @JsonKey(name: "manufacturer_id")
  String? manufacturerId;
  String? name;
  String? image;

  ImageManufacturer({this.manufacturerId, this.name, this.image});
  factory ImageManufacturer.fromJson(Map<String, dynamic> json) =>
      _$ImageManufacturerFromJson(json);
  Map<String, dynamic> toJson() => _$ImageManufacturerToJson(this);
/*ImageManufacturer.fromJson(Map<String, dynamic> json) {
    manufacturerId = json['manufacturer_id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['manufacturer_id'] = this.manufacturerId;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }*/
}
