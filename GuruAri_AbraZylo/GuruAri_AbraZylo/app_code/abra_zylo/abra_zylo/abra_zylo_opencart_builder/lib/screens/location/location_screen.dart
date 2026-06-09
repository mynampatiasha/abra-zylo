import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/open_bottom_model_sheet_helper.dart';
import 'package:oc_demo/helper/nominatim_helper.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double? latitude;
  double? longitude;
  LatLng? position;

  MapController _controller = MapController();
  String address = '';
  Map<String, dynamic> addressMap = {};
  bool _mapReady = false; // FIX 1: delays GoogleMap render to avoid null crash in _gmapTypeIDForPluginType

  @override
  void initState() {
    super.initState();
    // FIX 1: Defer map rendering by one frame.
    // On Flutter Web, GoogleMap widget crashes with a null check error
    // inside _gmapTypeIDForPluginType if rendered on the very first build.
    // Waiting one frame lets the platform view registry initialise first.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _mapReady = true);
    });
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              // FIX 1 (continued): Only render GoogleMap after _mapReady is true.
              // latitude/longitude are checked separately — show Loader while
              // location is still being fetched, but never before _mapReady.
              child: !_mapReady
                  ? const Loader()
                  : (latitude == null || longitude == null)
                      ? const Loader()
                      : Stack(
                          children: <Widget>[
                            FlutterMap(
                              mapController: _controller,
                              options: MapOptions(
                                initialCenter: LatLng(latitude!, longitude!),
                                initialZoom: 16.0,
                                onPositionChanged: (position_info, hasGesture) {
                                  if (position_info.center != null) {
                                    position = position_info.center;
                                  }
                                },
                                onMapEvent: (event) {
                                  if (event is MapEventMoveEnd) {
                                    if (position != null) {
                                      setState(() {
                                        address = '';
                                        addressMap = {};
                                      });
                                      getLocation(position!);
                                    }
                                  }
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.abra.zylo.android',
                                ),
                              ],
                            ),
                            const Positioned(
                              right: 0,
                              top: 0,
                              left: 0,
                              bottom: 0,
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: AppSizes.size40,
                              ),
                            ),
                            Positioned(
                              bottom: AppSizes.size15,
                              right: AppSizes.size15,
                              child: InkWell(
                                onTap: getCurrentLocation,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  child: const Center(
                                    child: Icon(Icons.my_location_sharp),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                placeSearchBottomModelSheet(context, (value) {
                                  print('callback value $value');
                                  placeSearch(value);
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.all(AppSizes.size12),
                                margin: const EdgeInsets.all(AppSizes.size12),
                                color: Theme.of(context).cardColor,
                                child: Row(
                                  children: <Widget>[
                                    const Icon(Icons.search),
                                    const SizedBox(width: AppSizes.size16),
                                    Text(
                                      AppStringConstant.searchLocation
                                          .localized(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, addressMap);
              },
              child: Container(
                padding: const EdgeInsets.all(AppSizes.size8),
                height: AppSizes.deviceHeight / 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_pin),
                        const SizedBox(width: AppSizes.size8),
                        Text(AppStringConstant.selectLocation.localized()),
                        const Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.all(AppSizes.size6),
                              child: Icon(
                                Icons.done_sharp,
                                color: Colors.red,
                                size: AppSizes.size40,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: AppSizes.size8),
                    address.isNotEmpty
                        ? Flexible(
                            child: Text(
                              address,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.lightGray),
                              softWrap: true,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Text(AppStringConstant.loadingMessage.localized()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getCurrentLocation() async {
    Position? locationData;
    try {
      locationData = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AlertMessage.showError(
            e is PlatformException ? e.message.toString() : e.toString(),
            context,
          );
        }
      });
      if (mounted) Navigator.pop(context);
      print('exception----------- $e');
      return;
    }
    if (locationData == null) return;
    if (!mounted) return;
    setState(() {
      latitude = locationData!.latitude;
      longitude = locationData!.longitude;
    });
    position = LatLng(latitude!, longitude!);
    if (mounted && _mapReady) {
      try {
        _controller.move(LatLng(latitude!, longitude!), 16.0);
      } catch (_) {}
    }
    // Fetch address for initial location
    getLocation(position!);
  }

  void placeSearch(LatLng loc) {
    setState(() {
      latitude = loc.latitude;
      longitude = loc.longitude;
      address = '';
      addressMap = {};
    });
    position = LatLng(latitude!, longitude!);
    if (mounted && _mapReady) {
      try {
        _controller.move(LatLng(latitude!, longitude!), 16.0);
      } catch (_) {}
    }
    getLocation(loc);
  }

  void getLocation(LatLng latLng) async {
    try {
      final result = await NominatimHelper.reverseGeocode(latLng.latitude, latLng.longitude);
      if (result != null) {
        final Map<String, dynamic> addressData = result['address'] ?? {};
        final Map<String, dynamic> map = {};
        
        String street = addressData['road'] ?? '';
        String area = addressData['suburb'] ?? addressData['neighbourhood'] ?? '';
        String locality = addressData['city'] ?? addressData['town'] ?? addressData['village'] ?? '';
        String state = addressData['state'] ?? '';
        String zip = addressData['postcode'] ?? '';
        String country = addressData['country'] ?? '';

        if (street.isNotEmpty) map['street1'] = street;
        if (area.isNotEmpty) map['street2'] = area;
        if (locality.isNotEmpty) map['city'] = locality;
        if (state.isNotEmpty) map['state'] = state;
        if (zip.isNotEmpty) map['zip'] = zip;
        if (country.isNotEmpty) map['country'] = country;

        setState(() {
          address = result['address_string'] ?? '';
          addressMap = map;
        });
      }
    } catch (e) {
      print('Nominatim Geocoding Error: $e');
    }
  }


}