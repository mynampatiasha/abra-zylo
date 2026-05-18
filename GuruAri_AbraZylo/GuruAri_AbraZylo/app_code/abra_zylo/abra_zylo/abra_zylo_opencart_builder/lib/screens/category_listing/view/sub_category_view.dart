/*
 *
 *  Webkul Software.
 * @package Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html
 *  @link https://store.webkul.com/license.html
 *
 * /
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/app_bar.dart';
import '../../../common_widgets/loader.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
// import '../../../marketplace/marketplace_model/seller_profile_model.dart';
import '../../../models/catalog/catalog_model.dart';
import '../../../models/sub_category/sub_category_model.dart';
import '../../catalog_screen/bloc/catalog_screen_bloc.dart';
import '../../catalog_screen/bloc/catalog_screen_repository.dart';
import '../../catalog_screen/bloc/catalog_screen_state.dart';
import '../../catalog_screen/catalog_screen.dart';
import '../../category/bloc/categories_screen_bloc.dart';
import '../../category/bloc/categories_screen_repository.dart';
import '../../category/widgets/product_list_item.dart';

class SubCategoryView extends StatefulWidget {
  String? id;
  String? name;

  SubCategoryView({this.name, this.id, Key? key}) : super(key: key);

  @override
  State<SubCategoryView> createState() => _SubCategoryViewState();
}

class _SubCategoryViewState extends State<SubCategoryView> {
  CategoriesScreenBloc? categoryScreenBloc;
  bool isLoading = true;
  SubCategoryModel? _categoryPageResponse;
  int _selectedIndex = 0;
  bool? isSubCategoryLoading;
  AppLocalizations? _localizations;
  String? categoryId;

  @override
  void initState() {
    if ((widget.id?.isNotEmpty ?? false)) {
      categoryId = widget.id;
      categoryScreenBloc = context.read<CategoriesScreenBloc>();
      categoryScreenBloc?.add(FetchCategoriesEvent(categoryId));
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(widget.name ?? '', context,
          isLeadingEnable: false,
          isHomeEnable: false,
          hideCart: true,
          hideAll: true),
      body: _buildMainUi(),
    );
  }

  Widget _buildMainUi() {
    return BlocBuilder<CategoriesScreenBloc, CategoriesScreenState>(
      builder: (context, currentState) {
        if (currentState is CatalogInitialState) {
          isLoading = true;
        } else if (currentState is CategoriesFetchState) {
          _categoryPageResponse = (currentState).categoriesModel;
          isLoading = false;
          print("CatalogFetchCacheState Called ----> $isLoading");
        } else if (currentState is CategoriescreenErrorState) {
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message ?? '', context);
          });
        }
        return _buildUI();
      },
    );
  }

  Widget _buildUI() {
    print("_buildUI Called ----> $isLoading");
    return Container(
      color: Theme.of(context).cardColor,
      child: (isLoading == true)
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Loader(),
            )
          : subcategoryListView(),
    );
  }

  Widget subcategoryListView() {
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: width,
            child: (_categoryPageResponse?.categories ?? []).isNotEmpty
                ? Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              _categoryPageResponse?.categories?.length ?? 0,
                          itemBuilder: (context, int index) {
                            return GestureDetector(
                              onTap: () {
                                if (_categoryPageResponse
                                        ?.categories?[index].childStatus ??
                                    false) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return BlocProvider(
                                      create: (context) => CategoriesScreenBloc(
                                        repository:
                                            CategoriesScreenRepositoryImp(),
                                      ),
                                      child: SubCategoryView(
                                        name: _categoryPageResponse
                                            ?.categories?[index].name,
                                        id: _categoryPageResponse
                                                ?.categories?[index].path ??
                                            "0",
                                      ),
                                    );
                                  }));
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider(
                                        create: (context) => CatalogScreenBloc(
                                          repository: CatalogRepositoryImpl(),
                                        ),
                                        child: CatalogScreen(
                                          categoryMap(
                                              _categoryPageResponse
                                                      ?.categories?[index]
                                                      .path ??
                                                  "0",
                                              _categoryPageResponse
                                                      ?.categories?[index]
                                                      .name ??
                                                  "",
                                              ""),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                  color: Theme.of(context).cardColor,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          _categoryPageResponse
                                                  ?.categories?[index].name ??
                                              "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        trailing: const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 12,
                                        ),
                                      ),
                                      const Divider(
                                        height: AppSizes.size1,
                                      ),
                                    ],
                                  )),
                            );
                          }),
                      const SizedBox(height: AppSizes.size8),
                      categoryProducts()
                    ],
                  )
                : categoryProducts(),
          ),
        ],
      ),
    );
  }

  //=========Showing products for selected category=======//
  Widget categoryProducts() {
    return SizedBox.shrink();
    /*return ProductListItem(
      title: AppStringConstant.products.localized(),
      id: _categoryPageResponse?.menuCategory
          ?.getMenuCategor()[_selectedIndex ?? 0]
          .idCategory,
      products: _categoryPageResponse?.products?.productsList?.getProducts(),
    );*/
  }
}
