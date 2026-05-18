import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oc_demo/constants/app_constants.dart';

class TitleSeparatedCard extends StatelessWidget {
  const TitleSeparatedCard(this.title, this.child,
      {this.showDivider = true, this.asCard = true, Key? key})
      : super(key: key);

  final String title;
  final Widget child;
  final bool showDivider;
  final bool asCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      borderOnForeground: asCard ? true : false,
      elevation: asCard ? 1.0 : 0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.size8, vertical: AppSizes.size10),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          if (showDivider) const Divider(height: 0),
          child
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
