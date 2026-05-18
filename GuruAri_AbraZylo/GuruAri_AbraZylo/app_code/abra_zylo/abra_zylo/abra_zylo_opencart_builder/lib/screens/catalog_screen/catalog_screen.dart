import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/catalog/brand/manufacture_model.dart';
import 'package:oc_demo/models/catalog/catalog_model.dart';
import 'package:oc_demo/models/catalog/filter_group.dart';
import 'package:oc_demo/models/catalog/request/catalog_product_request.dart';
import 'package:oc_demo/models/catalog/sort.dart';
import 'package:oc_demo/models/product/product.dart';
import 'package:oc_demo/screens/catalog_screen/bloc/catalog_screen_bloc.dart';
import 'package:oc_demo/screens/catalog_screen/bloc/catalog_screen_event.dart';
import 'package:oc_demo/screens/catalog_screen/bloc/catalog_screen_state.dart';
import 'package:oc_demo/screens/catalog_screen/widget/catalog_grid_view.dart';
import 'package:oc_demo/screens/catalog_screen/widget/catalog_listview.dart';
import 'package:oc_demo/screens/catalog_screen/widget/filter_bottom_sheet.dart';
import 'package:oc_demo/screens/catalog_screen/widget/sort_bottom_sheet.dart';
import 'dart:async';

