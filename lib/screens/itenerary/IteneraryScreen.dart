import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/Trip.dart';
import 'package:smart_travel_planner/util/tripsdata.dart';
import 'package:smart_travel_planner/widgets/search_bar.dart';
import 'package:smart_travel_planner/widgets/verticle_trip_item.dart';

class IteneraryScreen extends StatefulWidget {
  const IteneraryScreen({Key? key}) : super(key: key);

  @override
  _IteneraryScreenState createState() => _IteneraryScreenState();
}

class _IteneraryScreenState extends State<IteneraryScreen> {
  bool isFetching = false;
  final Future<List<Trip>> _trips = Future<List<Trip>>.delayed(
      const Duration(seconds: 2), () => Trip.getTripDetailsDummy());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: SearchBar(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: Text(
              "Planned Trips",
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
              : Container(
                  child: FutureBuilder<List<Trip>>(
                    future:
                        _trips, // a previously-obtained Future<String> or null
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Trip>> snapshot) {
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: ListView.builder(
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            Trip trip = Trip(
                                tripName: snapshot.data![index].tripName,
                                places: snapshot.data![index].places,
                                date: snapshot.data![index].date,
                                image: snapshot.data![index].image,
                                status: snapshot.data![index].status,
                                userId: snapshot.data![index].userId);
                            return VerticalTripItem(trip);
                          },
                        ),
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }

  // buildVerticalList() {
  //   return Padding(
  //     padding: EdgeInsets.all(20.0),
  //     child: ListView.builder(
  //       primary: false,
  //       physics: NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       itemCount: _trips.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         Trip trip = _trips[index];
  //         return VerticalTripItem(trip);
  //       },
  //     ),
  //   );
  // }
}
