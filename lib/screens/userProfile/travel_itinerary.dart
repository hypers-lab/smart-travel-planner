import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_travel_planner/screens/MainScreen.dart';

class TravelItinerary extends StatefulWidget {
  const TravelItinerary({ Key? key }) : super(key: key);

  @override
  _TravelItineraryState createState() => _TravelItineraryState();
}

class _TravelItineraryState extends State<TravelItinerary> {

  late String area;
  var now = new DateTime.now();

  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(2021, 9),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedStartDate && picked.compareTo(now)>0)
      setState(() {
        selectedStartDate = picked;
      });
  }

  // _sendToServer() {
  //   if (_formkey.currentState!.validate() ){
  //     //No error in validator
  //     _formkey.currentState!.save();
  //     var firebaseUser =  FirebaseAuth.instance.currentUser;
  //     FirebaseFirestore.instance
  //       .collection('user_travel_itinerary')
  //       .doc(firebaseUser!.uid).update({
  //         'start_date':selectedStartDate,
  //         'end_date':selectedEndDate,
  //         'place':area
  //       });
  //   }
  // }
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        firstDate: DateTime(2021, 9),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedEndDate && picked.compareTo(now)>0 )
      setState(() {
        selectedEndDate = picked;
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 18,bottom: 18),
          child: Form(
            key: _formkey,
            child: AlertDialog(
              backgroundColor: Colors.purple[50],
              elevation:100 ,
              contentPadding: EdgeInsetsDirectional.all(40.0),
              title: Padding(
                padding: const EdgeInsets.only(top: 8,left: 20,right: 8),
                child: Text(
                  "Create Your Travel Itinerary Now?",
                  style: GoogleFonts.shadowsIntoLight(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                        letterSpacing: 2,
                        color: Colors.purple[900],
          
                      ),),
              ),
              content: Column(
                children: [
                  buildAreaField(),
                  SizedBox(height:20),
                  Container(
                    height: 110,
                    width: 300,
                    child: Card(
                      color: Colors.purple[100],
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              "${selectedStartDate.toLocal()}".split(' ')[0],
                              style: TextStyle(
                                fontWeight: FontWeight.w900 ),),
                          ),
                          SizedBox(height: 10.0,),
                          ButtonTheme(
                            minWidth: 400.0,
                            height: 200.0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                 backgroundColor: MaterialStateProperty.all<Color>(Colors.purple.shade800),
                              ),
                              onPressed: () => _selectStartDate(context),
                              child: Text('Select Start Date'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 110,
                    width: 350,
                    child: Card(
                      color: Colors.purple[100],
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              "${selectedEndDate.toLocal()}".split(' ')[0],
                              style: TextStyle(
                                fontWeight: FontWeight.w900 ),),
                          ),
                          SizedBox(height: 10.0,),
                          ButtonTheme(
                            minWidth: 400.0,
                            height: 200.0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                 backgroundColor: MaterialStateProperty.all<Color>(Colors.purple.shade800),
                              ),
                              onPressed: () => _selectEndDate(context),
                              child: Text('Select End Date'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                cancelButton(),
                continueButton(),
              ],
            ),
          ),
        ),
      )
    );
  }
  Widget cancelButton(){
    return TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 15,
          color: Colors.red[800]),),
      onPressed:  () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => MainScreen()));
      },
    );
  }
  Widget continueButton(){
    return TextButton(
      child: Text(
        "Continue",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 15,
          color: Colors.purple[900]),
      ),
      onPressed:  () {
        //_sendToServer();
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => MainScreen()));},
    );
  }
   
  FormBuilderDropdown buildAreaField() {
    return FormBuilderDropdown(
      name: "area",
      onSaved: (value){
        area = value!;
      },
      elevation: 30,
      validator: (value) => value == null ? 'Select your a place where you want to go' : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple.shade100),
          borderRadius: BorderRadius.circular(2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        filled: true,
        fillColor: Colors.purple[100],
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      hint: Text('Select Place'),
      items: ['Jaffna', 'Kandy', 'Nuwara Eliya']
          .map((area) => DropdownMenuItem(
                value: area,
                child: Text('$area'),
              ))
          .toList(),
    );
  }
} 


