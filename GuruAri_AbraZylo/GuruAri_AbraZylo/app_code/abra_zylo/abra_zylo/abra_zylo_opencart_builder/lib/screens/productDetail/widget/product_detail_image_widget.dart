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
    if (widget.productImages.isEmpty) {
      return const SizedBox.shrink();
    }
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
                return InteractiveViewer(
                  panEnabled: true,
                  minScale: 1,
                  maxScale: 4,
                  child: ImageView(
                    url: widget.productImages[index].popup,
                    fit: BoxFit.contain,
                  ),
                );
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
              child: _buildThumbnailGallery(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildThumbnailGallery() {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.productImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: ValueListenableBuilder<int>(
              valueListenable: _currentPageNotifier,
              builder: (context, currentIndex, child) {
                bool isSelected = currentIndex == index;
                return Container(
                  width: 70,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: ImageView(
                      url: widget.productImages[index].thumb ?? widget.productImages[index].popup,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
