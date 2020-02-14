import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:klik_deals/ApiBloc/models/UpdateProfileResponse.dart';
import 'package:search_map_place/search_map_place.dart';

class SelectAddress extends StatefulWidget {
  SelectAddress({Key key, this.lat, this.long, this.addressString})
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

  _SelectAddressState(this.latitudeStr, this.longitudeStr, this.addressStr);

  @override
  void initState() {
    print(
        "2 latitude :: $latitudeStr longitude :: $longitudeStr address :: $addressStr");


    latitude = double.parse(latitudeStr.toString());
    longitude = double.parse(longitudeStr.toString());

    print(
        "3 latitude :: $latitude longitude :: $longitude address :: $addressStr");
  }

  Completer<GoogleMapController> _mapController = Completer();
  String API_KEY = "AIzaSyCRYvqSRrhfWyH7JHKSgnakK-dV8bUIcA8";
  final CameraPosition _initialCamera = CameraPosition(

    target: LatLng(latitude != null ? latitude : 23.039298,
        longitude != null ? longitude : 72.564697),
//    target: LatLng(32, 42),
    zoom: 14.0000,
  );

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
              print(
                  "selected latlong :: ${latLong.latitude} :: ${latLong
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
                _validate(context, selectedLatitude, selectedLongitude,
                    selectedAddress);
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
      context, "$selectedLatitude,,$selectedLongitude,,$selectedAddress");
}
