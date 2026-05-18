import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widgets/circle_page_indicator.dart';
import '../../../common_widgets/image_view.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../models/homPage/home_screen_model.dart';

class HomePageImageCarousel extends StatefulWidget {
  Banners? banner;
  HomePageImageCarousel(this.banner);

  @override
  _HomePageImageCarouselState createState() => _HomePageImageCarouselState();
}

class _HomePageImageCarouselState extends State<HomePageImageCarousel> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: AppSizes.size8,right: AppSizes.size8,top: AppSizes.size8),
        //   child: Text((widget.banner?.title??""),style: Theme.of(context).textTheme.headlineMedium),
        // ),
        // widgetSpace(0, AppSizes.size8),
        Padding(
          padding: const EdgeInsets.only(
              left: AppSizes.size8, right: AppSizes.size8, top: AppSizes.size8),
          child: GestureDetector(
            onTap: () async {
              switch (widget.banner?.type) {
                case "product":
                  Navigator.of(context).pushNamed(
                    AppRoute.productPage,
                    arguments: getProductDataAttributeMap(
                      widget.banner?.title ?? '',
                      widget.banner?.link ?? '',
                    ),
                  );
                  break;
                case "category":
                  Navigator.of(context).pushNamed(
                    AppRoute.catalog,
                    arguments: categoryMap(
                      widget.banner?.link ?? "",
                      widget.banner?.title ?? "",
                      "",
                    ),
                  );
                  break;
                case "manufacturer":
                  Navigator.of(context).pushNamed(
                    AppRoute.catalog,
                    arguments: categoryMap(
                      widget.banner?.link ?? "",
                      widget.banner?.title ?? "",
                      "",
                    ),
                  );
                  break;
                case "external_link":
                  final Uri url = Uri.parse(widget.banner?.link ?? "");
                  if (!await launchUrl(url,
                      mode: LaunchMode.externalApplication)) {
                    throw 'Could not launch $url';
                  }
                  break;
                default:
                  break;
              }
            },
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppSizes.size4, vertical: AppSizes.size4),
                  // semanticContainer: true,
                  // clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Theme.of(context).cardColor,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(0.0)),
                        child: ImageView(
                          url: widget.banner?.image ?? "",
                          width: double.infinity,
                          height: AppSizes.deviceWidth / 2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   width: AppSizes.deviceWidth,
                //   color: Theme.of(context).cardColor,
                //   child: Center(
                //     child: _buildCircularIndicator(_currentPageNotifier),
                //   ),
                // )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCircularIndicator(_currentPageNotifier) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.size8),
      child: CirclePageIndicator(
        size: 11,
        selectedSize: 11,
        dotColor: Colors.grey[300],
        selectedDotColor:
            Theme.of(context).bottomAppBarTheme.color ?? Colors.black,
        itemCount: 5,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
