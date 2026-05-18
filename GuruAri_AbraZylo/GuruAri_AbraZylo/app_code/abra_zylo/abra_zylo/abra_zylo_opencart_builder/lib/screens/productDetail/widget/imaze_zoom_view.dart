import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../common_widgets/image_view.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';
import '../product_page_image_indicator.dart';

class ZoomImageView extends StatefulWidget {
  ZoomImageView({Key? key, this.productImages}) : super(key: key);
  List<Images>? productImages;

  @override
  _ZoomImageViewState createState() => _ZoomImageViewState();
}

class _ZoomImageViewState extends State<ZoomImageView> {
  var _pageController = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);
  double? imageSize;

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).brightness);
    imageSize ??= (AppSizes.deviceWidth / 4);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: AppSizes.size14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: AppSizes.size16,
                        right: AppSizes.size16,
                        left: AppSizes.size16,
                        bottom: AppSizes.size8),
                    child: Image.asset(AppImages.cancelIcon,
                        width: AppSizes.size16,
                        height: AppSizes.size16,
                        color: Colors.black),
                  )),
              //widgetSpace(),
              Expanded(
                child: PhotoViewGallery.builder(
                  backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  pageController: _pageController,
                  // controller: _pageController,
                  itemCount: widget.productImages?.length,
                  onPageChanged: (int index) {
                    _currentPageNotifier.value = index;
                  },
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      maxScale: PhotoViewComputedScale.contained * 6,
                      minScale: PhotoViewComputedScale.contained,
                      imageProvider: NetworkImage(
                        ApiConstant.imageUrl(widget.productImages?[index].popup ?? ''),
                      ),
                    );
                  },
                ),
              ),
              _buildCircularIndicator(_currentPageNotifier),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: AppSizes.marginFive,vertical:AppSizes.spacingDefault ),
              //   child: SizedBox(
              //     height: (AppSizes.width / 4),
              //     child: ListView.builder(
              //         physics: const ClampingScrollPhysics(),
              //         shrinkWrap: true,
              //         scrollDirection: Axis.horizontal,
              //         itemCount: widget.productImages?.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           return GestureDetector(
              //             onTap: () {
              //               //todo
              //               setState(() {
              //                 _pageController = PageController(initialPage: index);
              //               });
              //             },
              //             child: ImageView(
              //               url: widget.productImages?[index].thumb,
              //               width: imageSize!,
              //               height: imageSize!,
              //               fit: BoxFit.fill,
              //             ),
              //           );
              //         }),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularIndicator(_currentPageNotifier) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ProductPageImageIndicator(
        dotColor: AppColors.darkGray,
        selectedDotColor:
            Theme.of(context).bottomAppBarTheme.color ?? Colors.black,
        itemCount: widget.productImages?.length,
        currentPageNotifier: _currentPageNotifier,
        productImages: widget.productImages,
        onPageSelected: (int index) {
          _currentPageNotifier.value = index;
          setState(() {
            _pageController.animateToPage(index,
                curve: Curves.ease, duration: Duration(milliseconds: 300));
          });
        },
      ),
    );
  }
}
