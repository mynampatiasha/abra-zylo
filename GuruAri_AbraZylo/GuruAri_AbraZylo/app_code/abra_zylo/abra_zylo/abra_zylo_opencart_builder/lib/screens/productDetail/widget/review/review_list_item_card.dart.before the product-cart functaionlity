import 'package:flutter/material.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';
import 'package:oc_demo/screens/productDetail/widget/review/rating_container.dart';

import '../../../../constants/app_constants.dart';

Widget reviewListItemCard(
  Reviews? reviewData,
  BuildContext context,
) {
  return Padding(
    padding: const EdgeInsets.only(
        top: AppSizes.size12, left: AppSizes.size12, right: AppSizes.size8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RatingContainer(reviewData!.rating?.toDouble() ?? 0),
            const SizedBox(
              width: AppSizes.size8 / 2,
            ),
          ],
        ),
        const SizedBox(
          height: AppSizes.size8,
        ),
        Flexible(child: Text("${reviewData.text}")),
        const SizedBox(
          height: AppSizes.size8,
        ),
        Text(
          '${reviewData.author}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.displaySmall?.color),
        ),
        const SizedBox(
          height: AppSizes.size8,
        ),
        Text(
          '(${reviewData.dateAdded})',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  );
}
