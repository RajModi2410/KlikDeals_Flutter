import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:klik_deals/ApiBloc/models/UpdateProfileResponse.dart';
import 'package:search_map_place/search_map_place.dart';

class SelectAddress extends StatefulWidget {
  SelectAddress(
      {Key key, @required this.lat, @required this.long, @required this.addressString})
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
  String API_KEY = "AIzaSyCRYvqSRrhfWyH7JHKSgnakK-dV8bUIcA8";

  _SelectAddressState(this.latitudeStr, this.longitudeStr, this.addressStr);

  @override
  void initState() {
    latitude = double.parse(latitudeStr.toString());
    longitude = double.parse(longitudeStr.toString());

    _initialCamera = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.0000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Address'),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash_bg.png'),
                  fit: BoxFit.cover)),
        ),

        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _initialCamera,
          onMapCreated: (GoogleMapController controller) {
            _mapController.complete(controller);
          },
        ),

        Positioned(
          top: 10,
//          height: MediaQuery.of(context).size.height*0.11,
          left: MediaQuery
              .of(context)
              .size
              .width * 0.05,
          width: MediaQuery
              .of(context)
              .size
              .width * 0.9,
          child: SearchMapPlaceWidget(
            apiKey: API_KEY,
            location: _initialCamera.target,
            radius: 30000,
            placeholder: "Search",
            onSelected: (place) async {
              print("Selected Place name ::: ${place.description}");
              selectedAddress = place.description;
              final geolocation = await place.geolocation;

              final GoogleMapController controller =
              await _mapController.future;

              final latLong = geolocation.coordinates as LatLng;
              print("selected latlong :: ${latLong.latitude} :: ${latLong
                  .longitude}");
              selectedLatitude = latLong.latitude.toString();
              selectedLongitude = latLong.longitude.toString();
              controller.animateCamera(
                  CameraUpdate.newLatLng(geolocation.coordinates));
              controller.animateCamera(
                  CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                _validate(context,
                    selectedLatitude != null ? selectedLatitude : latitude
                        .toString()
                    , selectedLongitude != null ? selectedLongitude : longitude
                        .toString(),
                    selectedAddress != null ? selectedAddress : addressStr);
              },
              child: Icon(Icons.done),
              backgroundColor: Colors.redAccent,
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
