import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/models/homPage/home_screen_model.dart';

import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../hive/hive_constant.dart';
import '../../../hive/hive_service.dart';

class RecentView extends StatefulWidget {
  const RecentView({Key? key}) : super(key: key);

  @override
  State<RecentView> createState() => _RecentViewState();
}

class _RecentViewState extends State<RecentView> {
  List<Product>? _recentProducts = [];
  late double _size;

  @override
  void initState() {
    _size = (AppSizes.deviceWidth / 3) - AppSizes.linePadding;

    fetchRecentProducts();
    /*  RecentViewController.controller.stream.listen((event) {
      fetchRecentProducts();
    });*/

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  void fetchRecentProducts() async {
    /* _recentProducts =
        await (await AppDatabase.getDatabase()).recentProductDao.getProducts();*/
    // List<Product>? recentProductList=[];
    await HiveService.getHive()
        .isExists(boxName: HiveConstant.recentProduct)
        .then((value) async {
      if (value) {
        await HiveService.getHive()
            .getBoxes(HiveConstant.recentProduct)
            .then((value) {
          (value as List).forEach((element) {
            _recentProducts?.add(element as Product);
          });
          //recentProductList = value as  List<Product>;
          // recentProductList.add(productPageData);
          /*  HiveService.getHive().addBoxes(
              recentProductList, HiveConstant.recentProduct);*/
          //print("pankaj save recent view product()-- " + "${value}");
          //  subCategoryModel = value as SubCategoryModel;
        });
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //  fetchRecentProducts();
    return _recentProducts == null || _recentProducts?.isEmpty == true
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.size8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.size8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)
                                ?.translate("recentlyProduct") ??
                            "Recently Viewed Products",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.size8),
                SizedBox(
                  height: (AppSizes.deviceWidth / 1.6),
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoute.productPage,
                              arguments: getProductDataAttributeMap(
                                  _recentProducts?.elementAt(index).name ?? '',
                                  _recentProducts?.elementAt(index).productId ??
                                      ''));
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => ProductScreenBloc(
                                  repository: ProductScreenRepositoryImp(),
                                ),
                                child: ProductScreen(
                                  _recentProducts?.elementAt(index).productId,
                                  _recentProducts?.elementAt(index).name,
                                ),
                              ),
                            ),
                          );*/
                        },
                        child: Card(
                          shadowColor: Colors.black54,
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ImageView(
                                  fit: BoxFit.fill,
                                  url:
                                      _recentProducts?.elementAt(index).thumb ??
                                          "",
                                  width: (AppSizes.deviceWidth / 2.5) -
                                      AppSizes.linePadding,
                                  height: (AppSizes.deviceWidth / 2.5) -
                                      AppSizes.linePadding,
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: _size,
                                  child: Text(
                                    _recentProducts?.elementAt(index).price ??
                                        "",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    maxLines: 1,
                                  ),
                                ),
                                if (!kIsWeb && Platform.isIOS)
                                  const SizedBox(
                                    height: 10,
                                  ),
                                SizedBox(
                                  width: _size,
                                  child: Text(
                                    _recentProducts?.elementAt(index).name ??
                                        "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _recentProducts?.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ],
            ),
          );
  }
}
