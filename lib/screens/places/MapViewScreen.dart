import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_travel_planner/util/LocationServices.dart';
import 'package:smart_travel_planner/util/const.dart';
import 'package:smart_travel_planner/util/location.dart';
import 'package:smart_travel_planner/widgets/icon_badge.dart';
import 'package:geolocator/geolocator.dart';

class MapViewScreen extends StatefulWidget {
  final PlaceLocation place;

  const MapViewScreen(this.place);

  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  late GoogleMapController mapController;
  late LatLng currentCordinates;

  late PlaceLocation place_coo = widget.place;

  @override
  void initState() {
    super.initState();
    place_coo = widget.place;
  }

  late double _lat = place_coo.getLatitude();
  late double _long = place_coo.getLongitude();

  late LatLng _center = LatLng(_lat, _long);

  final Set<Marker> _markers = {};

  late LatLng _lastMapPosition = _center;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  getCurrentLocation() async {
    try {
      Position initLocation =
          await LocationService.getPosition(LocationConstant.CurrentPosition);
      currentCordinates = LatLng(initLocation.latitude, initLocation.longitude);
      mapController.moveCamera(CameraUpdate.newLatLng(currentCordinates));
      // setState(() {
      //   var mark = Marker(
      //     markerId: MarkerId('Current'),
      //     position: LatLng(initLocation.latitude, initLocation.longitude),
      //   );
      //   print(initLocation.latitude);
      //   print(initLocation.longitude);
      //   //Provider.of<Data>(context, listen: false).markers.add(mark);
      // });
    } on LocationServiceDisabledException catch (e) {
      dialogLocationError(
          'Location disabled in your phone', 'Please on location');
      print('hello,location service disables');
    } on PermissionDeniedException catch (e) {
      dialogLocationError('Location Denied in your phone',
          'Please give permission to the Application');
      print('permission denied');
    } on DeniedForeverException catch (e) {
      dialogLocationError('Location Denied in your phone',
          'Please give permission to the Application');
      print('permission forever denied');
    } catch (e) {
      print(e);
      dialogLocationError('Something went Wrong!!!!!',
          'Please check your Mobile Location Service');
    }
  }

  Future<dynamic> dialogLocationError(String title, String body) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('$title'),
        content: Text('$body'),
        actions: <Widget>[
          TextButton(
            onPressed: () => {
              //Navigator.popUntil(
              //context, ModalRoute.withName(LoginScreen.screenId))
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: _markers,
              //onCameraMove: _onCameraMove,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: _onAddMarkerButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.lightBlue,
                      child: const Icon(Icons.add_location, size: 30.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton(
                      onPressed: getCurrentLocation,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.lightBlue,
                      child: const Icon(Icons.location_searching_sharp,
                          size: 30.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
