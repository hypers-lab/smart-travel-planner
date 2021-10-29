import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TripSelectPopUp extends StatefulWidget {
  const TripSelectPopUp({
    Key? key,
    required this.tripNameController,
    required this.menuItems,
    required this.placeId,
  }) : super(key: key);

  final tripNameController;
  final menuItems;
  final placeId;

  @override
  _TripSelectPopUpState createState() => _TripSelectPopUpState();
}

class _TripSelectPopUpState extends State<TripSelectPopUp> {
  late TextEditingController tripNameController = widget.tripNameController;
  late List<DropdownMenuItem<String>> menuItems = widget.menuItems;
  late String placeId = widget.placeId;
  late String selectedValue = 'null';

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
        items: menuItems,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection("trips")
                .doc(selectedValue)
                .get()
                .then(
              (snapshot) async {
                //print(placeId);
                //print(snapshot["places"]);
                List<dynamic> ids = snapshot["places"];
                if (ids.indexOf(placeId) >= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Place is already exists."),
                    ),
                  );
                } else {
                  ids.add(placeId);
                  //print(ids);
                  await FirebaseFirestore.instance
                      .collection("trips")
                      .doc(selectedValue)
                      .update(
                    {
                      "places": ids,
                    },
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Place is added successfully."),
                    ),
                  );
                }

                Navigator.pop(context);
              },
            );
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
