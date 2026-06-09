import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../constants/app_routes.dart';
import '../../../helper/nominatim_helper.dart';

class MapLocationPickerScreen extends StatefulWidget {
  const MapLocationPickerScreen({Key? key}) : super(key: key);

  @override
  _MapLocationPickerScreenState createState() => _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  MapController mapController = MapController();
  LatLng? _currentPosition;
  String _address = "Locating...";
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  Map<String, dynamic>? _addressMap;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
        _address = "Location services disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
          _address = "Location permission denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
        _address = "Location permissions permanently denied.";
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      mapController.move(_currentPosition!, 16.0);
      _getAddressFromLatLng(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _address = "Failed to get location";
        // Default to a central location if GPS fails
        _currentPosition = const LatLng(12.9716, 77.5946); // Bangalore
      });
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    setState(() {
      _address = "Locating...";
    });
    final result = await NominatimHelper.reverseGeocode(lat, lng);
    if (result != null) {
      setState(() {
        _address = result['address_string'] ?? "Unknown address";
        _addressMap = result['address'] as Map<String, dynamic>?;
      });
    } else {
      setState(() {
        _address = "Address not found";
      });
    }
  }

  void _performSearch(String query) async {
    if (query.isEmpty) return;
    setState(() => _isSearching = true);
    final results = await NominatimHelper.searchPlaces(query);
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  void _onCameraIdle() {
    if (_currentPosition != null) {
      _getAddressFromLatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Delivery Location", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: _currentPosition!,
                  initialZoom: 16.0,
                  onPositionChanged: (position, hasGesture) {
                    if (position.center != null) {
                      _currentPosition = position.center;
                    }
                  },
                  onMapEvent: (event) {
                    if (event is MapEventMoveEnd) {
                      _onCameraIdle();
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
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 35.0),
                  child: Icon(Icons.location_pin, size: 45, color: Colors.red),
                ),
              ),
              // Search Bar Overlay
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search for a place...",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          suffixIcon: IconButton(
                            icon: _isSearching ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.search),
                            onPressed: () => _performSearch(_searchController.text),
                          ),
                        ),
                        onSubmitted: _performSearch,
                      ),
                    ),
                    if (_searchResults.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                        ),
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final place = _searchResults[index];
                            return ListTile(
                              title: Text(place['display_name'], maxLines: 2, overflow: TextOverflow.ellipsis),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                final lat = place['lat'] as double;
                                final lon = place['lon'] as double;
                                mapController.move(LatLng(lat, lon), 16.0);
                                setState(() {
                                  _searchResults = [];
                                  _searchController.clear();
                                });
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              // My Location FAB
              Positioned(
                bottom: 220,
                right: 15,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.my_location, color: Colors.black87),
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _getCurrentLocation();
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Delivery Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, color: Colors.red, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(_address, style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            // Forward the address data to the manual form to capture House No. / Building name
                            Navigator.pushReplacementNamed(
                              context, 
                              AppRoute.addEditAddress,
                              arguments: {
                                "addressId": null, 
                                "locationData": {
                                  "address_string": _address,
                                  "address": _addressMap ?? {}
                                }
                              }
                            );
                          },
                          child: const Text("Enter Complete Address", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
    );
  }
}
