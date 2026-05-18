// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../common_widgets/circle_page_indicator.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';
import 'imaze_zoom_view.dart';

class ProductDetailsImageWidget extends StatefulWidget {
  List<Images> productImages;
  ProductDetailsImageWidget(this.productImages, {Key? key}) : super(key: key);
  @override
  _ProductDetailsImageWidgetState createState() =>
      _ProductDetailsImageWidgetState();
}

class _ProductDetailsImageWidgetState extends State<ProductDetailsImageWidget> {
  final _pageController = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);

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
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: AppSizes.deviceWidth,
            width: AppSizes.deviceWidth,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.productImages.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ZoomImageView(
                                productImages: widget.productImages,
                              )));
                    },
                    child: ImageView(
                      url: widget.productImages[index].popup,
                      fit: BoxFit.fill,
                    ));
              },
              onPageChanged: (int index) {
                _currentPageNotifier.value = index;
              },
            ),
          ),
          Container(
            width: AppSizes.deviceWidth,
            color: Theme.of(context).cardColor,
            child: Center(
              child: _buildCircularIndicator(_currentPageNotifier),
            ),
          )
        ],
      ),
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
        itemCount: widget.productImages.length,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
