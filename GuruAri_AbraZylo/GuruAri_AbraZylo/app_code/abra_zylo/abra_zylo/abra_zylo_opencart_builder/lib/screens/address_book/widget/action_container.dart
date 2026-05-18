import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';

class ActionContainer extends StatelessWidget {
  const ActionContainer({
    this.iconLeft,
    this.iconRight,
    this.leftCallback,
    this.rightCallback,
    required this.titleLeft,
    required this.titleRight,
    Key? key,
  }) : super(key: key);

  final IconData? iconLeft, iconRight;
  final String titleLeft, titleRight;
  final VoidCallback? leftCallback, rightCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: leftCallback,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.size12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    iconLeft ?? Icons.edit,
                    size: AppSizes.size20,
                  ),
                  const SizedBox(
                    width: AppSizes.size4,
                  ),
                  Text(
                    titleLeft.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: rightCallback,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.size12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    iconRight ?? Icons.add,
                    size: AppSizes.size20,
                  ),
                  const SizedBox(
                    width: AppSizes.size4,
                  ),
                  Text(
                    titleRight.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
