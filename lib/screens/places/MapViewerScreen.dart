import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_travel_planner/appBrain/location.dart';
import 'package:smart_travel_planner/widgets/icon_badge.dart';
import 'package:geolocator/geolocator.dart';

class MapViewScreen extends StatefulWidget {
  final PlaceLocation place;

  const MapViewScreen(this.place);

  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  @override
  void initState() {
    super.initState();
    place_coo = widget.place;
    _getCurrentLocation(false);
    _setMarkers();
  }

  // For controlling the view of the Map
  late GoogleMapController mapController;

  // To store current location of the Map view
  late LatLng currentCordinates;

  // Initial location of the Map view
  late PlaceLocation place_coo = widget.place;
  late double? _lat = place_coo.getLatitude();
  late double? _long = place_coo.getLongitude();
  late LatLng _center = LatLng(_lat!, _long!);
  late CameraPosition _initialLocation =
      CameraPosition(target: _center, zoom: 15.0);

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  late final Geolocator _geolocator = Geolocator();

  // For storing the current position
  late Position _currentPosition;

  // Method for retrieving the current location
  _getCurrentLocation(bool move) async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        // Store the position in the variable
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');

        // For moving the camera to current location
        if (move) {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 18.0,
              ),
            ),
          );
        }
      });
    }).catchError((e) {
      print(e);
    });
  }

  //Marker List
  late Set<Marker> markers = {};

  _setMarkers() {
    // Start Location Marker
    // Marker startMarker = Marker(
    //   markerId: MarkerId('$_currentPosition'),
    //   position: LatLng(
    //     _currentPosition.latitude,
    //     _currentPosition.longitude,
    //   ),
    //   infoWindow: InfoWindow(
    //     title: 'Start',
    //     snippet: '(${_currentPosition.latitude},${_currentPosition.longitude})',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker,
    // );

    // Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId('$_center'),
      position: LatLng(
        _center.latitude,
        _center.longitude,
      ),
      infoWindow: InfoWindow(
        title: 'Destination',
        snippet: '(${_center.latitude},${_center.longitude})',
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    // Add the markers to the list
    //markers.add(startMarker);
    markers.add(destinationMarker);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: IconBadge(
                icon: Icons.notifications_none,
                color: Colors.amber,
                size: 24.0,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              markers: markers,
            ),
            //Zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Show current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange[100], // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          _getCurrentLocation(true);
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