import '../../main.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen(this.arguments, {Key? key}) : super(key: key);

  final Map<String, dynamic> arguments;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> with RouteAware {
  late bool _isGrid, _loading, _sortApplied, _filterApplied;
  CatalogScreenBloc? _bloc;
  CatalogModel? _model;
  ManufactureModel? _manufactureModel;
  late List<Product> _products;
  late List<Product> _tempProductsList = [];
  int lsatDbListSize = 0;
  late List<Sort> _sorts;
  late List<FilterGroup> _filterGroups;
  late ScrollController _scrollController;
  late CatalogProductRequest _request;
  late int _page;
  Sort? _sort;
  String? _filter, catalogId, label, _productCategoryType;
  bool showFilterOption = true;
  bool isWishlistState = false;
  String? productId;
  int? index1;
  Timer? _debounce;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });
    catalogId = widget.arguments[categoryId];
    label = widget.arguments[labelKey];
    _productCategoryType = widget.arguments[productCategoryTypeKey];
    _isGrid = true;
    _loading = true;
    _sortApplied = false;
    _filterApplied = false;
    _page = 1;
    _products = [];
    _sorts = [];
    _filterGroups = [];
    _scrollController = ScrollController()..addListener(setupPagination);
    _bloc = context.read<CatalogScreenBloc>();
    productId = "-1";
    index1 = -1;
    print("catalog id ${catalogId}");
    _callAPI();
    super.initState();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _callAPI();
  }

  setupPagination() {
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
      if (hasMoreData()) {
        _page += 1;
        _callAPI();
      }
    }
  }

  _callAPI() {
    _loading = true;
    var home = widget.arguments[fromHomePageKey];

    AppSharedPref.getWkToken().then((value) {
      _request = CatalogProductRequest(
        width: AppSizes.deviceWidth.toInt().toString(),
        limit: "10",
        path: home == true ? null : catalogId,
        page: _page.toString(),
        token: value,
        manufactureId: home == true ? catalogId : null,
      );

      if (_sort != null) {
        _request.sort = _sort?.value;
        _request.order = _sort?.order;
      } else {
        _request.sort = null;
        _request.order = null;
      }
      if (_filter != null) {
        _request.filter = _filter;
      } else {
        _request.filter = null;
      }
      /*     if (_productCategoryType == GlobalData.popular_products) {
        showFilterOption = false;
        _bloc?.add(FetchPopularEvent(_request));
      } else if (_productCategoryType == GlobalData.feature_products) {
        showFilterOption = false;
        _bloc?.add(FetchFeatureEvent(_request));
      } else if (_productCategoryType == GlobalData.best_products) {
        showFilterOption = false;
        _bloc?.add(FetchBestEvent(_request));
      } else if (_productCategoryType == GlobalData.latest_products) {
        showFilterOption = false;
        _bloc?.add(FetchLatestEvent(_request));
      } else if (_productCategoryType == GlobalData.custom_collection) {
        _bloc?.add(FetchCustomCollection(_request));
      } */
      if (_productCategoryType == GlobalData.home_page_carousel) {
        showFilterOption = false;
        _bloc?.add(FetchCarouselsEvent(_request));
      } else {
        if (home == true) {
          showFilterOption = false;
          _bloc?.add(FetchCatalogBrandEvent(_request));
        } else {
          _bloc?.add(FetchCatalogEvent(_request));
        }
      }
      _bloc?.add(LoadingEvent());
      label = widget.arguments[labelKey];
    });
  }

  bool hasMoreData() {
    var total = 0;

    if (_productCategoryType == GlobalData.popular_products ||
        _productCategoryType == GlobalData.feature_products ||
        _productCategoryType == GlobalData.latest_products ||
        _productCategoryType == GlobalData.best_products ||
        _productCategoryType == GlobalData.home_page_carousel) {
      total = int.parse(_model?.productTotal ?? "0");
    } else if (_model == null ||
        _model?.categoryData == null ||
        _model?.categoryData?.productTotal == null) {
      total = int.tryParse(
              (_manufactureModel?.manufacturers?.productTotal ?? "0")) ??
          0;
    } else {
      total = int.tryParse((_model?.categoryData?.productTotal ?? "0")) ?? 0;
    }
    return (total > _products.length && !_loading);
  }

  @override
  Widget build(BuildContext context) {
    print("hhrhr -- ${widget.arguments}");
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: ' Search...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onChanged: (searchKey) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(seconds: 1), () {
                    _bloc?.add(GetSearchResultEvent(
                        searchKey, catalogId, _searchController.text));
                    // quickCartBloc?.add(QuickCartSuggestionEvent(searchKey));
                  });
                  // _bloc?.add(GetSearchResultEvent(searchKey,catalogId, _searchController.text));
                  // quickCartBloc?.add(QuickCartSuggestionEvent(searchKey));
                },
              )
            : Text(label ?? ""),
        actions: [
          IconButton(
            iconSize: 28,
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _bloc?.add(FetchCatalogEvent(_request));
                  // Optionally clear search results or reset UI
                }
              });
            },
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: BlocBuilder<CatalogScreenBloc, CatalogScreenState>(
        builder: (ctx, currentState) {
          if (currentState is CatalogInitialState) {
            _loading = true;
          } else if (currentState is CatalogFetchState) {
            _model = currentState.model;
            if (/*_productCategoryType == GlobalData.popular_products ||
                _productCategoryType == GlobalData.feature_products ||
                _productCategoryType == GlobalData.latest_products ||
                _productCategoryType == GlobalData.best_products */
                _productCategoryType == GlobalData.home_page_carousel ||
                    _productCategoryType == GlobalData.custom_collection) {
              processProductList(_model?.products ?? [], currentState.isFromDb);
              // _products.addAll(_model?.products ?? []);
              _sorts = _model?.sorts ?? [];
              _filterGroups = _model?.filterGroups ?? [];
            } else {
              processProductList(
                  _model?.categoryData?.products ?? [], currentState.isFromDb);
              _sorts = _model?.categoryData?.sorts ?? [];
              _filterGroups = _model?.moduleData?.filterGroups ?? [];
              // _products.addAll(_model?.categoryData?.products ?? []);
            }
            _loading = false;
          } else if (currentState is BrandFetchState) {
            _manufactureModel = currentState.manufactureModel;
            processProductList(
                _manufactureModel?.manufacturers?.products ?? <Product>[],
                currentState.isFromDb);
            // _products.addAll(_manufactureModel?.manufacturers?.products ?? <Product>[]);
            _loading = false;
          } else if (currentState is ChangeViewState) {
            _isGrid = currentState.isGrid;
          } else if (currentState is AddProductToWishlistStateSuccess) {
            _loading = false;
            isWishlistState = true;

            // _callAPI();

            _bloc?.emit(WishlistIdleState());
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              setState(() {
                if (productId != "-1" && index1 != -1) {
                  _products[index1!].wishlistStatus =
                      currentState.wishListModel.wishliststatus;
                  productId = "0";
                  index1 = 0;
                }
              });
              AlertMessage.showSuccess(
                  currentState.wishListModel.message ?? '', context);
            });
          } else if (currentState is GetSearchStateSuccess) {
            _model = currentState.model;
            print("Rishabh product List:- ${_model?.products?.length}");
            _products.clear();
            _products.addAll(_model?.products ?? []);
            _bloc?.emit(CommonState());
          } else if (currentState is CatalogErrorState) {
            _loading = false;
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              AlertMessage.showError(currentState.message ?? '', context);
            });
          }
          return buildUI();
        },
      ),
    );
  }

  Widget buildUI() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            if (_productCategoryType != GlobalData.custom_collection &&
                _products.isNotEmpty)
              Center(child: topContainer()),
            widgetSpace(0, AppSizes.size8),
            Visibility(
              child: Expanded(child: getProductView()),
              visible: _products.isNotEmpty,
            ),
            Visibility(
              child: Expanded(
                child: Center(
                  child: Text(
                    AppStringConstant.noProductAvailable.localized(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              visible: _products.isEmpty && !_loading,
            )
          ],
        ),
        Visibility(
          child: const Loader(),
          visible: _loading,
        ),
      ],
    );
  }

  Widget getProductView() {
    return _isGrid
        ? CatalogGridView(
            products: _products,
            controller: _scrollController,
            addProductToWishList: (value, index) {
              print("pankaj-29-- ${index1}");
              productId = value;
              index1 = index;
              _bloc?.add(AddToWishlistEvent(value));
            })
        : CatalogListView(
            products: _products,
            controller: _scrollController,
            addProductToWishList: (value, index) {
              productId = value;
              index1 = index;
              _bloc?.add(AddToWishlistEvent(value));
            });
  }

  Widget topContainer() {
    return Card(
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              iconButton(
                Icons.sort,
                AppStringConstant.sort.localized(),
                () {
                  if (_sorts.isEmpty == true) {
                    WidgetsBinding.instance?.addPostFrameCallback((_) {
                      AlertMessage.showWarning(
                          AppStringConstant.sortOptionsNotAvailable.localized(),
                          context);
                    });
                    return;
                  }
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(),
                    builder: (ctx) => SortBottomSheet(
                      _sorts,
                      (sort) {
                        Navigator.of(context).pop();
                        _sort = sort;
                        _page = 1;
                        _products = [];
                        _callAPI();

                        _sortApplied = true;
                      },
                      selected: _sort,
                    ),
                  );
                },
                _sortApplied,
              ),
              if (showFilterOption)
                iconButton(
                  Icons.filter_alt_outlined,
                  AppStringConstant.filter.localized(),
                  () {
                    if (_filterGroups.isEmpty == true) {
                      WidgetsBinding.instance?.addPostFrameCallback((_) {
                        AlertMessage.showWarning(
                            AppStringConstant.filterOptionsNotAvailable
                                .localized(),
                            context);
                      });
                      return;
                    }
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => FilterBottomSheet(
                        _filterGroups,
                        () {
                          Navigator.of(context).pop();
                          _filter = "";
                          for (var element in _filterGroups) {
                            element.filter?.forEach((filter) {
                              if (filter.selected == true) {
                                _filter = "$_filter,${filter.filterId}";
                              }
                            });
                          }

                          if (_filter?.isNotEmpty == true) {
                            _filter = _filter?.substring(1);
                          } else {
                            _filter = null;
                          }
                          _page = 1;
                          _products = [];
                          _callAPI();

                          _filterApplied = true;
                        },
                        _filter,
                      ),
                    );
                  },
                  _filterApplied,
                ),
              iconButton(
                  _isGrid ? Icons.grid_view : Icons.list,
                  _isGrid
                      ? AppStringConstant.grid.localized()
                      : AppStringConstant.list.localized(), () {
                _bloc?.add(ChangeViewEvent(!_isGrid));
              }),
            ],
          ),
          // widgetDivider(context, 0.5),
        ],
      ),
    );
  }

  Widget iconButton(IconData icon, String title, VoidCallback onPressed,
          [bool optional = false]) =>
      Expanded(
        child: Material(
          color: Theme.of(context).cardColor,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: AppSizes.size16,
                  bottom: AppSizes.size16,
                  left: AppSizes.size12,
                  right: AppSizes.size12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    icon,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: AppSizes.size8),
                  Text(title.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge),
                  if (optional) const SizedBox(width: AppSizes.size4),
                  if (optional)
                    Container(
                      height: AppSizes.size8,
                      width: AppSizes.size8,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppSizes.size4),
                        ),
                        color: Colors.red,
                      ),
                    ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ),
        ),
      );

  void processProductList(List<Product>? products, bool isFromDB) {
    if (_tempProductsList.length > 0) {
      if (isFromDB) {
        _tempProductsList.addAll(products ?? []);
        lsatDbListSize = products?.length ?? 0;
      } else {
        if (lsatDbListSize > 0) {
          var limit = _tempProductsList.length - (lsatDbListSize + 1);
          for (var ins = (_tempProductsList.length - 1); ins > limit; ins--) {
            print(" else outer loop   ${ins} - ${lsatDbListSize} - ${limit}");
            if (ins > limit) {
              print(" else inner if   ${ins}  - ${limit}");
              _tempProductsList.removeAt(ins);
            } else
              break;
          }
        }
        print(products?.length);
        lsatDbListSize = 0;
        print("Page: $_page");
        if (_page == 1) {
          _tempProductsList.clear();
        }
        _tempProductsList.addAll(products ?? []);
      }

      //  processProductList(_model?.products ?? []);
    } else {
      print(" else add all  ");
      _tempProductsList.addAll(products ?? []);
      if (isFromDB) {
        lsatDbListSize = products?.length ?? 0;
      }
    }
    _products = _tempProductsList;
  }
}
