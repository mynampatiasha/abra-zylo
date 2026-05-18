import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/catalog/sort.dart';

class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet(this.sort, this.onSort, {this.selected, Key? key})
      : super(key: key);
  final Sort? selected;
  final List<Sort>? sort;
  final ValueChanged<Sort?> onSort;

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  late String? groupValue;

  @override
  void initState() {
    if (widget.selected != null) {
      groupValue = "${widget.selected?.value}-${widget.selected?.order}";
    } else {
      groupValue = "${widget.sort?.first.value}-${widget.sort?.first.order}";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(groupValue);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            AppStringConstant.sortBy.localized().toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(color: Colors.black),
          ),
          automaticallyImplyLeading: false,
          // Uncomment this if you require a close labelLarge
          // leeading: const CloseButton()
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              var sort = widget.sort?.elementAt(index);
              return RadioListTile<String?>(
                activeColor: Colors.black,
                dense: true,
                contentPadding: const EdgeInsets.only(left: 6),
                visualDensity: const VisualDensity(),
                value: "${sort?.value}-${sort?.order}",
                groupValue: groupValue,
                onChanged: (value) {
                  setState(() {
                    groupValue = value;
                  });
                  var arr = value?.split("-");
                  Sort? sort;
                  widget.sort?.forEach((element) {
                    if (element.order == arr?.elementAt(1) &&
                        element.value == arr?.elementAt(0)) {
                      sort = element;
                    }
                  });
                  widget.onSort(sort);
                },
                title: Transform.translate(
                  offset: const Offset(-26, 0),
                  child: Html(
                    data: "${widget.sort![index].text}",
                    /*style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),*/
                  ),
                ),
              );
            },
            itemCount: widget.sort?.length ?? 0,
          ),
        ),
      ],
    );
  }
}
