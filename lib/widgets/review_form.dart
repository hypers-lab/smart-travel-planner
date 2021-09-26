import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewForm extends StatelessWidget {
  const ReviewForm({
    Key? key,
    required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    List<double> reviewScores = [
      1,
      1.5,
      2,
      2.5,
      3,
      3.5,
      4,
      4.5,
      5,
      5.5,
      6,
      6.5,
      7,
      7.5,
      8,
      8.5,
      9,
      9.5,
      10
    ];

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  size: 35.0,
                  color: Colors.blueGrey,
                ),
                SizedBox(width: 60.0),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(color: Colors.blueGrey, width: 1),
                    bottom: BorderSide(color: Colors.blueGrey, width: 1),
                  )),
                  width: 80,
                  height: 100,
                  child: ListWheelScrollView.useDelegate(
                    childDelegate: ListWheelChildBuilderDelegate(
                        childCount: reviewScores.length,
                        builder: (BuildContext context, int index) {
                          if (index < 0 || index > reviewScores.length) {
                            return null;
                          }
                          return Text(reviewScores[index].toString());
                        }),
                    useMagnifier: true,
                    magnification: 1.5,
                    diameterRatio: 5,
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      // setState(() {
                      //   // selected = index;
                      // });
                    },
                    physics: FixedExtentScrollPhysics(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                focusColor: Colors.blueGrey,
                icon: Icon(Icons.comment),
                labelText: 'Comments',
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
