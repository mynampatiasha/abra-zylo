/*
import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';

import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../hive/prefetch_service.dart';
import '../../../models/homPage/home_screen_model.dart';

Widget homePageCarouselWidget(
    BuildContext context, List<Carousel>? carouselList) {
  return SizedBox(
    height: (AppSizes.deviceWidth / 2.2),
    child: ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: carouselList!.length,
      itemBuilder: (BuildContext context, int index) {
        var data = carouselList[index];
        Future.delayed(const Duration(seconds: 10), (){
          // call API functionality
          PrefetchService.preFetchManuffacture(data.link??'');
        });
        return homePageCarouselItem(context, carouselList[index]);
      },
      separatorBuilder: (BuildContext context, int index) => widgetSpace(1, 8),
    ),
  );
}

Widget homePageCarouselItem(BuildContext context, Carousel carousel) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pushNamed(
        AppRoute.catalog,
        arguments: categoryMap(
          carousel.link ?? "",
          carousel.title ?? "",
          "",
          true,
        ),
      );
    },
    child: Container(
      width: AppSizes.deviceWidth / 3,
      decoration: BoxDecoration(
          border: Border.all(
        color: AppColors.background,
      )),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(children: <Widget>[
            Center(
              child: ImageView(
                url: carousel.image,
                width: (AppSizes.deviceWidth / 3),
                height: (AppSizes.deviceWidth / 3),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSizes.size8,
              top: AppSizes.size8,
              bottom: AppSizes.size8,
            ),
            child: Center(
              child: Text(
                carousel.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
*/

import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';

import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../models/homPage/home_screen_model.dart';

Widget homePageCarouselWidget(
    BuildContext context, List<ImageManufacturer>? carouselList) {
  print("pankaj " + carouselList!.length!.toString());
  return Container(
    padding: const EdgeInsets.all(AppSizes.size4),
    constraints:
        BoxConstraints(minHeight: 10, maxHeight: (AppSizes.deviceWidth / 2.10)),
    // height: (AppSizes.deviceWidth / 2.20),
    child: ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: carouselList.length,
      itemBuilder: (BuildContext context, int index) {
        return homePageCarouselItem(context, carouselList[index]);
      },
      separatorBuilder: (BuildContext context, int index) => widgetSpace(1, 8),
    ),
  );
}

Widget homePageCarouselItem(BuildContext context, ImageManufacturer carousel) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pushNamed(
        AppRoute.catalog,
        arguments: categoryMap(
          carousel.manufacturerId ?? "",
          carousel.name ?? "",
          "",
          true,
        ),
      );
    },
    child: Card(
      color: Theme.of(context).cardColor,
      child: SizedBox(
        width: AppSizes.deviceWidth / 2.8,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: ImageView(
                    url: carousel.image,
                    width: (AppSizes.deviceWidth / 3.0),
                    height: (AppSizes.deviceWidth / 3.0),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(
                left: AppSizes.size8,
                top: AppSizes.size8,
                bottom: AppSizes.size8,
              ),
              child: Center(
                child: Text(
                  carousel.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
