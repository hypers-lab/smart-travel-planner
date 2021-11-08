import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/util/const.dart';
import '../widgets/vertical_place_item.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isFetching = false;
  List<PlaceInformation> places = [];
  String categoryName = "restaurant";

  //initial location
  late LatLng _center = LatLng(0, 0);

  late final Geolocator _geolocator = Geolocator();

  var googlePlace = GooglePlace(GOOGLE_API_KEY);

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

  @override
  void initState() {
    super.initState();
    getNearbyPlacesDataBasedOnCategory(categoryName);
  }

  //get nearby places based on category
  void getNearbyPlacesDataBasedOnCategory(String category) async {
    setState(() {
      isFetching = true;
      categoryName = category;
      places = [];
    });

    await _getCurrentLocation();

    var result = await googlePlace.search.getNearBySearch(
        Location(
            lat: _currentPosition.latitude, lng: _currentPosition.longitude),
        3500,
        type: category);

    var nearBySearrchResults = result!.results;

    if (nearBySearrchResults != null) {
      for (var placeInfo in nearBySearrchResults) {
        if (placeInfo != null) {
          var businessStatus = placeInfo.businessStatus;
          var location;
          var longitude;
          var latitude;
          var geometry = placeInfo.geometry;
          if (geometry != null) {
            location = geometry.location;
            if (location != null) {
              latitude = location.lat;
              longitude = location.lng;
            }
          }

          var placeName = placeInfo.name;
          var openingHours = placeInfo.openingHours;
          var openStatus;
          if (openingHours != null) {
            openStatus = openingHours.openNow;
          }
          var placeId = placeInfo.id;
          var plusCode = placeInfo.plusCode;
          var address;
          if (plusCode != null) {
            address = plusCode.compoundCode;
          }
          var rating = placeInfo.rating;
          var userRatingsTotal = placeInfo.userRatingsTotal;
          var photos = placeInfo.photos;
          var photoReference;
          if (photos != null) {
            photoReference = photos[0].photoReference;
          }
          var description = placeInfo.vicinity;

          TravelDestination travelDestination = TravelDestination(
            businessStatus: businessStatus.toString(),
            placeId: placeId.toString(),
            placeName: placeName.toString(),
            photoReference: photoReference.toString(),
            rating: rating.toString(),
            userRatingsTotal: userRatingsTotal.toString(),
            latitude: latitude,
            longitude: longitude,
            description: description.toString(),
            openStatus: openStatus.toString(),
            address: address.toString(),
          );

          //default image
          Uint8List image =
              (await rootBundle.load('assets/default_place_image.jpg'))
                  .buffer
                  .asUint8List();

          var imageResult = await this
              .googlePlace
              .photos
              .get(travelDestination.photoReference, 0, 400);
          if (imageResult != null) {
            image = imageResult;
          }

          PlaceInformation placeInformation =
              PlaceInformation(travelDestination, image);

          places.add(placeInformation);
        }
      }
    }

    if (this.mounted) {
      setState(() {
        isFetching = false;
      });
    }
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      _currentPosition = position;
      print('Current Location: $_currentPosition');
    }).catchError((e) {
      print(e);
    });
  }

  //drop down selection data
  String selectedValue = "restaurant";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Library"), value: "library"),
      DropdownMenuItem(
          child: Text("Government Office"), value: "local_government_office"),
      DropdownMenuItem(child: Text("Banks"), value: "bank"),
      DropdownMenuItem(child: Text("Lodging"), value: "lodging"),
      DropdownMenuItem(child: Text("Beauty Salon"), value: "beauty_salon"),
      DropdownMenuItem(child: Text("Movie Theater"), value: "movie_theater"),
      DropdownMenuItem(child: Text("Cafe"), value: "cafe"),
      DropdownMenuItem(child: Text("Museum"), value: "museum"),
      DropdownMenuItem(child: Text("Night Club"), value: "night_club"),
      DropdownMenuItem(child: Text("Park"), value: "park"),
      DropdownMenuItem(child: Text("Clothing Store"), value: "clothing_store"),
      DropdownMenuItem(child: Text("Restaurant"), value: "restaurant"),
      DropdownMenuItem(child: Text("Spa"), value: "spa"),
      DropdownMenuItem(child: Text("Supermarkets"), value: "supermarket"),
      DropdownMenuItem(
          child: Text("Tourist Attractions"), value: "tourist_attraction"),
      DropdownMenuItem(child: Text("Laundry"), value: "laundry"),
      DropdownMenuItem(child: Text("Hardware Stores"), value: "hardware_store"),
      DropdownMenuItem(child: Text("Storage"), value: "storage"),
      DropdownMenuItem(child: Text("Temples"), value: "hindu_temple"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 5.0),
            child: DropdownButtonFormField(
              key: const Key('category-select-dropdown'),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade700, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade700, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade300,
                ),
                dropdownColor: Colors.grey.shade200,
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                    getNearbyPlacesDataBasedOnCategory(selectedValue);
                  });
                },
                items: dropdownItems),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: Text(
            categoryName.toUpperCase(),
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        isFetching
            ? Center(
                child: CircularProgressIndicator(),
              )
            : buildVerticalList(context),
      ],
    ));
  }

  //vertical list view based on the selected category
  buildVerticalList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: places.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceInformation place = places[index];
          return VerticalPlaceItem(place);
        },
      ),
    );
  }
}
