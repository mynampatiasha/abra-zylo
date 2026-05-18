import 'package:flutter/material.dart';

import '../badge_icon.dart';
import 'bottom_tabbar.dart';

class BadgeIconUpdate extends StatefulWidget {
  const BadgeIconUpdate({Key? key}) : super(key: key);

  @override
  State<BadgeIconUpdate> createState() => _BadgeIconUpdateState();
}

class _BadgeIconUpdateState extends State<BadgeIconUpdate> {
  late int _badgeCount;

  @override
  void initState() {
    _badgeCount = 0;
    _registerStreamListener();
    super.initState();
  }

  void _registerStreamListener() {
    if (mounted) {
      TabbarController.countController.stream.listen((event) {
        if (this.mounted) {
          setState(() {});
        }
        _badgeCount = event;
        print("badge count $event");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BadgeIcon(
      icon: const Icon(Icons.shopping_cart_outlined),
      badgeCount: _badgeCount,
    );
  }
}
