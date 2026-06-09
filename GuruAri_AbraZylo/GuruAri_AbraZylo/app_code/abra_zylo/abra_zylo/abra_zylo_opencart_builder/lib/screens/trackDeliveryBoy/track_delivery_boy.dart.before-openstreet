import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/common_tool_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/locationModel/location_model.dart';
import 'package:oc_demo/screens/trackDeliveryBoy/bloc/track_delivery_boy_screen_event.dart';
import 'package:oc_demo/screens/trackDeliveryBoy/bloc/track_delivery_boy_screen_state.dart';
import 'package:oc_demo/screens/trackDeliveryBoy/bloc/track_dellivery_boy_bloc.dart';

class TrackDeliveryBoy extends StatefulWidget {
  const TrackDeliveryBoy(this.arguments, {Key? key}) : super(key: key);
  final Map<String, dynamic> arguments;

  @override
  State<TrackDeliveryBoy> createState() => _TrackDeliveryBoyState();
}

//                    intent.putExtra("id", response.body()!!.boyId)
//                         intent.putExtra("address", response.body()!!.customerShipping)
class _TrackDeliveryBoyState extends State<TrackDeliveryBoy> {
  String? id, address;
  TrackDeliveryBoyBloc? _bloc;
  AppLocalizations? _localizations;
  bool isLoading = false;
  static const LatLng _center = const LatLng(28.6261248, 77.3685248);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  LatLng _lastMapPosition = _center;
  LocationModel? _locationModel;
  List<LatLng>? latlng = [];
  List<Track>? latlongs = [];

  LatLng startLocation = LatLng(27.6683619, 85.3101895);
  late GoogleMapController controller;
  Location _location = Location();

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
      //uncomment for current location.......
      // _location.onLocationChanged.listen((l) {
      //   controller.animateCamera(
      //     CameraUpdate.newCameraPosition(
      //       CameraPosition(target: LatLng(l.latitude??0, l.longitude??0),zoom: 15),
      //     ),
      //   );
      // });
      // _markers.add(Marker(
      //   markerId: MarkerId(_lastMapPosition.toString()),
      //   position: _lastMapPosition,
      //   infoWindow: InfoWindow(
      //     title: 'Webkul',
      //     snippet: '5 Star Rating',
      //   ),
      //   icon: BitmapDescriptor.defaultMarker,
      //
      // ));
      _markers.add(Marker(
        markerId: MarkerId(latlng?.first.toString() ?? ""),
        position: latlng?.first ?? _center,
        // infoWindow: InfoWindow(
        //   title: 'Really cool place',
        //   snippet: '5 Star Rating',
        // ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      _markers.add(Marker(
        markerId: MarkerId(latlng?.last.toString() ?? ""),
        position: latlng?.last ?? _center,
        // infoWindow: InfoWindow(
        //   title: 'Really cool place',
        //   snippet: '5 Star Rating',
        // ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      _polyline.add(Polyline(
        polylineId: PolylineId(_lastMapPosition.toString()),
        visible: true,
        patterns: [PatternItem.dash(10), PatternItem.gap(10)],
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        width: 5,
        points: latlng ?? [],
        color: Colors.blue,
      ));
    });
  }

  @override
  void initState() {
    id = widget.arguments[boyId];
    address = widget.arguments[address];
    _bloc = context.read<TrackDeliveryBoyBloc>();
    _bloc?.add(TrackDeliveryBoyScreenDatFetchEvent(id ?? ""));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonToolBar(
          _localizations?.translate(AppStringConstant.track) ?? "", context,
          isElevated: false),
      body: BlocBuilder<TrackDeliveryBoyBloc, TrackDeliveryBoyBaseState>(
        builder: (context, state) {
          if (state is TrackDeliveryBoyInitialState) {
            isLoading = true;
          } else if (state is TrackDeliveryBoySuccessState) {
            isLoading = false;
            _locationModel = state.locationModel;
            latlongs = _locationModel?.tracks ?? [];
            latlongs?.forEach((element) {
              latlng?.add(LatLng(double.parse(element.lat ?? ""),
                  double.parse(element.lon ?? "")));
            });
          } else if (state is TrackDeliveryBoyErrorState) {
            isLoading = false;
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              AlertMessage.showError(state.message ?? '', context);
            });
          }
          return isLoading ? Loader() : buildUI();
        },
      ),
    );
  }

  Widget buildUI() {
    return Container(
        child: GoogleMap(
      polylines: _polyline,
      markers: _markers,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,

      //onCameraMove: _onCameraMove,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
      mapType: MapType.normal,
    ));
  }
}
