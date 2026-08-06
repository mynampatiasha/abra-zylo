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
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFece7f3))), // var(--line)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title,
              style: const TextStyle(
                fontFamily: 'Karla',
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color(0xFF2b2540), // var(--ink)
              )),
          Switch(
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF5232a8), // violet-700
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFece7f3), // line
            value: widget.isOn,
            onChanged: (value) {
              setState(() {
                widget.isOn = value;
                widget.callback(widget.isOn);
              });
            },
          ),
        ],
      ),
    );
  }
}
