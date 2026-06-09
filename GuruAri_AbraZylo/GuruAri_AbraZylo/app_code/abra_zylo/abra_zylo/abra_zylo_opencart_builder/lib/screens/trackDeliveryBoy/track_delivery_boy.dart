import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
  final List<Marker> _markers = [];
  final List<Polyline> _polyline = [];
  LatLng _lastMapPosition = _center;
  LocationModel? _locationModel;
  List<LatLng>? latlng = [];
  List<Track>? latlongs = [];

  LatLng startLocation = LatLng(27.6683619, 85.3101895);
  MapController controller = MapController();
  Location _location = Location();

  void _onMapCreated() {
    setState(() {
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
        point: latlng?.first ?? _center,
        child: const Icon(Icons.location_on, color: Colors.red, size: 40.0),
      ));
      _markers.add(Marker(
        point: latlng?.last ?? _center,
        child: const Icon(Icons.location_on, color: Colors.green, size: 40.0),
      ));
      _polyline.add(Polyline(
        points: latlng ?? [],
        color: Colors.blue,
        strokeWidth: 5,
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
        child: FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: _center,
        initialZoom: 11.0,
        onMapReady: _onMapCreated,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.abra.zylo.android',
        ),
        PolylineLayer(
          polylines: _polyline,
        ),
        MarkerLayer(
          markers: _markers,
        ),
      ],
    ));
  }
}
