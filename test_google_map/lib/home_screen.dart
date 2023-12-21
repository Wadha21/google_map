import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng sourceLocation1 = LatLng(37.33500303, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.0660055);
  late BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final Completer<GoogleMapController> controller = Completer();
  @override
  void initState() {
    super.initState();
    addCustomIcon();
  }

  Future<void> addCustomIcon() async {
    final ByteData byteData =
        await rootBundle.load("lib/assets/Logo-Filled.png");
    final Uint8List imageData = byteData.buffer.asUint8List();
    markerIcon = BitmapDescriptor.fromBytes(imageData);
  }

  Set<Marker> _createMarkers() {
    final Set<Marker> markers = {};

    Marker marker1 = Marker(
      markerId: MarkerId('1'),
      position: sourceLocation,
      icon: markerIcon,
    );
    markers.add(marker1);

    Marker marker2 = Marker(
      markerId: MarkerId('2'),
      position: destination,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    markers.add(marker2);

    Marker marker3 = Marker(
      markerId: MarkerId('3'),
      position: sourceLocation1,
      icon: markerIcon,
    );
    markers.add(marker3);

    return markers;
  }

  Set<Polyline> _createPolylines() {
    final Set<Polyline> polylines = {};

    Polyline polyline = Polyline(
      polylineId: PolylineId('route'),
      color: Colors.green,
      width: 5,
      points: [sourceLocation, sourceLocation1, destination],
    );
    polylines.add(polyline);

    return polylines;
  }

  @override
  Widget build(BuildContext context) {
    final markers = _createMarkers();
    final polylines = _createPolylines();

    return Scaffold(
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context)
            .loadString('lib/assets/dark_map_style.json'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition:
                  CameraPosition(target: sourceLocation, zoom: 14.5),
              markers: Set<Marker>.of(markers),
              polylines: polylines,
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(snapshot.data!);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
