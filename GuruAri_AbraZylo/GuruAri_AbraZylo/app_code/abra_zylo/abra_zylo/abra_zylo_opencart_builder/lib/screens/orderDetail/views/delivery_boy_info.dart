import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:oc_demo/common_widgets/image_view.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/screens/orderDetail/views/order_heading_view.dart';

Widget deliveryBoyInfo(BuildContext context, AppLocalizations? _localizations,
    OrderDetailModel? _orderModel) {
  return orderHeaderLayout(
      context,
      _localizations?.translate(AppStringConstant.deliveryBoyDetails) ?? "",
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppSizes.size10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 35,
                  child: ClipOval(
                      child: ImageView(
                    url: _orderModel?.boyImage ?? "",
                  )),
                ),
                SizedBox(
                  width: AppSizes.size20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_orderModel?.boyName ?? ""),
                    Text(_orderModel?.boyVehicle ?? ""),
                    Text(
                      _orderModel?.boyTelephone ?? "",
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: AppSizes.size10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_localizations
                            ?.translate(AppStringConstant.otpCode)
                            .toUpperCase() ??
                        ""),
                    SizedBox(
                      height: AppSizes.size2,
                    ),
                    Text(
                      _orderModel?.deliveryCode ?? "",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Visibility(
                    visible: _orderModel?.warehouseDetails != null &&
                        _orderModel?.warehouseDetails?.pickup_status == "1",
                    child: SizedBox(
                      height: AppSizes.size26,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // primary: Colors.black, // background
                          // onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero), // foreground
                        ),
                        onPressed: () async {
                          LatLng sourceLocation =
                              LatLng(37.33500926, -122.03272188);
                          LatLng destination =
                              LatLng(37.33429383, -122.06600055);
                          List<Location> locations = await locationFromAddress(
                              "ghaziabad uttar pradesh");
                          print("LOCATIONS-->${locations}");
                          if (locations.isNotEmpty) {
                            Location location = locations.first;
                            destination =
                                LatLng(location.latitude, location.longitude);
                          }
                          String warehouseAddress =
                              _orderModel?.warehouseDetails?.address ?? '';
                          String wareHouseLatitude =
                              _orderModel?.warehouseDetails?.lat ?? '';
                          String wareHouseLongitude =
                              _orderModel?.warehouseDetails?.lon ?? '';

                          if (wareHouseLatitude.isNotEmpty &&
                              wareHouseLongitude.isNotEmpty) {
                            sourceLocation = LatLng(
                                double.parse(wareHouseLatitude),
                                double.parse(wareHouseLongitude));
                          } /*else{
                          List<Location> locations = await locationFromAddress(warehouseAddress);
                          print("LOCATIONS-->${locations}");
                          if(locations.isNotEmpty){
                            Location location = locations.first;
                            sourceLocation = LatLng(location.latitude,location.longitude);
                          }
                        }*/

                          Navigator.of(context).pushNamed(
                              AppRoute.deliveryTrackingScreen,
                              arguments: getOrderTrackingDataMap(
                                  _orderModel?.boyId ?? '',
                                  "ghaziabad uttar pradesh" ?? '',
                                  sourceLocation,
                                  destination,
                                  _orderModel?.warehouseDetails));

                          /*      Navigator.of(context).pushNamed(
                        AppRoute.trackDeliveryBoy,
                        arguments: trackDboyMap(
                            _orderModel?.boyId ?? "",
                            _orderModel?.shippingAddress
                        ),
                      );*/
                        },
                        child: Text(_localizations
                                ?.translate(AppStringConstant.track)
                                .toUpperCase() ??
                            ""),
                      ),
                    ))
              ],
            )
          ],
        ),
      ));
}
