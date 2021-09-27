
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:smart_travel_planner/widgets/button.dart';
import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Preference extends StatefulWidget {
  @override
  _PreferenceState createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {

  void initState() {
    super.initState();
    //getData();
    //getUserDetails();  
  }

  List? _myActivities1;
  List? _myActivities2;
  List? _myActivities3;
  List? _myActivities4;

  List list =["Monday",'Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
 
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  
  CollectionReference _collectionplaces =
    FirebaseFirestore.instance.collection('places');
  CollectionReference _collectionTimes =
    FirebaseFirestore.instance.collection('prefered_times');
  CollectionReference _collectionDays =
    FirebaseFirestore.instance.collection('prefered_days');
  CollectionReference _collectionAraes =
    FirebaseFirestore.instance.collection('prefered_areas');

  // Future<void> getData() async {

  //   QuerySnapshot querySnapshotPlaces = await _collectionplaces.get();
  //   final places = querySnapshotPlaces.docs.map((doc) => doc.get('place_name'));
  //   print(places.toList());

  //   QuerySnapshot querySnapshotDays= await _collectionDays.get();
  //   final days = querySnapshotDays.docs.map((doc) => doc.get('day'));
  //   //print(days.toList());
  //   // listDays=days.toList();
  //   // print(listDays);

  //   QuerySnapshot querySnapshotAreas= await _collectionAraes.get();
  //   final areas = querySnapshotAreas.docs.map((doc) => doc.get('area'));
  //   print(areas.toList());

  //   final QuerySnapshot result = await _collectionTimes.get();
  //   final times =result.docs.map((doc) => doc.id);
  //   print(times.toList());
  // }  

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add You Preferences....'),
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/edit2.jpg'),
              fit: BoxFit.fill)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: preferenceItemAreas(),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: preferenceItemTimes() ,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: preferenceItemDays(),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: preferenceItemPlaces(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                      child: Row(
                        children: [
                          button(
                              text: 'Cancel',
                              color: Colors.red.shade900,
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => ProfilePage()));
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          button(
                            text: 'Save',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('YOUR PREFERENCES ARE SAVED'),)) ;
                              _sendToServer();
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => ProfilePage()));
                              },
                              color: Colors.teal.shade900),
                        ],
                      )
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//=======>For Prefered Areas<==========================
  FormBuilderCheckboxGroup preferenceItemAreas(
    
  ) {
    return FormBuilderCheckboxGroup(
      name: 'Areas',
      orientation: OptionsOrientation.vertical,
      options: [
        FormBuilderFieldOption(value: "Beach"),
        FormBuilderFieldOption(value: "Mountains"),
        FormBuilderFieldOption(value: "Forests"),
        FormBuilderFieldOption(value: "Waterfalls"),
        FormBuilderFieldOption(value: "Towns and city"),
        FormBuilderFieldOption(value: "Areas known for culture and heritage")
      ],
      initialValue: _myActivities3 ,
      onSaved: (value) {
        
        setState(() {
           _myActivities3 = value;
        });
      },
      onChanged:(value){} ,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: "Prefered Areas",
        filled: true,
        fillColor: Colors.green[100]
      ),
    );
  }

  //=======>For Prefered Times<======================
  FormBuilderCheckboxGroup preferenceItemTimes() {
    return FormBuilderCheckboxGroup(
      orientation: OptionsOrientation.vertical,
      name: 'Time',
      options: [
        FormBuilderFieldOption(value: "Morning"),
        FormBuilderFieldOption(value: "Afternoon"),
        FormBuilderFieldOption(value: "Evening"),
        FormBuilderFieldOption(value: "Night"),
      ],
      initialValue:  _myActivities4,
      onSaved: (value) {
        //optionPlaces.clear();
        setState(() {
           _myActivities4 = value;
        });
      },
      onChanged: (value){},
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: "Prefered Time",
        filled: true,
        fillColor: Colors.green[100],
      ),
    );
  }
//===========>Field for selecting prefered days<===================
FormBuilderCheckboxGroup preferenceItemDays() {
    return FormBuilderCheckboxGroup(
      orientation: OptionsOrientation.vertical,
      name: 'Time',
      options: list.map((e) => FormBuilderFieldOption(value: e)).toList(),
      initialValue:  _myActivities1,
      onSaved: (value) {
        //optionPlaces.clear();
        setState(() {
           _myActivities1 = value;
        });
      },
      onChanged: (value){},
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: "Prefered Days",
        filled: true,
        fillColor: Colors.green[100],
      ),
    );
  }

  //=======>For Prefered Places<===========
  GFMultiSelect preferenceItemPlaces(){
    return GFMultiSelect(
      //selected:true ,
      items: list,
      onSelect: (value) {
        print('Selected $value');
        setState(() {
          _myActivities2 = value;
        });
      },
      dropdownTitleTileText: 'Select your prefered places',
      dropdownTitleTileColor: Colors.green[100],
      dropdownTitleTileMargin: EdgeInsets.all(0),
      dropdownTitleTilePadding: EdgeInsets.all(10),
      dropdownUnderlineBorder:
          const BorderSide(
            color: Colors.transparent, 
            width: 2
          ),
      dropdownTitleTileBorder:
          Border.all(
            color: Colors.grey.shade700, 
            width: 1
          ),
      dropdownTitleTileBorderRadius: BorderRadius.circular(10),
      expandedIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.black54,
      ),
      collapsedIcon: const Icon(
        Icons.keyboard_arrow_up,
        color: Colors.black54,
      ),
      submitButton: Text('OK',),
      dropdownTitleTileTextStyle:
          const TextStyle(
            fontSize: 14, 
            color: Colors.black54
          ),
      padding: const EdgeInsets.fromLTRB(18, 2, 20, 2),
      margin: const EdgeInsets.all(6),
      activeBgColor: Colors.green.shade100,
      inactiveBorderColor: Colors.green.shade100,
    );
  }

  // To send the preference values to user_preferences collection
  _sendToServer() async{
      _saveForm();
      var firebaseUser =  FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
        .collection('user_preferences')
        .doc(firebaseUser!.uid)
        .update({
          'prefered_areas':_myActivities3,
          'prefered_times':_myActivities4,
          'prefered_days':_myActivities1,
          'places':_myActivities2
        });
  }
  //save the values
  _saveForm() {
     _formkey.currentState!.save();
  } 
}