import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/custom_loader.dart';
import 'package:oc_demo/common_widgets/horizontal_product_list.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/common_widgets/viewall_header.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/helper/notification_service.dart';
import 'package:oc_demo/models/catalog/catalog_model.dart';
import 'package:oc_demo/models/catalog/request/catalog_product_request.dart';
import 'package:oc_demo/models/sub_category/sub_category_model.dart';
import 'package:oc_demo/screens/category/bloc/categories_screen_bloc.dart';
import 'package:oc_demo/screens/category/widgets/categories_tile.dart';
import 'package:oc_demo/screens/category/widgets/main_category_list.dart';

import '../../main.dart';

class CategoriesScreen extends StatefulWidget {
  final int selectedIndex;
  final int categoryPath;

  const CategoriesScreen({
    super.key,
    required this.selectedIndex,
    required this.categoryPath,
  });

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with RouteAware {
  late bool isLoading;
  String? _selectedCategoryId;
  SubCategoryModel? _categoriesModel;
  CategoriesScreenBloc? _categoriesBloc;
  CatalogModel? _model;
  late String title = "";
  String? productId;
  int? index1;

  late CatalogProductRequest _request;

  @override
  void initState() {
    isLoading = false;
    _categoriesBloc = context.read<CategoriesScreenBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });
    if ((GlobalData.rootCategories ?? []).isNotEmpty) {
      initializeCatalogProductRequest();
    } else {
      _categoriesBloc?.emit(CategoriesInitialState());
    }
    NotificationService.instance.notificationCenter
        .subscribe(NotificationService.updateCategoryKey, (p0) {
      if (mounted && !(_categoriesBloc?.isClosed ?? true)) {
        initializeCatalogProductRequest();
      }
    });
    super.initState();
  }

  void initializeCatalogProductRequest() {
    if ((GlobalData.rootCategories ?? []).isNotEmpty) {
      print("Category before ${widget.categoryPath}");
      print("Category after ${widget.categoryPath}");
      _selectedCategoryId =
          GlobalData.rootCategories?.elementAt(widget.selectedIndex).path;
      title =
          GlobalData.rootCategories?.elementAt(widget.selectedIndex).name ?? "";
      if (!(_categoriesBloc?.isClosed ?? true)) {
        _categoriesBloc?.add(FetchCategoriesEvent(
            GlobalData.rootCategories?.elementAt(widget.selectedIndex).path));
      }
    } else {
      if (!(_categoriesBloc?.isClosed ?? true)) {
        _categoriesBloc?.add(FetchCategoriesEvent(""));
      }
    }

    AppSharedPref.getWkToken().then((value) {
      _request = CatalogProductRequest(
        page: "1",
        limit: "5",
        path: ((GlobalData.rootCategories ?? []).isNotEmpty)
            ? GlobalData.rootCategories?.elementAt(widget.selectedIndex).path
            : "",
        token: value,
        width: "${AppSizes.deviceWidth}",
      );
    });
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    // Unsubscribe from notifications to prevent adding events to a closed BLoC
    NotificationService.instance.notificationCenter
        .unsubscribe(NotificationService.updateCategoryKey);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    // This is called when coming back to this screen
    isLoading = true;
    if (!(_categoriesBloc?.isClosed ?? true)) {
      _categoriesBloc?.add(FetchCategoriesEvent(
          GlobalData.rootCategories?.elementAt(widget.selectedIndex).path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(AppStringConstant.categories.localized(), context),
      body: _setCategoryData(context),
    );
  }

  /// categories bloc method
  _setCategoryData(BuildContext context) {
    return BlocBuilder<CategoriesScreenBloc, CategoriesScreenState>(
      builder: (context, currentState) {
        if (currentState is CategoriesInitialState) {
          isLoading = true;
        } else if (currentState is CategoriesFetchState) {
          _categoriesModel = currentState.categoriesModel;
          _categoriesBloc?.add(FetchProductsEvent(_request));
          // isLoading = false;
        } else if (currentState is ProductsFetchState) {
          _model = currentState.model;
          isLoading = false;
        } else if (currentState is AddProductToWishlistStateSuccess) {
          isLoading = false;
          // isWishlistState = true;
          _categoriesBloc?.emit(WishlistIdleState());
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            setState(() {
              if (productId != "-1" && index1 != -1) {
                _model?.categoryData?.products![index1!].wishlistStatus =
                    currentState.wishListModel.wishliststatus;
                productId = "0";
                index1 = 0;
              }
            });
            AlertMessage.showSuccess(
                currentState.wishListModel.message ?? '', context);
          });
        } else if (currentState is CategoriescreenErrorState) {
          isLoading = false;
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message ?? '', context);
          });
        }
        return _categoriesData(context);
      },
    );
  }

  _categoriesData(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MainCategoryList(
              _categoriesBloc,
              (value) {
                _selectedCategoryId = value;
                _request.path = value;
                _model = null;

                GlobalData.rootCategories?.forEach((element) {
                  if (element.path == value) {
                    title = element.name ?? "";
                  }
                });

                _categoriesBloc?.add(FetchCategoriesEvent(value));
              },
              widget.selectedIndex,
            ),
            categoryTileData(),
          ],
        ),
        Visibility(
          visible: isLoading,
          child: Center(
            child: LoaderUtil.showCoverLoader(),
          ),
        )
      ],
    );
  }

  Widget categoryTileData() {
    print("--cacaca----> ${_categoriesModel?.categories?.length}");
    return GlobalData.rootCategories?.isNotEmpty == true
        ? SizedBox(
            width: 2 * (AppSizes.deviceWidth / 3),
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible: _categoriesModel?.categories?.isNotEmpty == true,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: CategoriesTile(
                          category: _categoriesModel?.categories,
                          rootCategoryId: _selectedCategoryId,
                          title: title,
                        ),
                      ),
                    ),
                    Visibility(
                        visible: _categoriesModel?.categories?.length == null,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: SizedBox(
                            height: 100,
                            child: Center(
                              child: Text(
                                AppStringConstant.noSubCategoryAvailable
                                    .localized(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        )),
                    Visibility(
                      visible: _model?.categoryData?.products != null &&
                          _model?.categoryData?.products?.isNotEmpty == true,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ViewAllHeader(title, _selectedCategoryId),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 14.0),
                            child: Divider(
                              height: 0.5,
                              thickness: 2,
                              color: AppColors.dividerColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          HorizontalProductList(
                              products: _model?.categoryData?.products,
                              addProductToWishList: (value, index) {
                                productId = value;
                                index1 = index;
                                _categoriesBloc?.add(AddToWishlistEvent(value));
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox(
            height: 100,
            child: Center(
              child: Text(AppStringConstant.noCategoryAvailable.localized()),
            ),
          );
  }
}
