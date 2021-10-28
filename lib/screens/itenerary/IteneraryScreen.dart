import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_place/google_place.dart' as gp;
import 'package:smart_travel_planner/appBrain/placeInformation.dart';
import 'package:smart_travel_planner/util/const.dart';
import 'package:smart_travel_planner/widgets/horizontal_place_item.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';

class IteneraryScreen extends StatefulWidget {
  const IteneraryScreen({Key? key}) : super(key: key);
  @override
  IteneraryScreenState createState() => new IteneraryScreenState();
}

class IteneraryScreenState extends State<IteneraryScreen> {
  bool isDoFetching = false;
  bool isEatFetching = false;
  bool isStayFetching = false;
  List<PlaceInformation> nearByDoPlaces = [];
  List<PlaceInformation> nearByEatPlaces = [];
  List<PlaceInformation> nearByStayPlaces = [];
  var googlePlace = gp.GooglePlace(GOOGLE_API_KEY);

  //get nearby do places
  void getNearbyDoPlacesData(latitude, longitude) async {
    setState(() {
      isDoFetching = true;
    });

    var result = await googlePlace.search.getNearBySearch(
      gp.Location(lat: latitude, lng: longitude),
      3500,
      type:
          "library|beauty_salon|clothing_store|hair_care|home_goods_store|movie_theater|museum|park|shopping_mall|spa|supermarket|tourist_attraction",
    );

    var nearBySearrchResults = result!.results;

    if (nearBySearrchResults != null) {
      for (var placeInfo in nearBySearrchResults) {
        // ignore: unnecessary_null_comparison
        if (placeInfo != null) {
          var businessStatus = placeInfo.businessStatus;
          var location;
          var longitude;
          var latitude;
          var geometry = placeInfo.geometry;

          var weatherDetails = [];
          if (geometry != null) {
            location = geometry.location;
            if (location != null) {
              latitude = location.lat;
              longitude = location.lng;

              //weather details
              String urlName =
                  "https://api.openweathermap.org/data/2.5/weather?lat=" +
                      latitude.toString() +
                      "&lon=" +
                      longitude.toString() +
                      "&appid=a47323fec912e74eeecd6507fb739b9d";
              var url = Uri.parse(urlName);
              var response = await http.get(url);
              //print(response);

              //sample response
              // {"coord":{"lon":0.25,"lat":51.4859},
              //"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],
              // "base":"stations",
              // "main":{"temp":284.3,"feels_like":283.14,"temp_min":282.74,"temp_max":286.2,"pressure":1011,"humidity":64},
              // "visibility":10000,
              // "wind":{"speed":0.89,"deg":7,"gust":4.47},
              // "clouds":{"all":20},"dt":1634820109,
              // "sys":{"type":2,"id":2011528,"country":"GB","sunrise":1634797990,"sunset":1634835224},
              // "timezone":3600,"id":2639845,
              // "name":"Purfleet","cod":200}

              if (response.statusCode == 200) {
                var jsonResponse = jsonDecode(response.body);
                weatherDetails = jsonResponse['weather'].toSet().toList();
                print(weatherDetails);
              }
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
              weather: weatherDetails);

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

          nearByDoPlaces.add(placeInformation);
        }
      }
    }

    setState(() {
      isDoFetching = false;
    });
  }

  //get nearby eat places
  void getNearbyEatPlacesData(latitude, longitude) async {
    setState(() {
      isEatFetching = true;
    });

    var result = await googlePlace.search.getNearBySearch(
      gp.Location(lat: latitude, lng: longitude),
      3500,
      type: "bar|cafe|liquor_store|meal_delivery|meal_takeaway|restaurant",
    );

    var nearBySearrchResults = result!.results;

    if (nearBySearrchResults != null) {
      for (var placeInfo in nearBySearrchResults) {
        // ignore: unnecessary_null_comparison
        if (placeInfo != null) {
          var businessStatus = placeInfo.businessStatus;
          var location;
          var longitude;
          var latitude;
          var geometry = placeInfo.geometry;

          var weatherDetails = [];
          if (geometry != null) {
            location = geometry.location;
            if (location != null) {
              latitude = location.lat;
              longitude = location.lng;

              //weather details
              String urlName =
                  "https://api.openweathermap.org/data/2.5/weather?lat=" +
                      latitude.toString() +
                      "&lon=" +
                      longitude.toString() +
                      "&appid=a47323fec912e74eeecd6507fb739b9d";
              var url = Uri.parse(urlName);
              var response = await http.get(url);

              if (response.statusCode == 200) {
                var jsonResponse = jsonDecode(response.body);
                weatherDetails = jsonResponse['weather'].toSet().toList();
                print(weatherDetails);
              }
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
              weather: weatherDetails);

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

          nearByDoPlaces.add(placeInformation);
        }
      }
    }

    setState(() {
      isEatFetching = false;
    });
  }

  //get nearby eat places
  void getNearbyStayPlacesData(latitude, longitude) async {
    setState(() {
      isStayFetching = true;
    });

    var result = await googlePlace.search.getNearBySearch(
      gp.Location(lat: latitude, lng: longitude),
      3500,
      type: "lodging",
    );

    var nearBySearrchResults = result!.results;

    if (nearBySearrchResults != null) {
      for (var placeInfo in nearBySearrchResults) {
        // ignore: unnecessary_null_comparison
        if (placeInfo != null) {
          var businessStatus = placeInfo.businessStatus;
          var location;
          var longitude;
          var latitude;
          var geometry = placeInfo.geometry;

          var weatherDetails = [];
          if (geometry != null) {
            location = geometry.location;
            if (location != null) {
              latitude = location.lat;
              longitude = location.lng;

              //weather details
              String urlName =
                  "https://api.openweathermap.org/data/2.5/weather?lat=" +
                      latitude.toString() +
                      "&lon=" +
                      longitude.toString() +
                      "&appid=a47323fec912e74eeecd6507fb739b9d";
              var url = Uri.parse(urlName);
              var response = await http.get(url);

              if (response.statusCode == 200) {
                var jsonResponse = jsonDecode(response.body);
                weatherDetails = jsonResponse['weather'].toSet().toList();
                print(weatherDetails);
              }
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
              weather: weatherDetails);

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

          nearByDoPlaces.add(placeInformation);
        }
      }
    }

    setState(() {
      isStayFetching = false;
    });
  }

  void _displayPrediction(Prediction p) async {
    // get detail (lat/lng)
    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: GOOGLE_API_KEY);
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    print(lat);
    print(lng);
    getNearbyDoPlacesData(lat, lng);
    getNearbyEatPlacesData(lat, lng);
    getNearbyStayPlacesData(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      Container(
        alignment: Alignment.center,
        // ignore: deprecated_member_use
        child: RaisedButton(
          onPressed: () async {
            // show input autocomplete with selected mode
            // then get the Prediction selected
            Prediction p = await PlacesAutocomplete.show(
              context: context,
              apiKey: GOOGLE_API_KEY,
              mode: Mode.fullscreen, // Mode.overlay
              language: "en",
              //components: [Component(Component.country, "sl")],
            ) as Prediction;
            _displayPrediction(p);
          },
          child: Text('Find address'),
        ),
      ),
      isDoFetching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildHorizontalDoList(context),
      SizedBox(height: 5.0),
      isEatFetching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildHorizontalEatList(context),
      SizedBox(height: 5.0),
      isStayFetching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildHorizontalStayList(context),
    ]));
  }

  buildHorizontalDoList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: nearByDoPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceInformation place = nearByDoPlaces[index];
          return HorizontalPlaceItem(place);
        },
      ),
    );
  }

  buildHorizontalEatList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: nearByEatPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceInformation place = nearByEatPlaces[index];
          return HorizontalPlaceItem(place);
        },
      ),
    );
  }

  buildHorizontalStayList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: nearByStayPlaces.length,
        itemBuilder: (BuildContext context, int index) {
          PlaceInformation place = nearByStayPlaces[index];
          return HorizontalPlaceItem(place);
        },
      ),
    );
  }
}
