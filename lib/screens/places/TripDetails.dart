import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_place/google_place.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';
import 'package:smart_travel_planner/appBrain/Trip.dart';
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/util/const.dart';
import 'package:smart_travel_planner/widgets/vertical_place_item.dart';
import '../../widgets/vertical_place_item.dart';

class TripDetails extends StatefulWidget {
  static const String id = 'tripDetails';

  TripDetails({required this.trip});

  final Trip trip;

  @override
  _TripDetailsState createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  late Trip trip = widget.trip;
  bool isFetching = false;
  List<PlaceInformation> places = [];

  var googlePlace = GooglePlace(GOOGLE_API_KEY);

  @override
  void initState() {
    super.initState();
    getPlacesData(trip);
  }

  getPlacesData(trip) {
    setState(() {
      isFetching = true;
    });

    trip.places.forEach((placeId) async {
      var result = await this.googlePlace.details.get(placeId);
      if (result != null && result.result != null && mounted) {
        var placeInfo = result.result;

        var businessStatus = placeInfo!.businessStatus;
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
    });
    setState(() {
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Places",
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
              : buildVerticalList(),
        ],
      ),
    );
  }

  buildVerticalList() {
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
