import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListItem {
  int value;
  String name;
  ListItem(this.value, this.name);
}

class ReviewForm extends StatefulWidget {
  ReviewForm({Key? key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  late GlobalKey<FormState> reviewformKey = widget.formKey;

  int _value = 1;
  List<ListItem> _dropdownItems = [
    ListItem(1, "1"),
    ListItem(2, "1.5"),
    ListItem(3, "2"),
    ListItem(4, "2.5"),
    ListItem(5, "3"),
    ListItem(6, "3.5"),
    ListItem(7, "4"),
    ListItem(8, "4.5"),
    ListItem(9, "5"),
    ListItem(10, "5.5"),
    ListItem(11, "6"),
    ListItem(12, "6.5"),
    ListItem(13, "7"),
    ListItem(14, "7.5"),
    ListItem(15, "8"),
    ListItem(16, "8.5"),
    ListItem(17, "9"),
    ListItem(18, "9.5"),
    ListItem(19, "10")
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: reviewformKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  size: 28.0,
                  color: CupertinoColors.darkBackgroundGray,
                ),
                SizedBox(width: 20.0),
                DropdownButton(
                  value: _value,
                  items: _dropdownItems.map((ListItem item) {
                    return DropdownMenuItem<int>(
                      child: Text(item.name),
                      value: item.value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _value = value as int;
                    });
                  },
                  hint: Text("Select Rating"),
                  disabledHint: Text("Disabled"),
                  elevation: 8,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  icon: Icon(
                    Icons.arrow_drop_down_sharp,
                    size: 40.0,
                  ),
                  iconDisabledColor: Colors.red,
                  iconEnabledColor: Colors.blueGrey,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.comment),
                labelText: 'Comments',
                fillColor: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            // ignore: deprecated_member_use
            child: RaisedButton(
              child: Text("Add Review"),
              onPressed: () {
                //save to database under this user
                //need a function: addReview(String msg, Double rating, int placeId)
              },
            ),
          )
        ],
      ),
    );
  }
}
