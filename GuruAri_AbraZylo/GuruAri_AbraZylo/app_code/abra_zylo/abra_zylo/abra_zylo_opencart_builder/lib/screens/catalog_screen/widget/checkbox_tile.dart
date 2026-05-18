import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/models/catalog/filter.dart';

class CheckboxTile extends StatelessWidget {
  const CheckboxTile(this.filter, this.callback, {Key? key}) : super(key: key);

  final Filter? filter;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          filter?.selected = filter?.selected == true ? false : true;
          callback();
        },
        child: Row(
          children: <Widget>[
            Checkbox(
              side: BorderSide(color: AppColors.black),
              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.black; // Change color based on dark mode
                }
                return Colors.transparent;
              }),
              value: filter?.selected ?? false,
              onChanged: (value) {
                filter?.selected = value;
                callback();
              },
            ),
            const SizedBox(width: AppSizes.size8),
            Text(
              "${filter?.name}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
