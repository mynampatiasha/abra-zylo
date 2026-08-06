import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/searchModel/search_model.dart';
import 'package:oc_demo/common_widgets/image_view.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

Widget suggestionList(BuildContext context, AppLocalizations? _localizations,
    List<SearchData>? searchData) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: AppSizes.size26, bottom: AppSizes.size8),
            child: Text(
              _localizations?.translate(AppStringConstant.suggestions) ?? "",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchData?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75, // Ratio for image and text
              ),
              itemBuilder: (context, index) {
                var data = searchData?[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoute.productPage,
                        arguments: getProductDataAttributeMap(
                            data?.name ?? "", data?.productId ?? ""));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFfffdf9), // var(--paper)
                      border: Border.all(color: const Color(0xFFece7f3)), // var(--line)
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(47, 16, 101, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Builder(
                              builder: (context) {
                                String? imgUrl = (data?.thumb != null && data!.thumb!.isNotEmpty) ? data?.thumb : data?.image;
                                print('🔍 SEARCH IMAGE DEBUG → image: ${data?.image} | thumb: ${data?.thumb} | final: $imgUrl');
                                if (imgUrl != null && imgUrl.isNotEmpty && !imgUrl.startsWith('http')) {
                                  imgUrl = ApiConstant.baseUrl + imgUrl;
                                }
                                print('🔍 SEARCH IMAGE FINAL URL → $imgUrl');
                                return ImageView(
                                  url: imgUrl,
                                  fit: BoxFit.cover,
                                );
                              }
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data?.name ?? "",
                            style: const TextStyle(
                              fontFamily: 'Karla',
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2b2540), // var(--ink)
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ));
}
