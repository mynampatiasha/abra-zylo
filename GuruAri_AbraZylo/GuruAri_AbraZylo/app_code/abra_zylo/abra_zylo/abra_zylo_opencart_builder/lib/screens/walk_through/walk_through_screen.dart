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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/models/splash/splash_screen_model.dart';

import '../../common_widgets/circle_page_indicator.dart';
import '../../common_widgets/image_view.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';

class WalkThroughScreen extends StatefulWidget {
  WalkThroughScreen(this._walkthroughData, {Key? key}) : super(key: key);

  WalkthroughDataResponse? _walkthroughData;

  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  bool isLoading = false;
  var lst;

  bool flag = false;
  int showDescIndexValue = 0;
  List<WalkthroughData> itemListData = [];
  final _currentPageNotifier = ValueNotifier<int>(0);
  AppLocalizations? _localizations;

  void initState() {
    super.initState();
    itemListData.addAll(widget._walkthroughData?.walkthroughData! ?? []);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildUI()),
    );
  }

  Widget _buildUI() {
    if ((widget._walkthroughData?.walkthroughData ?? []).isEmpty) {
      AppSharedPref.setWalkThrough(false);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(
              "mainScreen",
              (route) => false,
            )
            .then((value) => SystemNavigator.pop());
      });
    }
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ((widget._walkthroughData?.walkthroughData ?? []).isNotEmpty)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /*const SizedBox(
                    height: 20,
                  ),*/
                  Column(
                    children: [
                      _buildPageView(),
                      /* const SizedBox(
                        height: AppSizes.normalPadding,
                      ),*/
                      SizedBox(
                        width: AppSizes.deviceWidth,
                        child: Center(
                          child: _buildCircularIndicator(_currentPageNotifier),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height:MediaQuery.of(context).size.width/10,),
                  if (_currentPageNotifier.value ==
                      (int.parse(
                              "${widget._walkthroughData?.walkthroughData?.length}") -
                          1))
                    Column(
                      children: [
                        labelLarge(),
                      ],
                    )
                  else
                    textButton()
                ],
              )
            : Container());
  }

  Widget _buildPageView() {
    return SizedBox(
        height: AppSizes.deviceHeight / 2.8 + 300,
        child: CarouselSlider.builder(
            itemCount: widget._walkthroughData?.walkthroughData?.length,
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPageNotifier.value = index;
                  showDescIndexValue = index;
                  flag = !flag;
                });
              },
              enlargeCenterPage: true,
              height: AppSizes.deviceHeight / 2.8 + 200,
              viewportFraction: 0.8,
              enableInfiniteScroll: false,
            ),
            itemBuilder: (context, index, i) {
              return InkWell(
                  onTap: () {},
                  child: Card(
                    color: Theme.of(context).cardColor,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 40, 30, 15.0),
                          child: SizedBox(
                            height: AppSizes.deviceHeight / 2.8,
                            width: AppSizes.deviceWidth / 1.5,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: ApiConstant.imageUrl(widget._walkthroughData
                                        ?.walkthroughData?[index].image ??
                                    ""),
                                fit: BoxFit.fitWidth,
                                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: AppSizes.deviceWidth / 1.8,
                          child: Text(
                              widget._walkthroughData?.walkthroughData?[index]
                                      .title ??
                                  "",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              child: ((widget
                                              ._walkthroughData
                                              ?.walkthroughData?[index]
                                              .content!
                                              .length ??
                                          0) <
                                      150)
                                  ? SizedBox(
                                      width: AppSizes.deviceWidth / 2,
                                      child: Text(
                                          widget
                                                  ._walkthroughData
                                                  ?.walkthroughData?[index]
                                                  .content ??
                                              "",
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14)),
                                    )
                                  : Column(
                                      children: <Widget>[
                                        Text(
                                          (widget
                                                  ._walkthroughData
                                                  ?.walkthroughData?[index]
                                                  .content ??
                                              ''),
                                          maxLines: (flag) ? 3 : 10000,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if ((widget
                                                    ._walkthroughData
                                                    ?.walkthroughData?[index]
                                                    .content
                                                    ?.length ??
                                                0) >
                                            170) ...[
                                          Visibility(
                                            visible: ((flag &&
                                                showDescIndexValue == index)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    child: Text(
                                                      ((flag &&
                                                              showDescIndexValue ==
                                                                  index))
                                                          ? "show_more"
                                                              .localized()
                                                          : "show_less"
                                                              .localized(),
                                                      style: const TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        showDescIndexValue =
                                                            index;
                                                        flag = !flag;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ]
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        if ((widget._walkthroughData?.walkthroughData?[index]
                                    .content?.length ??
                                0) >
                            170) ...[
                          Visibility(
                            visible: ((!flag && showDescIndexValue == index)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    child: Text(
                                      ((flag && showDescIndexValue == index))
                                          ? "show_more".localized()
                                          : "show_less".localized(),
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        showDescIndexValue = index;
                                        flag = !flag;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ],
                    ),
                  ));
            }));
  }

  Widget textButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(19.0, 0, 19.0, 0.0),
          child: SizedBox(
              height: 40,
              width: AppSizes.deviceWidth,
              child: ElevatedButton(
                onPressed: () {
                  AppSharedPref.setWalkThrough(false);
                  WidgetsBinding.instance?.addPostFrameCallback((_) async {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoute.bottomTabBAr, (Route<dynamic> route) => false);
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: MobikulTheme.accentColor,
                  ),
                ),
                child: Text(
                  AppStringConstant.skip.localized() ?? '',
                  // style: Theme.of(context).textTheme.titleLarge,
                ),
              )),
        ),
      ],
    );
  }

  Widget labelLarge() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(19.0, 0, 19.0, 0.0),
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                AppSharedPref.setWalkThrough(false);
                WidgetsBinding.instance?.addPostFrameCallback((_) async {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoute.bottomTabBAr, (Route<dynamic> route) => false);
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(context).textTheme.titleLarge?.color,
                side: const BorderSide(
                  color: MobikulTheme.accentColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      AppStringConstant.continues.localized(),
                      // style: Theme.of(context).textTheme.titleLarge?.copyWith(color:Theme.of(context).cardColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircularIndicator(_currentPageNotifier) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: CirclePageIndicator(
        dotColor: AppColors.lightGray,
        selectedDotColor:
            Theme.of(context).bottomAppBarTheme.color ?? Colors.black,
        itemCount: widget._walkthroughData?.walkthroughData?.length,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
