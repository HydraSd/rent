import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rent/api.dart';
import 'package:http/http.dart' as http;

class DirectionScreen extends StatefulWidget {
  final double lat;
  final double long;
  const DirectionScreen({super.key, required this.lat, required this.long});

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  GoogleMapController? _mapController;
  late LatLng destination;
  LocationData? currentLocation;
  final polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  String? _mapStyle;

  @override
  void initState() {
    // getCurrentLocation();
    super.initState();
    _loadMapStyle();
    destination = LatLng(widget.lat, widget.long);
    getPolyPoints();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _mapController = controller;
      _mapController!.setMapStyle(_mapStyle);
    });
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    Location location = Location();
    await location.getLocation().then((value) {
      setState(() {
        currentLocation = value;
      });
    });
  }

  Future<void> getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    Location location = Location();
    LocationData currentLocation1 = await location.getLocation();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      api,
      PointLatLng(currentLocation1.latitude!, currentLocation1.longitude!),
      PointLatLng(destination.latitude, destination.longitude),
    );
    List<LatLng> coordinates = [];
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        coordinates.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {
        polylineCoordinates = coordinates;
      });
    }
  }

  Future<void> _loadMapStyle() async {
    final String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    setState(() {
      _mapStyle = style;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
        title: const Text("Directions"),
        titleTextStyle: Theme.of(context).textTheme.headline6,
        actions: [
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                  child: TextButton(
                      onPressed: () {
                        _mapController!.moveCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(currentLocation!.latitude!,
                                    currentLocation!.longitude!),
                                zoom: 16,
                                tilt: 50)));
                        Navigator.pop(context);
                      },
                      child: const Text("Your location"))),
              PopupMenuItem(
                  child: TextButton(
                      onPressed: () {
                        _mapController!.moveCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(destination.latitude,
                                    destination.longitude),
                                zoom: 16,
                                tilt: 50)));
                        Navigator.pop(context);
                      },
                      child: const Text("destination")))
            ];
          })
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: destination, zoom: 14.5),
        zoomControlsEnabled: true,
        // myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
        markers: {
          Marker(
              markerId: const MarkerId("destination"), position: destination),
          if (currentLocation != null)
            Marker(
                markerId: const MarkerId("your location"),
                position: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!))
        },
        polylines: {
          Polyline(
              polylineId: const PolylineId("route"),
              points: polylineCoordinates,
              // points: [
              //   if (currentLocation != null)
              //     LatLng(
              //         currentLocation!.latitude!, currentLocation!.longitude!),
              //   LatLng(destination.latitude, destination.longitude),
              // ],
              color: Colors.black,
              width: 6)
        },
      ),
    );
  }
}
