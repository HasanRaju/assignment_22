import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OrderTrackingPage(),
    );
  }
}

class OrderTrackingPage extends StatefulWidget {
  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final Location _location = Location();
  List<LatLng> _polylinePoints = [];

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);

  @override
  void initState() {
    super.initState();
    _getLocationUpdates();
  }

  Future<void> _getLocationUpdates() async {
    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _polylinePoints.add(LatLng(locationData.latitude!, locationData.longitude!));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Location Tracking')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: sourceLocation,
          zoom: 13.5,
        ),
        markers: {
          Marker(
            markerId: MarkerId('source'),
            position: sourceLocation,
            infoWindow: InfoWindow(
              title: 'My current location',
              snippet: 'Lat: ${sourceLocation.latitude}, Lng: ${sourceLocation.longitude}',
            ),
          ),
        },
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            points: _polylinePoints,
          ),
        },
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
      ),
    );
  }
}
