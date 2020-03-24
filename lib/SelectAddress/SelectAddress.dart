import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vendor/ApiBloc/models/UpdateProfileResponse.dart';
import 'package:search_map_place/search_map_place.dart';

class SelectAddress extends StatefulWidget {
  SelectAddress(
      {Key key,
      @required this.lat,
      @required this.long,
      @required this.addressString})
      : super(key: key);
  final String lat;
  final String long;
  final String addressString;

  _SelectAddressState createState() =>
      _SelectAddressState(lat, long, addressString);
}

class _SelectAddressState extends State<SelectAddress> {
  String latitudeStr;
  String longitudeStr;
  String addressStr;
  static double latitude;
  static double longitude;
  UpdateProfileResponse profileResponse;
  String selectedLatitude;
  String selectedLongitude;
  String selectedAddress;
  CameraPosition _initialCamera;

  Completer<GoogleMapController> _mapController = Completer();
   static const String API_KEY = "AIzaSyCRYvqSRrhfWyH7JHKSgnakK-dV8bUIcA8";
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  BitmapDescriptor _markerIcon;

  _SelectAddressState(this.latitudeStr, this.longitudeStr, this.addressStr);
  final MarkerId markerId = MarkerId("Home");

  @override
  void initState() {
    super.initState();
    if (latitudeStr != null && latitudeStr.isNotEmpty) {
      latitude = double.parse(latitudeStr.toString());
    } else {
      latitude = 45.508888;
    }

    if (longitudeStr != null && longitudeStr.isNotEmpty) {
      longitude = double.parse(longitudeStr.toString());
    } else {
      longitude = -73.561668;
    }
    LatLng _kMapCenter = LatLng(latitude, longitude);
    _initialCamera = CameraPosition(
      target: _kMapCenter,
      zoom: 21.0000,
    );

    createMarker(_kMapCenter);
  }

  void createMarker(LatLng _kMapCenter) {
    Marker marker = Marker(
      markerId: markerId,
      position: _kMapCenter,
      // draggable: true,
      infoWindow: InfoWindow(title: "Current Address", snippet: '*'),
      // onTap: () {
      //   _onMarkerTapped(markerId);
      // },
      onDragEnd: (LatLng position) {
        _onMarkerDragEnd(markerId, position);
      },
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    // final Marker tappedMarker = markers[markerId];
    selectedLatitude = newPosition.latitude.toString();
    selectedLongitude = newPosition.longitude.toString();
  }

  Set<Marker> _createMarker() {
    print("we got _createMarker");
    // https://github.com/flutter/flutter/issues/28312
    // ignore: prefer_collection_literals
    return <Marker>[
      Marker(
        markerId: MarkerId("marker_1"),
        position: LatLng(latitude, longitude),
        icon: _markerIcon,
      ),
    ].toSet();
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/baseline_location.png')
          .then(_updateBitmap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    print("we got _updateBitmap and " + (bitmap != null).toString());
    setState(() {
      _markerIcon = bitmap;
    });
  }

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Address', style: Theme.of(context).textTheme.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash_bg.webp'),
                  fit: BoxFit.cover)),
        ),
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _initialCamera,
          onMapCreated: (GoogleMapController controller) {
            _mapController.complete(controller);
          },
          markers: Set<Marker>.of(markers.values),
          // _createMarker(),
        ),
        Positioned(
          top: 10,
//          height: MediaQuery.of(context).size.height*0.11,
          left: MediaQuery.of(context).size.width * 0.05,
          width: MediaQuery.of(context).size.width * 0.9,
          child: SearchMapPlaceWidget(
            apiKey: API_KEY,
            location: _initialCamera.target,
            radius: 30000,
            placeholder: "Search",
            onSelected: (place) async {
              print("Selected Place name ::: ${place.description}");
              selectedAddress = place.description;
              final geoLocation = await place.geolocation;

              final GoogleMapController controller =
                  await _mapController.future;

              final latLong = geoLocation.coordinates as LatLng;
              print(
                  "selected latLong :: ${latLong.latitude} :: ${latLong.longitude}");
              selectedLatitude = latLong.latitude.toString();
              selectedLongitude = latLong.longitude.toString();
              controller.animateCamera(
                  CameraUpdate.newLatLng(geoLocation.coordinates));
              controller.animateCamera(
                  CameraUpdate.newLatLngBounds(geoLocation.bounds, 0));
              markers.remove(markerId);
              createMarker(latLong);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                _validate(
                    context,
                    selectedLatitude != null
                        ? selectedLatitude
                        : latitude.toString(),
                    selectedLongitude != null
                        ? selectedLongitude
                        : longitude.toString(),
                    selectedAddress != null ? selectedAddress : addressStr);
              },
              child: Icon(Icons.done),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ]),
    );
  }
}

void _validate(BuildContext context, String selectedLatitude,
    String selectedLongitude, String selectedAddress) {
  Navigator.pop(
      context, "$selectedLatitude * $selectedLongitude * $selectedAddress");
}
