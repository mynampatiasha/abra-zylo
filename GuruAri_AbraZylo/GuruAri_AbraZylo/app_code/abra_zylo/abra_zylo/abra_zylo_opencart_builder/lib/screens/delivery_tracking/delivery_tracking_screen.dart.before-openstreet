import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? sourceLocation;
  LatLng? destination;

  /*  LatLng? sourceLocation = LatLng(37.33500926, -122.03272188);
   LatLng? destination = LatLng(37.33429383, -122.06600055);*/
/*  static LatLng sourceLocation = LatLng(28.629637761068185, 77.37793902873749);
  static LatLng destination = LatLng(28.629637761068185, 77.37793902873749);*/
  List<LatLng> polylineCoordinates = [];
  LatLng? deliveryBoyLocation;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor deliveryBoyIcon = BitmapDescriptor.defaultMarker;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    sourceLocation = widget?.args?["sourceLocation"];
    destination = widget?.args?["destinationLocation"];
    //setDestination();
    fetchCoordinates();
    startTracking();
    setCustomMarkerIcon();

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
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: destination!,
          zoom: 13.5,
        ),
        markers: {
          Marker(
            markerId: MarkerId("source"),
            position: sourceLocation!,
            icon: sourceIcon,
          ),
          Marker(
            icon: destinationIcon,
            markerId: const MarkerId("destination"),
            position: destination!,
          ),
          if (deliveryBoyLocation != null)
            Marker(
              icon: deliveryBoyIcon,
              markerId: const MarkerId("deliveryboy"),
              position: deliveryBoyLocation!,
            ),
        },
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
        polylines: Set<Polyline>.of(polylines
            .values), /*{
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: MobikulTheme.accentColor,
            width: 8,
          ),
        }*/
      ),
    );
  }

  void _updatePolyline(/* parameters for new points */) {
    final PolylineId polylineId = PolylineId('updatedroute');
    final Polyline polyline = polylines[polylineId]!.copyWith(
      pointsParam: [
        LatLng(deliveryBoyLocation!.latitude, deliveryBoyLocation!.longitude),
        LatLng(destination?.latitude ?? 0, destination?.longitude ?? 0),
        // New list of LatLng points
      ],
      //colorParam: Colors.black
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  _addPolyLine() {
    PolylineId initialRouteId = PolylineId("initialroute");
    Polyline polyline = Polyline(
      polylineId: initialRouteId,
      color: Colors.grey,
      points: polylineCoordinates,
      jointType: JointType.mitered,
      patterns: [PatternItem.dot, PatternItem.gap(10)],
    );
    PolylineId updatedRouteId = PolylineId("updatedroute");
    Polyline updatedPolyline = Polyline(
      polylineId: updatedRouteId,
      color: Colors.red,
      points: polylineCoordinates,
      jointType: JointType.mitered,
      patterns: [PatternItem.dot, PatternItem.gap(10)],
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
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/source_pin.png")
        .then(
      (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/destination_pin.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/delivery_pin.png")
        .then(
      (icon) {
        deliveryBoyIcon = icon;
      },
    );
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
