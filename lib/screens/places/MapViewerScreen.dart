import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_travel_planner/appBrain/location.dart';
import 'package:smart_travel_planner/util/const.dart';
import 'package:smart_travel_planner/widgets/icon_badge.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:smart_travel_planner/Constants.dart';

class MapViewScreen extends StatefulWidget {
  final PlaceLocation place;

  const MapViewScreen(this.place);

  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  // For controlling the view of the Map
  late GoogleMapController mapController;

  // To store current location of the Map view
  late LatLng currentCordinates;

  // Initial location of the Map view
  late PlaceLocation place_coo = widget.place;
  late String _placeName = place_coo.placeName;
  late double _lat = place_coo.setLatnLong()[0];
  late double _long = place_coo.setLatnLong()[1];
  late LatLng _center = LatLng(_lat, _long);
  late CameraPosition _initialLocation =
      CameraPosition(target: _center, zoom: 15.0);

  late final Geolocator _geolocator = Geolocator();

  // For storing the current position
  late Position _currentPosition = Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  late Position _placePosition = Position(
      longitude: _long,
      latitude: _lat,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  //Marker List
  late Set<Marker> markers = {};

  // Object for PolylinePoints
  late PolylinePoints polylinePoints;

  // List of coordinates to join
  List<LatLng> polylineCoordinates = [];

  // Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};

  // distance between two places
  late String _placeDistance = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    place_coo = widget.place;
    _getCurrentLocation();
    _setDestinationMarker();
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() async {
        // Store the position in the variable
        _currentPosition = position;

        print('Current Location: $_currentPosition');

        // For moving the camera to current location
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15.0,
            ),
          ),
        );
        _setStartMarker();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _setStartMarker() {
    // Start Location Marker
    Marker startMarker = Marker(
      markerId: MarkerId('$_currentPosition'),
      position: LatLng(
        _currentPosition.latitude,
        _currentPosition.longitude,
      ),
      infoWindow: InfoWindow(
        title: 'Your Location',
        snippet: '(${_currentPosition.latitude},${_currentPosition.longitude})',
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    // Add the markers to the list
    markers.add(startMarker);
  }

  _setDestinationMarker() {
    // Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId('$_center'),
      position: LatLng(
        _center.latitude,
        _center.longitude,
      ),
      infoWindow: InfoWindow(
        title: '$_placeName',
        snippet: '(${_center.latitude},${_center.longitude})',
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    // Add the markers to the list
    markers.add(destinationMarker);
  }

  // Method for calculating the distance between two places
  _calculateDistance() async {
    try {
      print('START COORDINATES: $_currentPosition');
      print('DESTINATION COORDINATES: $_placePosition');

      _setStartMarker();
      _setDestinationMarker();

      Position _northeastCoordinates;
      Position _southwestCoordinates;

      if (_currentPosition.latitude <= _placePosition.latitude) {
        _southwestCoordinates = _currentPosition;
        _northeastCoordinates = _placePosition;
      } else {
        _southwestCoordinates = _placePosition;
        _northeastCoordinates = _currentPosition;
      }

      // set camera view of the map
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(
              _northeastCoordinates.latitude,
              _northeastCoordinates.longitude,
            ),
            southwest: LatLng(
              _southwestCoordinates.latitude,
              _southwestCoordinates.longitude,
            ),
          ),
          100.0,
        ),
      );

      await _drawPathFromCurrentPos(_currentPosition, _placePosition);

      double totalDistance = 0.0;

      print(polylineCoordinates);

      // Calculating the total distance by adding the distance
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      _placeDistance = totalDistance.toStringAsFixed(2);
      print('DISTANCE: $_placeDistance km');

      // setState(() {
      //   _placeDistance = totalDistance.toStringAsFixed(2);
      //   print('DISTANCE: $_placeDistance km');
      // });
    } catch (e) {
      print(e);
    }
  }

  // calculating distance between two coordinates
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  _drawPathFromCurrentPos(Position start, Position destination) async {
    // Initializing PolylinePoints
    var polylinePoints = PolylinePoints();

    // drawing the polylines
    // https://maps.googleapis.com/maps/api/directions/json?
    // origin=37.7680296,-122.4375126
    // &destination=side_of_road:37.7663444,-122.4412006
    // &key=YOUR_API_KEY

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );
    print("poyline result");
    print(result.status);
    print(result.points);

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.pop(context),
          ),
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
              polylines: Set<Polyline>.of(polylines.values),
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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.orange[100], // button color
                          child: InkWell(
                            splashColor: Colors.orange, // inkwell color
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(Icons.beach_access),
                            ),
                            onTap: () {
                              //go back to travel destination location
                              mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                      _lat,
                                      _long,
                                    ),
                                    zoom: 15.0,
                                  ),
                                ),
                              );
                              _setDestinationMarker();
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ClipOval(
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
                              //show current location
                              _getCurrentLocation();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Visibility(
                            visible: _placeDistance == null ? false : true,
                            child: Text(
                              'DISTANCE: $_placeDistance km',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 16)),
                            onPressed: (_currentPosition != null &&
                                    _placePosition != null)
                                ? () async {
                                    await _calculateDistance();
                                    print('Distance is $_placeDistance');
                                    if (_placeDistance != null) {
                                      _scaffoldKey.currentState!.showSnackBar(
                                        new SnackBar(
                                          content: Text(
                                              'Distance Calculated Sucessfully'),
                                        ),
                                      );
                                    } else {
                                      _scaffoldKey.currentState!.showSnackBar(
                                        new SnackBar(
                                          content: Text(
                                              'Error Calculating Distance'),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Show Route'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ],
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
