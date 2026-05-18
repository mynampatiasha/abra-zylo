import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ImageView extends StatelessWidget {
  final String? url;
  double height;
  double width;
  BoxFit fit;

  ImageView(
      {this.url, this.width = 0.0, this.height = 0.0, this.fit = BoxFit.fill});

  @override
  Widget build(BuildContext context) {
    final imageUrl = ApiConstant.imageUrl(url);
    return Container(
      width: width != 0.0 ? width : null,
      height: height != 0.0 ? height : null,
      child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          errorWidget: (context, url, error) {
            return Image.asset('assets/images/placeholder.png',
                fit: BoxFit.contain);
          }),
    );
  }
}
