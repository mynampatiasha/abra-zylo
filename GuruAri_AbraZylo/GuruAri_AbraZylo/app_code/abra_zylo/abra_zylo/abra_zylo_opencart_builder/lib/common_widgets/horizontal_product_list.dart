import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/product/product.dart';
import 'package:oc_demo/screens/category/widgets/product_list_item.dart';

class HorizontalProductList extends StatelessWidget {
  HorizontalProductList({this.products, this.addProductToWishList, Key? key})
      : super(key: key);
  final Function(String, int)? addProductToWishList;
  final List<Product>? products;

  @override
  Widget build(BuildContext context) {
    double targetWidth = AppSizes.deviceWidth / 2.94;
    return SizedBox(
      height: AppSizes.deviceWidth / 1.66,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: products?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          var data = products![index];
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoute.productPage,
                  arguments: getProductDataAttributeMap(
                    data.name ?? "",
                    data.productId ?? "",
                  ),
                );
              },
              child: ProductListItem(data, (value) {
                addProductToWishList!(value, index);
              }, targetWidth),
            ),
          );
        },
      ),
    );
  }
}
