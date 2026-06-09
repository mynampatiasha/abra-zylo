import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/rating_bar.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helper/app_localizations.dart';

class RatingContainer extends StatefulWidget {
  double rating;
  bool isClickable;
  RatingContainer(this.rating, {Key? key, this.isClickable = true})
      : super(key: key);

  @override
  State<RatingContainer> createState() => _RatingContainerState();
}

class _RatingContainerState extends State<RatingContainer> {
  AppLocalizations? _localizations;
  double rating = 0.0;

  @override
  void initState() {
    rating = widget.rating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RatingBarCustom(
      starCount: 5,
      color: AppColors.yellow,
      rating: rating,
      onRatingChanged: widget.isClickable
          ? (_rating) {
              rating = _rating;
            }
          : null,
    );
    //   Container(
    //   color: containerColor(widget.rating.toInt()),
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(
    //         horizontal: AppSizes.size8, vertical: AppSizes.size8 / 2),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //
    //
    //         Text(
    //           "${widget.rating}",
    //           style: const TextStyle(color: AppColors.white, fontSize: 14),
    //         ),
    //         const SizedBox(
    //           width: 2.0,
    //         ),
    //         const Icon(
    //           Icons.star,
    //           color: AppColors.white,
    //           size: 16,
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  Color containerColor(int review) {
    switch (review) {
      case 1:
        return AppColors.red;
      case 2:
        return AppColors.lightRed;
      case 3:
        return AppColors.yellow;
      case 4:
        return AppColors.orange;
      case 5:
        return AppColors.green;
      default:
        return AppColors.black;
    }
  }
}
