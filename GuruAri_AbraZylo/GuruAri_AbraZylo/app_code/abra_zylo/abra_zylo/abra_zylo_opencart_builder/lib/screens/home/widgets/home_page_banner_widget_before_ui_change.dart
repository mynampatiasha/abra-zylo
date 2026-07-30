/*
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/hive/prefetch_service.dart';

import '../../../common_widgets/circle_page_indicator.dart';
import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../models/homPage/home_screen_model.dart';

class HomePageBannerWidget extends StatefulWidget {
  List<Banners> banners = [];

  HomePageBannerWidget(this.banners);

  @override
  _HomePageBannerWidgetState createState() => _HomePageBannerWidgetState();
}

class _HomePageBannerWidgetState extends State<HomePageBannerWidget> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < widget.banners.length-1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 60), curve: Curves.easeIn);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSizes.size4,top:0,right:AppSizes.size4,bottom:0),
          child: Container(
            padding: const EdgeInsets.only(top: AppSizes.size16),
            height: AppSizes.deviceWidth / 2,
            width: AppSizes.deviceWidth.toDouble(),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.banners.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                   */
/* final String response = await rootBundle.loadString('assets/languages/ar.json');
                    final data = await json.decode(response);
                    final Map<dynamic,dynamic> dataMap = data.map((key, value) => MapEntry(key.toString(), value));
                    dataMap.forEach((key, value) {
                      String f="<string name="+"${key}"+"> ${value}</string>";
                      print(f);
                    });*/ /*

                   // data

                    switch (widget.banners[index].type) {
                      case "product":
                        Navigator.of(context).pushNamed(
                          AppRoute.productPage,
                          arguments: getProductDataAttributeMap(
                            widget.banners[index].title ?? '',
                            widget.banners[index].link ?? '',
                          ),
                        );
                        PrefetchService.preFetchProductDetails(widget.banners[index].link);
                        break;
                      case "category":
                        Navigator.of(context).pushNamed(
                          AppRoute.catalog,
                          arguments: categoryMap(
                            widget.banners[index].link ?? "",
                            widget.banners[index].title ?? "",
                            "",
                          ),

                        );
                        PrefetchService.preFetchCategoryProduct( widget.banners[index].link);
                        break;
                      case "manufacturer":
                        Navigator.of(context).pushNamed(
                          AppRoute.catalog,
                          arguments: categoryMap(
                            widget.banners[index].link ?? "",
                            widget.banners[index].title ?? "",
                            "",
                          ),
                        );
                        PrefetchService.preFetchManuffacture( widget.banners[index].link);
                        break;
                      default:
                        break;
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: AppSizes.size4, vertical: AppSizes.size4),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.size4),
                    ),
                    elevation: AppSizes.size4,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(0.0)),
                          child: ImageView(
                            url: widget.banners[index].image!,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onPageChanged: (int index) {
                _currentPageNotifier.value = index;
              },
            ),
          ),
        ),
        if ((widget.banners.length) > 1)
          Center(
            child: _buildCircularIndicator(_currentPageNotifier),
          )
      ],
    );
  }

  Widget _buildCircularIndicator(_currentPageNotifier) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.size8),
      child: CirclePageIndicator(
        itemCount: widget.banners.length,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/homPage/home_screen_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widgets/circle_page_indicator.dart';
import '../../../common_widgets/image_view.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';

class HomePageBannerWidget extends StatefulWidget {
  List<SliderImages> banners = [];
  String title;

  HomePageBannerWidget(this.banners, this.title);

  @override
  _HomePageBannerWidgetState createState() => _HomePageBannerWidgetState();
}

class _HomePageBannerWidgetState extends State<HomePageBannerWidget> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < widget.banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 60), curve: Curves.easeIn);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: AppSizes.size8, right: AppSizes.size8),
          child: Text(widget.title ?? "",
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        Container(
          margin: const EdgeInsets.only(top: AppSizes.size16),
          height: AppSizes.deviceWidth / 2,
          width: AppSizes.deviceWidth.toDouble(),
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async {
                  /* final String response = await rootBundle.loadString('assets/languages/ar.json');
                  final data = await json.decode(response);
                  final Map<dynamic,dynamic> dataMap = data.map((key, value) => MapEntry(key.toString(), value));
                  dataMap.forEach((key, value) {
                    String f="<string name="+"${key}"+"> ${value}</string>";
                    print(f);
                  });*/
                  // data

                  print("Rishabh Banner");
                  print(widget.banners);
                  switch (widget.banners[index].type) {
                    case "product":
                      Navigator.of(context).pushNamed(
                        AppRoute.productPage,
                        arguments: getProductDataAttributeMap(
                          widget.banners[index].title ?? '',
                          widget.banners[index].link ?? '',
                        ),
                      );
                      break;
                    case "category":
                      Navigator.of(context).pushNamed(
                        AppRoute.catalog,
                        arguments: categoryMap(
                          widget.banners[index].link ?? "",
                          widget.banners[index].title ?? "",
                          "",
                        ),
                      );
                      break;
                    case "manufacturer":
                      Navigator.of(context).pushNamed(
                        AppRoute.catalog,
                        arguments: categoryMap(
                          widget.banners[index].link ?? "",
                          widget.banners[index].title ?? "",
                          "",
                        ),
                      );
                      break;
                    case "extenal_link":
                      final Uri url =
                          Uri.parse(widget.banners[index].link ?? "");
                      if (!await launchUrl(url,
                          mode: LaunchMode.externalApplication)) {
                        throw 'Could not launch $url';
                      }
                      break;
                    default:
                      break;
                  }
                },
                child: Card(
                  // color: Colors.red,
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppSizes.size8, vertical: AppSizes.size4),
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.size4),
                  ),
                  elevation: AppSizes.size4,
                  //color: Colors.white,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(0.0)),
                        child: ImageView(
                          url: widget.banners[index].image!,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            },
          ),
        ),
        if ((widget.banners.length) > 1)
          Center(
            child: _buildCircularIndicator(_currentPageNotifier),
          )
      ],
    );
  }

  Widget _buildCircularIndicator(_currentPageNotifier) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.size8),
      child: CirclePageIndicator(
        itemCount: widget.banners.length,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
