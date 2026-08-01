import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/orderListModel/order_list_model.dart';

Widget orderMainView(
    BuildContext context,
    List<OrderListData>? orders,
    AppLocalizations? localizations,
    Function(String orderId) callback,
    ScrollController controller,
    {ScrollPhysics scrollPhysics = const AlwaysScrollableScrollPhysics()}) {
  return ListView.separated(
    controller: controller,
    shrinkWrap: true,
    physics: scrollPhysics,
    itemBuilder: (ctx, index) =>
        orderItem(context, orders?[index], localizations, callback),
    separatorBuilder: (ctx, index) => const SizedBox(
        // height: AppSizes.size4,
        // child: Divider(color: AppColors.darkGray,),
        ),
    itemCount: (orders?.length ?? 0),
  );
}

Widget orderItem(BuildContext context, OrderListData? item,
    AppLocalizations? localizations, Function(String) callback) {
  
  Color getStatusBgColor(String status) {
    if (status.toUpperCase() == 'COMPLETE' || status.toUpperCase() == 'DELIVERED') {
      return const Color(0xFFe8fbf3);
    } else if (status.toUpperCase() == 'SHIPPED') {
      return const Color(0xFFe6f0ff);
    } else if (status.toUpperCase() == 'PROCESSING' || status.toUpperCase() == 'PENDING') {
      return const Color(0xFFfff3e0);
    }
    return const Color(0xFFf0f0f0);
  }

  Color getStatusTextColor(String status) {
    if (status.toUpperCase() == 'COMPLETE' || status.toUpperCase() == 'DELIVERED') {
      return const Color(0xFF109655);
    } else if (status.toUpperCase() == 'SHIPPED') {
      return const Color(0xFF0057ff);
    } else if (status.toUpperCase() == 'PROCESSING' || status.toUpperCase() == 'PENDING') {
      return const Color(0xFFe67a00);
    }
    return const Color(0xFF555555);
  }

  return Container(
    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0x145232a8)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x145232a8),
          blurRadius: 24,
          spreadRadius: -10,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: getStatusBgColor(item?.status ?? ''),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                (item?.status ?? 'Processing').toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Karla',
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  letterSpacing: 0.5,
                  color: getStatusTextColor(item?.status ?? ''),
                ),
              ),
            ),
            Text(
              item?.dateAdded ?? '',
              style: const TextStyle(
                fontFamily: 'Karla',
                fontSize: 13,
                color: Color(0xFF8f889c),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            if ((item?.image ?? '').isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: ApiConstant.imageUrl(item!.image),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    color: const Color(0xFFf4f0fb),
                    child: const Icon(Icons.image_not_supported, color: Color(0xFFc8abec)),
                  ),
                  placeholder: (context, url) => Container(
                    width: 60,
                    height: 60,
                    color: const Color(0xFFf4f0fb),
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                ),
              )
            else
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFf4f0fb),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shopping_bag, color: Color(0xFFc8abec)),
              ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order #${item?.orderId ?? ''}",
                    style: const TextStyle(
                      fontFamily: 'Baloo 2',
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: Color(0xFF2b2540),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item?.total ?? "0.00",
                    style: const TextStyle(
                      fontFamily: 'Karla',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF5232a8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  callback(item?.orderId ?? '');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf4f0fb),
                  foregroundColor: const Color(0xFF5232a8),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Reviews",
                  style: TextStyle(fontFamily: 'Karla', fontWeight: FontWeight.w700, fontSize: 13.5),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoute.orderDetail,
                    arguments: item?.orderId ?? "",
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5232a8),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Details",
                  style: TextStyle(fontFamily: 'Karla', fontWeight: FontWeight.w700, fontSize: 13.5),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget statusContainer(BuildContext context, String status) {
  return Container(
    color: containerColor(status),
    padding: const EdgeInsets.symmetric(
        vertical: AppSizes.size6, horizontal: AppSizes.size12),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
            child: Text(
          status,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.white),
        )),
      ],
    ),
  );
}

Color containerColor(String status) {
  switch (status.toUpperCase()) {
    case 'COMPLETE':
      return AppColors.green;
    default:
      return AppColors.yellow;
  }
}

//==Todo change with address card
Widget actionContainer(
    BuildContext context, VoidCallback leftCallback, VoidCallback rightCallback,
    {IconData? iconLeft,
    IconData? iconRight,
    String? titleLeft,
    String? titleRight}) {
  return Padding(
    padding: const EdgeInsets.all(AppSizes.size14),
    child: Row(
      children: [
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: leftCallback,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconLeft ?? Icons.edit,
                    size: AppSizes.size24,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(
                    width: AppSizes.size8,
                  ),
                  Text((titleLeft ?? '').toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold))
                ],
              ),
            )),
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: rightCallback,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconRight ?? Icons.add,
                    size: AppSizes.size24,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(
                    width: AppSizes.size8,
                  ),
                  Text(
                      // _localizations?.translate(AppStringConstant.newAddress) ??
                      (titleRight ?? "").toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold))
                ],
              ),
            )),
      ],
    ),
  );
}
