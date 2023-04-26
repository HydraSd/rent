import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:rent/api.dart';
import 'package:google_maps_webservice/places.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final loc.Location _location = loc.Location();
  LatLng? _currentLocation;
  final LatLng _center = const LatLng(7.873054, 80.771797);
  String locationDis = "Search location";
  final FocusNode _focusNode = FocusNode();
  late GoogleMapsPlaces _places;
  late String placeholder = "";
  final Set<Marker> _marker = {};

  String? mapStyle;
  @override
  void initState() {
    super.initState();
    _getLocation();
    _loadMapStyle();
    _places = GoogleMapsPlaces(apiKey: api);
  }

  Future<void> _loadMapStyle() async {
    final String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    setState(() {
      mapStyle = style;
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _mapController = controller;
      _mapController!.setMapStyle(mapStyle);
    });
  }
  // Future<void> _onMapController(GoogleMapController controller) async {
  //   setState(() {
  //     _mapController = controller;
  //     // _mapController?.setMapStyle(_mapStyle);
  //   });
  // }

  Future<void> _getLocation() async {
    final loc.LocationData locationData = await _location.getLocation();

    setState(() {
      _currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: Theme.of(context).iconTheme,
          centerTitle: true,
          title: Text(
            "Map",
            style: TextStyle(
                color: brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
              child: GestureDetector(
                onTap: () {
                  PlacesAutocomplete.show(
                    context: context,
                    apiKey: api,
                    mode: Mode.overlay,
                    language: 'en',
                    types: [],
                    components: [Component(Component.country, 'lk')],
                    strictbounds: false,
                    hint: locationDis,
                  ).then((place) async {
                    if (place != null) {
                      final detail =
                          await _places.getDetailsByPlaceId(place.placeId!);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lng = geometry.location.lng;
                      final newlatLang = LatLng(lat, lng);

                      setState(() {
                        _currentLocation = newlatLang;
                        locationDis = place.description!;
                        _marker.clear();
                        _marker.add(Marker(
                          markerId: MarkerId(place.placeId!),
                          position: newlatLang,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                          infoWindow: InfoWindow(title: place.description!),
                        ));
                      });

                      _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: newlatLang, zoom: 20)));
                    }
                  });
                },
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Search your place"),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.search),
                        )
                      ]),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context, {
                "latitude": _currentLocation!.latitude,
                "longitude": _currentLocation!.longitude,
                // "currentLocation": _currentLocation,
                "location": locationDis,
              });
            },
            child: const Icon(Icons.add),
          ),
        ),
        body: GoogleMap(
          markers: _marker,
          zoomControlsEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition:
              CameraPosition(target: _currentLocation ?? _center, zoom: 12),
          onMapCreated: _onMapCreated,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
        ),
      ),
    );
  }
}
