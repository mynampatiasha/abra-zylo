import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/models/product/product.dart';
import 'package:oc_demo/screens/category/widgets/product_list_item.dart';

import '../../../constants/app_routes.dart';
import '../../../constants/arguments_map.dart';
import '../../../hive/prefetch_service.dart';

class CatalogGridView extends StatelessWidget {
  const CatalogGridView(
      {Key? key, this.products, this.controller, this.addProductToWishList})
      : super(key: key);

  final List<Product>? products;
  final ScrollController? controller;
  final Function(String, int)? addProductToWishList;

  int getListLength() {
    print("Rishabh1");
    print(products?.length ?? 0);
    if (products == null) {
      return 0;
    } else {
      return products?.length.isEven == true
          ? products?.length ?? 0
          : products?.length ?? 0 + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    double targetWidth = AppSizes.deviceWidth / 2.94;
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (1 - (22 / targetWidth)),
      ),
      /* physics: const PageScrollPhysics(),*/
      itemCount: getListLength(),
      controller: controller,
      itemBuilder: (context, index) {
        var product = products?[index];
        /*if (controller?.position.userScrollDirection ==
            ScrollDirection.reverse)*/
        PrefetchService.preFetchProductDetails(product?.productId ?? '');
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoute.productPage,
              arguments: getProductDataAttributeMap(
                products![index].name ?? "",
                products![index].productId ?? "",
              ),
            );
          },
          child: ProductListItem(
            products![index],
            (value) {
              addProductToWishList!(value, index);
            },
            targetWidth,
            center: false,
          ),
        );
      },
    );
  }
}
