// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// //import 'package:location/location.dart' as LocationManager;
// //import 'place_detail.dart';

// const kGoogleApiKey = "AIzaSyCJterzzFgLjdTnIlhfJ3C7m-I_484qdNE";
// GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

// class Home extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return HomeState();
//   }
// }

// class HomeState extends State<Home> {
//   final homeScaffoldKey = GlobalKey<ScaffoldState>();
//   //google map controller
//   late GoogleMapController mapController;
//   //list of nearby places
//   List<PlacesSearchResult> places = [];
//   //data fetching status
//   bool isLoading = false;
//   //error message
//   late String errorMessage = "";
//   //Marker List
//   late Set<Marker> markers = {};

//   // To store current location of the Map view
//   late LatLng currentCordinates;

//   // Initial location of the Map view
//   late LatLng _center = LatLng(0.0, 0.0);
//   late CameraPosition _initialLocation =
//       CameraPosition(target: _center, zoom: 15.0);

//   late final Geolocator _geolocator = Geolocator();

//   @override
//   initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   // Method for retrieving the current location
//   _getCurrentLocation() async {
//     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//         .then((Position position) async {
//       setState(() async {
//         // Store the position in the variable
//         _center = LatLng(position.latitude, position.longitude);
//         _initialLocation = CameraPosition(target: _center, zoom: 15.0);

//         print('Current Location: ${position.latitude}, ${position.longitude}');

//         mapController.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: _center,
//               zoom: 15.0,
//             ),
//           ),
//         );
//       });
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   void refresh() async {
//     _getCurrentLocation();
//     getNearbyPlaces(_center);
//   }

//   void _onMapCreated(GoogleMapController controller) async {
//     mapController = controller;
//     refresh();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget expandedChild;
//     if (isLoading) {
//       expandedChild = Center(child: CircularProgressIndicator(value: null));
//     } else if (errorMessage != null) {
//       expandedChild = Center(
//         child: Text(errorMessage),
//       );
//     } else {
//       expandedChild = buildPlacesList();
//     }

//     return Scaffold(
//         key: homeScaffoldKey,
//         appBar: AppBar(
//           //title: const Text("PlaceZ"),
//           actions: <Widget>[
//             isLoading
//                 ? IconButton(
//                     icon: Icon(Icons.timer),
//                     onPressed: () {},
//                   )
//                 : IconButton(
//                     icon: Icon(Icons.refresh),
//                     onPressed: () {
//                       refresh();
//                     },
//                   ),
//             IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () {
//                 _handlePressButton();
//               },
//             ),
//           ],
//         ),
//         body: Column(
//           children: <Widget>[
//             Container(
//               child: SizedBox(
//                 height: 200.0,
//                 child: GoogleMap(
//                     initialCameraPosition: _initialLocation,
//                     myLocationEnabled: true,
//                     myLocationButtonEnabled: true,
//                     mapType: MapType.normal,
//                     onMapCreated: _onMapCreated,
//                     markers: markers),
//               ),
//             ),
//             Expanded(child: expandedChild)
//           ],
//         ));
//   }

//   void getNearbyPlaces(LatLng center) async {
//     setState(() {
//       this.isLoading = true;
//       this.errorMessage = "";
//     });

//     final location = Location(lat: center.latitude, lng: center.longitude);
//     final result = await _places.searchNearbyWithRadius(location, 2500);
//     setState(() {
//       this.isLoading = false;
//       if (result.status == "OK") {
//         print("SUCCESS");
//         places = result.results;
//         result.results.forEach((f) {
//           Marker placeMarker = Marker(
//             markerId: MarkerId('${f.id}'),
//             position: LatLng(
//               f.geometry.location.lat,
//               f.geometry.location.lng,
//             ),
//             infoWindow: InfoWindow(
//               title: '${f.name}',
//               snippet: '${f.types.first}',
//             ),
//             icon: BitmapDescriptor.defaultMarker,
//           );

//           markers.add(placeMarker);

//           // final markerOptions = MarkerOptions(
//           //     position:
//           //         LatLng(f.geometry.location.lat, f.geometry!.location.lng),
//           //     infoWindowText: InfoWindowText("${f.name}", "${f.types.first}"));
//           // mapController.addMarker(markerOptions);
//         });
//       } else {
//         this.errorMessage = result.errorMessage!;
//       }
//     });
//   }

//   Future<void> _handlePressButton() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       LatLng center = LatLng(position.latitude, position.longitude);
//       Prediction? p = await PlacesAutocomplete.show(
//           context: context,
//           strictbounds: center == null ? false : true,
//           apiKey: kGoogleApiKey,
//           //onError: onError,
//           mode: Mode.fullscreen,
//           language: "en",
//           location: Location(lat: center.latitude, lng: center.longitude),
//           radius: 10000);

//       //showDetailPlace(p.placeId);
//     } catch (e) {
//       return;
//     }
//   }

//   // Future<Null> showDetailPlace(String placeId) async {
//   //   if (placeId != null) {
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(builder: (context) => PlaceDetailWidget(placeId)),
//   //     );
//   //   }
//   // }

//   ListView buildPlacesList() {
//     final placesWidget = places.map((f) {
//       List<Widget> list = [
//         Padding(
//           padding: EdgeInsets.only(bottom: 4.0),
//           child: Text(
//             f.name,
//             style: Theme.of(context).textTheme.subtitle1,
//           ),
//         )
//       ];
//       if (f.formattedAddress != null) {
//         list.add(Padding(
//           padding: EdgeInsets.only(bottom: 2.0),
//           child: Text(
//             f.formattedAddress,
//             style: Theme.of(context).textTheme.subtitle1,
//           ),
//         ));
//       }

//       if (f.vicinity != null) {
//         list.add(Padding(
//           padding: EdgeInsets.only(bottom: 2.0),
//           child: Text(
//             f.vicinity,
//             style: Theme.of(context).textTheme.bodyText2,
//           ),
//         ));
//       }

//       if (f.types.first != null) {
//         list.add(Padding(
//           padding: EdgeInsets.only(bottom: 2.0),
//           child: Text(
//             f.types.first,
//             style: Theme.of(context).textTheme.caption,
//           ),
//         ));
//       }

//       return Padding(
//         padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
//         child: Card(
//           child: InkWell(
//             onTap: () {
//               //showDetailPlace(f.placeId);
//             },
//             highlightColor: Colors.lightBlueAccent,
//             splashColor: Colors.red,
//             child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: list,
//               ),
//             ),
//           ),
//         ),
//       );
//     }).toList();

//     return ListView(shrinkWrap: true, children: placesWidget);
//   }
// }
