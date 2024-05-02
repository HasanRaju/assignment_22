import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(LocationTrackerApp());
}

class LocationTrackerApp extends StatefulWidget {
  @override
  _LocationTrackerAppState createState() => _LocationTrackerAppState();
}

class _LocationTrackerAppState extends State<LocationTrackerApp> {
  GoogleMapController? _mapController;
  Marker? _userMarker;
  List<LatLng> _polylinePoints = [];

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  void _initLocationTracking() async {
    final Geolocator geolocator = Geolocator();
    final Position position = await geolocator.getCurrentPosition();

    setState(() {
      _userMarker = Marker(
        markerId: MarkerId('user'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: 'My current location',
          snippet: '${position.latitude}, ${position.longitude}',
        ),
      );
      _polylinePoints.add(LatLng(position.latitude, position.longitude));
    });
  }

  void _updateLocation() async {
    final Geolocator geolocator = Geolocator();
    final Position position = await geolocator.getCurrentPosition();

    setState(() {
      _userMarker = Marker(
        markerId: MarkerId('user'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: 'My current location',
          snippet: '${position.latitude}, ${position.longitude}',
        ),
      );
      _polylinePoints.add(LatLng(position.latitude, position.longitude));
    });

    // Update polyline on the map
    _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Real-Time Location Tracker')),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(0, 0), // Initial center (update with user's location)
            zoom: 15,
          ),
          markers: _userMarker != null ? Set.of([_userMarker!]) : Set(),
          polylines: Set.of([
            Polyline(
              polylineId: PolylineId('userPath'),
              points: _polylinePoints,
              color: Colors.blue,
              width: 5,
            ),
          ]),
          onMapCreated: (controller) {
            _mapController = controller;
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _updateLocation,
          child: Icon(Icons.location_on),
        ),
      ),
    );
  }
}

