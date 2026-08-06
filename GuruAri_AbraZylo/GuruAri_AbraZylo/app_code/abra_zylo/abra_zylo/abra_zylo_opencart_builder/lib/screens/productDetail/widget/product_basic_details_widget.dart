import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_bloc.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_event.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_state.dart';
import 'package:oc_demo/screens/productDetail/widget/review/rating_container.dart';
import 'package:share_plus/share_plus.dart';

import '../../../common_widgets/dialog_helper.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../helper/open_bottom_model_sheet_helper.dart';

class ProductPageBasicDetailsWidget extends StatefulWidget {
  final ProductDetailScreenModel? product;
  bool addedToWishlist = false;
  ProductDetailBloc? productPageBloc;

  ProductPageBasicDetailsWidget(this.addedToWishlist, this.productPageBloc,
      {super.key, this.product});

  @override
  State<StatefulWidget> createState() {
    return ProductPageBasicDetailsWidgetState();
  }
}

class ProductPageBasicDetailsWidgetState
    extends State<ProductPageBasicDetailsWidget> {
  AppLocalizations? _localizations;
  bool? isDarkMode;
  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    print("====> ${widget.addedToWishlist}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(AppSizes.size16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                toTitleCase(widget.product?.name ?? ""),
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTrustBadge(Icons.verified_outlined, '100%', 'Original'),
                  _buildTrustBadge(Icons.shield_outlined, 'Secure', 'Payment'),
                  _buildTrustBadge(Icons.star_border_purple500_outlined, 'Assured', 'Quality'),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1, thickness: 1, color: AppColors.textBorderColor),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    (widget.product?.formattedSpecial ?? "") != "" && (widget.product?.formattedSpecial ?? "") != "0" 
                        ? widget.product?.formattedSpecial ?? ''
                        : widget.product?.price ?? '',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if ((widget.product?.formattedSpecial ?? "") != "" && (widget.product?.formattedSpecial ?? "") != "0")
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('SALE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              if ((widget.product?.formattedSpecial ?? "") != "" && (widget.product?.formattedSpecial ?? "") != "0")
                Text(
                  'MRP ${widget.product?.price ?? ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.gray,
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    (widget.product?.stock ?? "In Stock").toLowerCase().contains("out of stock") ? Icons.cancel : Icons.check_circle, 
                    color: (widget.product?.stock ?? "In Stock").toLowerCase().contains("out of stock") ? Colors.red : AppColors.green, 
                    size: 20
                  ),
                  const SizedBox(width: 4),
                  Text(
                    (widget.product?.stock ?? "").isNotEmpty ? widget.product!.stock! : 'In Stock',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: (widget.product?.stock ?? "In Stock").toLowerCase().contains("out of stock") ? Colors.red : AppColors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (widget.product?.manufacturer?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text("${_localizations?.translate(AppStringConstant.manufacturer)} : ", style: const TextStyle(color: AppColors.gray, fontWeight: FontWeight.w400)),
                      Text(widget.product?.manufacturer ?? '', style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w700))
                    ],
                  ),
                ),
              if (widget.product?.model?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text("${_localizations?.translate(AppStringConstant.model)} : ", style: const TextStyle(color: AppColors.gray, fontWeight: FontWeight.w400)),
                      Expanded(
                        child: Text(
                          widget.product?.model ?? '',
                          style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrustBadge(IconData icon, String line1, String line2) {
    return Column(
      children: [
        Icon(icon, color: AppColors.black, size: 28),
        const SizedBox(height: 4),
        Text(line1, style: const TextStyle(fontSize: 12, color: AppColors.black, fontWeight: FontWeight.w600)),
        Text(line2, style: const TextStyle(fontSize: 11, color: AppColors.gray)),
      ],
    );
  }

  /*
  * review count
  * */
  Widget productReviews(int totalReview, double avgReview) {
    return Row(
      children: [
        RatingContainer(avgReview),
        const SizedBox(
          width: AppSizes.size14,
        ),
        Text(
          "$totalReview ${_localizations?.translate(AppStringConstant.reviews) ?? ''}",
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }

/*
* Wishlist and share labelLarge widget
*
* */

  Widget wishListAndShareButtonView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(
                width: 0.5,
                // width: MediaQuery.of(context).size.width * 0.0005,
                color: Colors.grey,
              ),
              shape: const RoundedRectangleBorder(),

              backgroundColor: Theme.of(context).cardColor, // background
              foregroundColor: Colors.black, // foreground
            ),
            // style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
            onPressed: () async {
              /*
              * Share labelLarge Functionality
              * */
              //var productUrl = "${ApiConstant.baseUrl}${widget.product?.href ?? ""}?productId=${widget.product?.productId ?? 0}&productName=${widget.product?.name ?? ""}";
              // share_plus replaces flutter_share because Flutter 3.38 removed v1 Android embedding APIs.
              await SharePlus.instance.share(ShareParams(
                title: widget.product?.name ?? '',
                text: widget.product?.href ?? "",
              ));
            },
            child: SizedBox(
              child: Row(
                // mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    //  size: AppSizes.size22,
                    size: MediaQuery.of(context).size.width * 0.040,
                    Icons.share,
                    // color: Colors.white ,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  SizedBox(
                    //  width: AppSizes.size8,
                    width: MediaQuery.of(context).size.width * 0.015,
                  ),
                  Expanded(
                    child: Text(
                        _localizations?.translate(AppStringConstant.share) ??
                            "",
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color:
                                Theme.of(context).textTheme.titleLarge!.color,
                            fontSize: AppSizes.size12,
                            fontWeight: FontWeight.w500)
                        // style: Theme.of(context)
                        //     .textTheme
                        //     .displayMedium
                        //     ?.copyWith(
                        //         fontWeight: FontWeight.w500,
                        //         color: Colors.black45,
                        //         fontSize:
                        //             MediaQuery.of(context).size.width *
                        //                 0.030)

                        ),
                  )
                ],
              ),
            ),
          ),
        ),
        //AAA
        //WishList view
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(
                width: 0.5,
                // width: MediaQuery.of(context).size.width * 0.0005,
                color: Colors.grey,
              ),
              shape: const RoundedRectangleBorder(),

              backgroundColor: Theme.of(context).cardColor, // background
              foregroundColor: Colors.black, // foreground
            ),
            //  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
            onPressed: () async {
              /*
                * WishList labelLarge functionality
                *
                * */
              print("====> ${widget.addedToWishlist}");
              print(" Product Id  is >>>>> ${widget.product?.productId}");
              if (await AppSharedPref.isLogin() == true) {
                widget.productPageBloc?.add(AddProductToWishListEvent(
                    widget.product?.productId?.toString() ?? ""));
                widget.productPageBloc?.emit(ProductDetailStateInitial());
                setState(() {});
              } else {
                DialogHelper.wishlistConfirmationDialog(
                    "${_localizations?.translate(AppStringConstant.wishlistDesc)}",
                    "${_localizations?.translate(AppStringConstant.loginRequired)}",
                    context,
                    _localizations, onConfirm: () async {
                  Navigator.of(context).pushNamed(
                    AppRoute.login,
                    arguments: getSignInSignUpPageArgument(false, false),
                  );
                });
              }
            },
            child: Container(
              child: Row(
                //  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    // widget.addedToWishlist ||
                    //         widget.product?.wishlistStatus == true
                    //     ? Icons.favorite_rounded
                    //     :
                    Icons.favorite,
                    color: widget.addedToWishlist ||
                            widget.product?.wishlistStatus == true
                        ? AppColors.red
                        : Theme.of(context).iconTheme.color,
                    // size: AppSizes.size22,
                    size: MediaQuery.of(context).size.width * 0.040,
                  ),
                  SizedBox(
                    //  width: AppSizes.size8,
                    width: MediaQuery.of(context).size.width * 0.015,
                  ),
                  Expanded(
                    child: Text(
                        _localizations
                                ?.translate(AppStringConstant.wishList)
                                .toUpperCase() ??
                            '',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color:
                                Theme.of(context).textTheme.titleLarge!.color,
                            fontSize: AppSizes.size12,
                            fontWeight: FontWeight.w500)
                        // style:
                        //     //TextStyle(color: Colors.grey, fontSize: 12)
                        //     Theme.of(context).textTheme.titleLarge?.copyWith(
                        //         color: Colors.black45,
                        //         fontWeight: FontWeight.w500,
                        //         fontSize:
                        //             MediaQuery.of(context).size.width *
                        //                 0.030)

                        ),
                  )
                ],
              ),
            ),
          ),
        ),
        // const SizedBox(
        //   width: AppSizes.size8 / 2,
        // ),
        // Compare button removed as per requirements
        // const SizedBox(
        //   width: AppSizes.size8 / 2,
        // ),
        //Share labelLarge view
        // Expanded(
        //   flex: 1,
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       side: const BorderSide(
        //         width: 0.5,
        //         color: Colors.grey,
        //       ),
        //       shape: RoundedRectangleBorder(),
        //
        //       backgroundColor: Colors.white, // background
        //       foregroundColor: Colors.black, // foreground
        //     ),
        //     // style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
        //     onPressed: () async {
        //       /*
        //       * Share labelLarge Functionality
        //       * */
        //       //var productUrl = "${ApiConstant.baseUrl}${widget.product?.href ?? ""}?productId=${widget.product?.productId ?? 0}&productName=${widget.product?.name ?? ""}";
        //       await FlutterShare.share(
        //           title: widget.product?.name ?? '',
        //           text: '',
        //           linkUrl: widget.product?.href ?? "",
        //           chooserTitle: '');
        //     },
        //     child: Row(
        //       mainAxisSize: MainAxisSize.max,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Icon(
        //           Icons.share,
        //           // color: Colors.white ,
        //           color: AppColors.lightGray,
        //         ),
        //         const SizedBox(
        //           width: AppSizes.size8 / 2,
        //         ),
        //         Text(
        //             _localizations?.translate(AppStringConstant.share) ??
        //                 "",
        //             style: Theme.of(context)
        //                 .textTheme
        //                 .titleLarge
        //                 ?.copyWith(color: Colors.grey))
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
// Widget wishListAndShareButtonView() {
//   return SizedBox(
//       // color: Colors.red,
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height * 0.05,
//       // height: AppSizes.deviceHeight / 21,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               side: const BorderSide(
//                 width: 0.5,
//                 // width: MediaQuery.of(context).size.width * 0.0005,
//                 color: Colors.grey,
//               ),
//               shape: const RoundedRectangleBorder(),
//
//               backgroundColor: Colors.white, // background
//                // foreground
//             ),
//             // style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
//             onPressed: () async {
//               /*
//               * Share labelLarge Functionality
//               * */
//               //var productUrl = "${ApiConstant.baseUrl}${widget.product?.href ?? ""}?productId=${widget.product?.productId ?? 0}&productName=${widget.product?.name ?? ""}";
//               await FlutterShare.share(
//                   title: widget.product?.name ?? '',
//                   text: '',
//                   linkUrl: widget.product?.href ?? "",
//                   chooserTitle: '');
//             },
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width / 5,
//               child: Row(
//                 // mainAxisSize: MainAxisSize.max,
//                 // mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     //  size: AppSizes.size22,
//                     size: MediaQuery.of(context).size.width * 0.040,
//                     Icons.share,
//                     // color: Colors.white ,
//                     color: AppColors.gray,
//                   ),
//                   SizedBox(
//                     //  width: AppSizes.size8,
//                     width: MediaQuery.of(context).size.width * 0.020,
//                   ),
//                   Text(
//                       _localizations?.translate(
//                               AppStringConstant.share) ??
//                           "",
//                       style: Theme.of(context)
//                           .textTheme
//                           .displayMedium
//                           ?.copyWith(
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black45,
//                               fontSize:
//                                   MediaQuery.of(context).size.width *
//                                       0.030))
//                 ],
//               ),
//             ),
//           ),
//           //AAA
//           //WishList view
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               side: const BorderSide(
//                 width: 0.5,
//                 // width: MediaQuery.of(context).size.width * 0.0005,
//                 color: Colors.grey,
//               ),
//               shape: const RoundedRectangleBorder(),
//
//               backgroundColor: Colors.white, // background
//
//             ),
//             //  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
//             onPressed: () async {
//               /*
//                 * WishList labelLarge functionality
//                 *
//                 * */
//
//               if (await AppSharedPref.isLogin() == true) {
//                 widget.productPageBloc?.add(AddProductToWishListEvent(
//                     widget.product?.productId?.toString() ?? ""));
//                 widget.productPageBloc?.emit(ProductDetailStateInitial());
//                 setState(() {});
//               } else {
//                 DialogHelper.wishlistConfirmationDialog(
//                     "${_localizations?.translate(AppStringConstant.wishlistDesc)}",
//                     "${_localizations?.translate(AppStringConstant.loginRequired)}",
//                     context,
//                     _localizations, onConfirm: () async {
//                   Navigator.of(context).pushNamed(
//                     AppRoute.login,
//                     arguments: getSignInSignUpPageArgument(false, false),
//                   );
//                 });
//               }
//             },
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width / 4.62,
//               child: Row(
//                 //  mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     // widget.addedToWishlist ||
//                     //         widget.product?.wishlistStatus == true
//                     //     ? Icons.favorite_rounded
//                     //     :
//                     Icons.favorite,
//                     color: widget.addedToWishlist ||
//                             widget.product?.wishlistStatus == true
//                         ? AppColors.red
//                         : AppColors.gray,
//                     // size: AppSizes.size22,
//                     size: MediaQuery.of(context).size.width * 0.045,
//                   ),
//                   SizedBox(
//                     //  width: AppSizes.size8,
//                     width: MediaQuery.of(context).size.width * 0.020,
//                   ),
//                   Text(
//                       _localizations
//                               ?.translate(AppStringConstant.wishList)
//                               .toUpperCase() ??
//                           '',
//                       style:
//                           //TextStyle(color: Colors.grey, fontSize: 12)
//                           Theme.of(context).textTheme.titleLarge?.copyWith(
//                               color: Colors.black45,
//                               fontWeight: FontWeight.w500,
//                               fontSize:
//                                   MediaQuery.of(context).size.width *
//                                       0.030))
//                 ],
//               ),
//             ),
//           ),
//           // const SizedBox(
//           //   width: AppSizes.size8 / 2,
//           // ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               side: const BorderSide(
//                 width: 0.5,
//                 // width: MediaQuery.of(context).size.width * 0.0005,
//                 color: Colors.grey,
//               ),
//               shape: const RoundedRectangleBorder(),
//
//               backgroundColor: Colors.white, // background
//
//             ),
//             //style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
//             onPressed: () {
//               widget?.productPageBloc?.emit(ProductDetailStateInitial());
//               widget?.productPageBloc?.add(
//                   AddCompareProduct(widget.product?.productId?.toString()));
//             },
//             child: Container(
//               width: MediaQuery.of(context).size.width / 4.62,
//               child: Row(
//                 // mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     //size: AppSizes.size22,
//                     size: MediaQuery.of(context).size.width * 0.045,
//                     Icons.compare_arrows_rounded,
//                     // color: Colors.white,
//                     color: AppColors.gray,
//                   ),
//                   SizedBox(
//                     //  width: AppSizes.size8,
//                     width: MediaQuery.of(context).size.width * 0.020,
//                   ),
//                   Text(
//                     _localizations
//                             ?.translate(AppStringConstant.compares) ??
//                         "",
//                     // style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     //     color: Colors.black45,
//                     //     fontSize: MediaQuery.of(context).size.width * 0.034),
//                     style: TextStyle(
//                         color: Colors.black45,
//                         fontWeight: FontWeight.w500,
//                         fontSize:
//                             MediaQuery.of(context).size.width * 0.030),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           // const SizedBox(
//           //   width: AppSizes.size8 / 2,
//           // ),
//           //Share labelLarge view
//           // Expanded(
//           //   flex: 1,
//           //   child: ElevatedButton(
//           //     style: ElevatedButton.styleFrom(
//           //       side: const BorderSide(
//           //         width: 0.5,
//           //         color: Colors.grey,
//           //       ),
//           //       shape: RoundedRectangleBorder(),
//           //
//           //       backgroundColor: Colors.white, // background
//           //       foregroundColor: Colors.black, // foreground
//           //     ),
//           //     // style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
//           //     onPressed: () async {
//           //       /*
//           //       * Share labelLarge Functionality
//           //       * */
//           //       //var productUrl = "${ApiConstant.baseUrl}${widget.product?.href ?? ""}?productId=${widget.product?.productId ?? 0}&productName=${widget.product?.name ?? ""}";
//           //       await FlutterShare.share(
//           //           title: widget.product?.name ?? '',
//           //           text: '',
//           //           linkUrl: widget.product?.href ?? "",
//           //           chooserTitle: '');
//           //     },
//           //     child: Row(
//           //       mainAxisSize: MainAxisSize.max,
//           //       mainAxisAlignment: MainAxisAlignment.center,
//           //       children: [
//           //         Icon(
//           //           Icons.share,
//           //           // color: Colors.white ,
//           //           color: AppColors.lightGray,
//           //         ),
//           //         const SizedBox(
//           //           width: AppSizes.size8 / 2,
//           //         ),
//           //         Text(
//           //             _localizations?.translate(AppStringConstant.share) ??
//           //                 "",
//           //             style: Theme.of(context)
//           //                 .textTheme
//           //                 .titleLarge
//           //                 ?.copyWith(color: Colors.grey))
//           //       ],
//           //     ),
//           //   ),
//           // ),
//         ],
//       ));
// }
// Widget wishListAndShareButtonView() {
//   return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height * 0.05,
//       // height: AppSizes.deviceHeight / 21,
//       child: Expanded(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 side: const BorderSide(
//                   width: 0.5,
//                   // width: MediaQuery.of(context).size.width * 0.0005,
//                   color: Colors.grey,
//                 ),
//                 shape: const RoundedRectangleBorder(),
//
//                 backgroundColor: Colors.white, // background
//                 foregroundColor: Colors.black, // foreground
//               ),
//               // style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
//               onPressed: () async {
//                 /*
//                 * Share labelLarge Functionality
//                 * */
//                 //var productUrl = "${ApiConstant.baseUrl}${widget.product?.href ?? ""}?productId=${widget.product?.productId ?? 0}&productName=${widget.product?.name ?? ""}";
//                 await FlutterShare.share(
//                     title: widget.product?.name ?? '',
//                     text: '',
//                     linkUrl: widget.product?.href ?? "",
//                     chooserTitle: '');
//               },
//               child: Expanded(
//                 child: Row(
//                   // mainAxisSize: MainAxisSize.max,
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       //  size: AppSizes.size22,
//                       size: MediaQuery.of(context).size.width * 0.040,
//                       Icons.share,
//                       // color: Colors.white ,
//                       color: AppColors.gray,
//                     ),
//                     SizedBox(
//                       //  width: AppSizes.size8,
//                       width: MediaQuery.of(context).size.width * 0.020,
//                     ),
//                     Text(
//                         _localizations?.translate(AppStringConstant.share) ??
//                             "",
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayMedium
//                             ?.copyWith(
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.black45,
//                                 fontSize: MediaQuery.of(context).size.width *
//                                     0.030))
//                   ],
//                 ),
//               ),
//             ),
//             //AAA
//             //WishList view
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 side: const BorderSide(
//                   width: 0.5,
//                   // width: MediaQuery.of(context).size.width * 0.0005,
//                   color: Colors.grey,
//                 ),
//                 shape: const RoundedRectangleBorder(),
//
//                 backgroundColor: Colors.white, // background
//                 foregroundColor: Colors.black, // foreground
//               ),
//               //  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
//               onPressed: () async {
//                 /*
//                   * WishList labelLarge functionality
//                   *
//                   * */
//
//                 if (await AppSharedPref.isLogin() == true) {
//                   widget.productPageBloc?.add(AddProductToWishListEvent(
//                       widget.product?.productId?.toString() ?? ""));
//                   widget.productPageBloc?.emit(ProductDetailStateInitial());
//                   setState(() {});
//                 } else {
//                   DialogHelper.wishlistConfirmationDialog(
//                       "${_localizations?.translate(AppStringConstant.wishlistDesc)}",
//                       "${_localizations?.translate(AppStringConstant.loginRequired)}",
//                       context,
//                       _localizations, onConfirm: () async {
//                     Navigator.of(context).pushNamed(
//                       AppRoute.login,
//                       arguments: getSignInSignUpPageArgument(false, false),
//                     );
//                   });
//                 }
//               },
//               child: Expanded(
//                 child: Row(
//                   //  mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       // widget.addedToWishlist ||
//                       //         widget.product?.wishlistStatus == true
//                       //     ? Icons.favorite_rounded
//                       //     :
//                       Icons.favorite,
//                       color: widget.addedToWishlist ||
//                               widget.product?.wishlistStatus == true
//                           ? AppColors.red
//                           : AppColors.gray,
//                       // size: AppSizes.size22,
//                       size: MediaQuery.of(context).size.width * 0.045,
//                     ),
//                     SizedBox(
//                       //  width: AppSizes.size8,
//                       width: MediaQuery.of(context).size.width * 0.020,
//                     ),
//                     Text(
//                         _localizations
//                                 ?.translate(AppStringConstant.wishList)
//                                 .toUpperCase() ??
//                             '',
//                         style:
//                             //TextStyle(color: Colors.grey, fontSize: 12)
//                             Theme.of(context).textTheme.titleLarge?.copyWith(
//                                 color: Colors.black45,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: MediaQuery.of(context).size.width *
//                                     0.030))
//                   ],
//                 ),
//               ),
//             ),
//             // const SizedBox(
//             //   width: AppSizes.size8 / 2,
//             // ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 side: const BorderSide(
//                   width: 0.5,
//                   // width: MediaQuery.of(context).size.width * 0.0005,
//                   color: Colors.grey,
//                 ),
//                 shape: const RoundedRectangleBorder(),
//
//                 backgroundColor: Colors.white, // background
//                 foregroundColor: Colors.black, // foreground
//               ),
//               //style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
//               onPressed: () {
//                 widget?.productPageBloc?.emit(ProductDetailStateInitial());
//                 widget?.productPageBloc?.add(
//                     AddCompareProduct(widget.product?.productId?.toString()));
//               },
//               child: Expanded(
//                 child: Row(
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       //size: AppSizes.size22,
//                       size: MediaQuery.of(context).size.width * 0.045,
//                       Icons.compare_arrows_rounded,
//                       // color: Colors.white,
//                       color: AppColors.gray,
//                     ),
//                     SizedBox(
//                       //  width: AppSizes.size8,
//                       width: MediaQuery.of(context).size.width * 0.020,
//                     ),
//                     Text(
//                       _localizations?.translate(AppStringConstant.compares) ??
//                           "",
//                       // style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       //     color: Colors.black45,
//                       //     fontSize: MediaQuery.of(context).size.width * 0.034),
//                       style: TextStyle(
//                           color: Colors.black45,
//                           fontWeight: FontWeight.w500,
//                           fontSize:
//                               MediaQuery.of(context).size.width * 0.030),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             // const SizedBox(
//             //   width: AppSizes.size8 / 2,
//             // ),
//             //Share labelLarge view
//             // Expanded(
//             //   flex: 1,
//             //   child: ElevatedButton(
//             //     style: ElevatedButton.styleFrom(
//             //       side: const BorderSide(
//             //         width: 0.5,
//             //         color: Colors.grey,
//             //       ),
//             //       shape: RoundedRectangleBorder(),
//             //
//             //       backgroundColor: Colors.white, // background
//             //       foregroundColor: Colors.black, // foreground
//             //     ),
//             //     // style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0)),
//             //     onPressed: () async {
//             //       /*
//             //       * Share labelLarge Functionality
//             //       * */
//             //       //var productUrl = "${ApiConstant.baseUrl}${widget.product?.href ?? ""}?productId=${widget.product?.productId ?? 0}&productName=${widget.product?.name ?? ""}";
//             //       await FlutterShare.share(
//             //           title: widget.product?.name ?? '',
//             //           text: '',
//             //           linkUrl: widget.product?.href ?? "",
//             //           chooserTitle: '');
//             //     },
//             //     child: Row(
//             //       mainAxisSize: MainAxisSize.max,
//             //       mainAxisAlignment: MainAxisAlignment.center,
//             //       children: [
//             //         Icon(
//             //           Icons.share,
//             //           // color: Colors.white ,
//             //           color: AppColors.lightGray,
//             //         ),
//             //         const SizedBox(
//             //           width: AppSizes.size8 / 2,
//             //         ),
//             //         Text(
//             //             _localizations?.translate(AppStringConstant.share) ??
//             //                 "",
//             //             style: Theme.of(context)
//             //                 .textTheme
//             //                 .titleLarge
//             //                 ?.copyWith(color: Colors.grey))
//             //       ],
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ));
// }
}

String toTitleCase(String text) {
  if (text == null || text.isEmpty) return '';
  return text
      .split(' ')
      .map((word) => word.isEmpty
          ? ''
          : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}
