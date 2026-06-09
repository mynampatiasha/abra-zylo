import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;

import '../../config/theme.dart';
import '../../constants/app_string_constant.dart';
import '../../constants/arguments_map.dart';
import '../../helper/app_localizations.dart';
import '../../main.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  Map<String, dynamic>? args;

  DeliveryTrackingScreen(this.args, {Key? key}) : super(key: key);

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  AppLocalizations? localization;
  MapController _controller = MapController();
  LatLng? sourceLocation;
  LatLng? destination;

  List<LatLng> polylineCoordinates = [];
  LatLng? deliveryBoyLocation;
  Map<String, Polyline> polylines = {};

  @override
  void initState() {
    sourceLocation = widget?.args?["sourceLocation"];
    destination = widget?.args?["destinationLocation"];
    //setDestination();
    fetchCoordinates();
    startTracking();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    localization = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // late GoogleMapController mapController;
  //
  // LatLng? _currentPosition;
/*  getLocation() async {
    */ /*LocationPermission permission;
    permission = await Geolocator.requestPermission();*/ /*

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      _isLoading = false;
    });
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization?.translate(AppStringConstant.trackOrder) ?? '',
        ),
      ),
      body: FlutterMap(
        mapController: _controller,
        options: MapOptions(
          initialCenter: destination ?? const LatLng(0, 0),
          initialZoom: 13.5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.abra.zylo.android',
          ),
          PolylineLayer(
            polylines: polylines.values.toList(),
          ),
          MarkerLayer(
            markers: [
              if (sourceLocation != null)
                Marker(
                  point: sourceLocation!,
                  child: Image.asset("assets/images/source_pin.png"),
                ),
              if (destination != null)
                Marker(
                  point: destination!,
                  child: Image.asset("assets/images/destination_pin.png"),
                ),
              if (deliveryBoyLocation != null)
                Marker(
                  point: deliveryBoyLocation!,
                  child: Image.asset("assets/images/delivery_pin.png"),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _updatePolyline(/* parameters for new points */) {
    final String polylineId = 'updatedroute';
    final Polyline polyline = Polyline(
      points: [
        LatLng(deliveryBoyLocation!.latitude, deliveryBoyLocation!.longitude),
        LatLng(destination?.latitude ?? 0, destination?.longitude ?? 0),
      ],
      color: Colors.red,
      strokeWidth: 4.0,
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  _addPolyLine() {
    String initialRouteId = "initialroute";
    Polyline polyline = Polyline(
      color: Colors.grey,
      points: polylineCoordinates,
      strokeWidth: 4.0,
    );
    String updatedRouteId = "updatedroute";
    Polyline updatedPolyline = Polyline(
      color: Colors.red,
      points: polylineCoordinates,
      strokeWidth: 4.0,
    );
    polylines[initialRouteId] = polyline;
    polylines[updatedRouteId] = updatedPolyline;
    setState(() {});
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyB749j5lDJ5hPNHzZd59TfHqi2SRKfgghs",
      PointLatLng(
          sourceLocation?.latitude ?? 0, sourceLocation?.longitude ?? 0),
      PointLatLng(destination?.latitude ?? 0, destination?.longitude ?? 0),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      _addPolyLine();
      setState(() {});
    }
  }

  void setCustomMarkerIcon() {
    // In flutter_map, we use widgets directly for markers instead of BitmapDescriptor.
  }

/*  setDestination() async {
    List<Location> locations =  locationFromAddress(widget.args?["shippingAddress"]??'') as List<Location>;
    print("LOCATIONS-->${locations}");
    if(locations.isNotEmpty){
      Location location = locations.first;
      destination = LatLng(location.latitude,location.longitude);
    }
    String warehouseAddress =  widget.args?[wareHouseAddress]??'';
    String wareHouseLatitude = widget.args?[wareHouseAddressLat]??'';
    String wareHouseLongitude = widget.args?[wareHouseAddressLong]??'';

    if(wareHouseLatitude.isNotEmpty && wareHouseLongitude.isNotEmpty){
      sourceLocation = LatLng(double.parse(wareHouseLatitude),double.parse(wareHouseLongitude));
    }else{
      List<Location> locations = await locationFromAddress(warehouseAddress);
      print("LOCATIONS-->${locations}");
      if(locations.isNotEmpty){
        Location location = locations.first;
        sourceLocation = LatLng(location.latitude,location.longitude);
      }
    }

  }*/

  fetchCoordinates() async {
    if (destination == null || sourceLocation == null) {
      List<Location> locations =
          await locationFromAddress(widget.args?["shippingAddress"] ?? '');
      print("LOCATIONS-->${locations}");
      if (locations.isNotEmpty) {
        Location location = locations.first;
        destination = LatLng(location.latitude, location.longitude);
      }

      String warehouseAddress = /*Ghaziabad"*/
          widget.args?[wareHouseAddress] ?? '';
      String wareHouseLatitude = /*"28.667856"*/
          widget.args?[wareHouseAddressLat] ?? '';
      String wareHouseLongitude = /*"77.449791"  */
          widget.args?[wareHouseAddressLong] ?? '';

      if (wareHouseLatitude.isNotEmpty && wareHouseLongitude.isNotEmpty) {
        sourceLocation = LatLng(
            double.parse(wareHouseLatitude), double.parse(wareHouseLongitude));
      } else {
        List<Location> locations = await locationFromAddress(warehouseAddress);
        print("LOCATIONS-->${locations}");
        if (locations.isNotEmpty) {
          Location location = locations.first;
          sourceLocation = LatLng(location.latitude, location.longitude);
        }
      }
    }
    if (mounted) {
      setState(() {
        getPolyPoints();
      });
    }
  }

  void startTracking() async {
    secondaryDatabase
        ?.ref()
        .child('DeliveryApp/locationData/${widget.args?[deliveryBoyIdKey]}')
        .onValue
        .listen((event) {
      print("EVENTDATA-->${event.snapshot.value}");
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        LatLng latLng = LatLng(data['latitude'], data['longitude']);
        print("LATLNG-->${latLng}");
        deliveryBoyLocation = latLng;
      }
    });
    if (mounted) {
      setState(() {
        _updatePolyline;
      });
    }
    var delay = Future.delayed(Duration(seconds: 2), () {
      startTracking();
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
