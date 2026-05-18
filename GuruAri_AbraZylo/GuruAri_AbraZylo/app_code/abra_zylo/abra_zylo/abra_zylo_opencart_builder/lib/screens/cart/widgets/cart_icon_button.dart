import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';

class CartIconButton extends StatelessWidget {
  const CartIconButton({
    this.leadingIcon,
    required this.title,
    required this.onClick,
    Key? key,
  }) : super(key: key);

  final IconData? leadingIcon;
  final String title;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.size8),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          // decoration: BoxDecoration(
          //    border: Border.all(color: Colors.blueAccent),
          //
          // ),
          height: AppSizes.size44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  leadingIcon,
                  color: Theme.of(context).iconTheme.color,
                  size: AppSizes.size22,
                ),
              ),
              Text(title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).textTheme.headlineMedium!.color,
                      fontSize: AppSizes.size12,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
