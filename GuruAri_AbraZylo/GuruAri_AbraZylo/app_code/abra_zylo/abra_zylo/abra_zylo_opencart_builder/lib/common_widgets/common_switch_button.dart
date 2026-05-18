import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import '../config/theme.dart';

class CommonSwitchButton extends StatefulWidget {
  bool isOn;
  final String title;
  final ValueChanged<bool> callback;
  CommonSwitchButton(this.title, this.callback, this.isOn, {Key? key})
      : super(key: key);

  @override
  State<CommonSwitchButton> createState() => _CommonSwitchButtonState();
}

class _CommonSwitchButtonState extends State<CommonSwitchButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Switch(
            activeColor: MobikulTheme.accentColor,
            value: widget.isOn,
            onChanged: (value) {
              setState(() {
                widget.isOn = value;
                widget.callback(widget.isOn);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.size8),
            child: Text(widget.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.normal)),
          ),
        ],
      ),
    );
  }
}
