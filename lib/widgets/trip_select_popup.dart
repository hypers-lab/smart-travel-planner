import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_travel_planner/appBrain/TravelDestination.dart';

class TripSelectPopUp extends StatefulWidget {
  var tripNameController;

  TripSelectPopUp({
    Key? key,
    required this.tripNameController,
  }) : super(key: key);

  @override
  _TripSelectPopUpState createState() => _TripSelectPopUpState();
}

class _TripSelectPopUpState extends State<TripSelectPopUp> {
  late final TextEditingController tripNameController;
  late String selectedValue = 'Trip 01';

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Trip 01"), value: "Trip 01"),
      DropdownMenuItem(child: Text("Trip 02"), value: "Trip 02"),
      DropdownMenuItem(child: Text("Trip 03"), value: "Trip 03"),
      DropdownMenuItem(child: Text("Trip 04"), value: "Trip 04"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add to a Trip Plan'),
      content: DropdownButton(
          value: selectedValue,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
            });
          },
          items: dropdownItems),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Send them to your email maybe?
            var tripName = tripNameController.text;
            DateTime now = DateTime.now();
            String userdId = TravelDestination.getCurrentUserId();

            //adding to firebase
            CollectionReference trips =
                FirebaseFirestore.instance.collection('trips');
            trips.add({
              'tripName': tripName,
              'date': now,
              'status': 0,
              'userId': userdId,
              'image':
                  'https://cf.bstatic.com/xdata/images/hotel/square600/76655679.jpg?k=119a180340fa23c00d859e95fa02046eb17980bccb43295fe6550a5ea968daad&o=',
              'places': []
            });
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
