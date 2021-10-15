// import 'package:flutter/material.dart';
// import 'package:smart_travel_planner/appBrain/Trip.dart';
// import 'package:smart_travel_planner/widgets/search_bar.dart';
// import 'package:smart_travel_planner/widgets/verticle_trip_item.dart';

// class IteneraryScreen extends StatefulWidget {
//   const IteneraryScreen({Key? key}) : super(key: key);

//   @override
//   _IteneraryScreenState createState() => _IteneraryScreenState();
// }

// class _IteneraryScreenState extends State<IteneraryScreen> {
//   bool isFetching = false;
//   final List<Trip> _trips = Trip.getTripDetailsDummy();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.all(20.0),
//             child: SearchBar(),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//             child: Text(
//               "Planned Trips",
//               style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           isFetching
//               ? Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : buildVerticalList()
//         ],
//       ),
//     );
//   }

//   buildVerticalList() {
//     return Padding(
//       padding: EdgeInsets.all(20.0),
//       child: ListView.builder(
//         primary: false,
//         physics: NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemCount: _trips.length,
//         itemBuilder: (BuildContext context, int index) {
//           Trip trip = _trips[index];
//           return VerticalTripItem(trip);
//         },
//       ),
//     );
//   }
// }
