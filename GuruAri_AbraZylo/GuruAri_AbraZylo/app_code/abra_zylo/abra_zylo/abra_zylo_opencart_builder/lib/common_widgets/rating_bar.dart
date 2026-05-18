import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';

typedef void RatingChangeCallback(double rating);

class RatingBarCustom extends StatefulWidget {
  final int starCount;
  double? rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;

  RatingBarCustom(
      {this.starCount = 5,
      this.rating = .0,
      this.onRatingChanged,
      this.color,
      Key? key})
      : super(key: key);

  @override
  State<RatingBarCustom> createState() => _RatingBarCustomState();
}

class _RatingBarCustomState extends State<RatingBarCustom> {
  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= widget.rating!) {
      icon = Icon(
        Icons.star_border,
        size: 22,
        color: AppColors.black,
      );
    } else if (index > widget.rating! - 1 && index < widget.rating!) {
      icon = Icon(
        Icons.star_half,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: 22,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: 25,
      );
    }
    return InkResponse(
      onTap: widget.onRatingChanged == null
          ? null
          : () => setState(() {
                widget.rating = index + 1.0;
                widget.onRatingChanged!(index + 1.0);
              }),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(
            widget.starCount, (index) => buildStar(context, index)));
  }
}
