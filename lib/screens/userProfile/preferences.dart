import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'profile.dart';

class Preference extends StatefulWidget {
  const Preference({Key? key}) : super(key: key);
  static const String id = 'preference';
  @override
  _PreferenceState createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add You Preferences....'),
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              buildPlaceTypeField(),
              SizedBox(
                height: 20,
              ),
              buildPreferedTimeField(),
              SizedBox(
                height: 20,
              ),
              buildPreferedItems(items: [
                'Jaffna',
                'Colombo',
                'Kilinochi',
                'Moratuwa',
                'Kandy',
                'Vavuniya',
                'Galle',
                'Trincomalea',
                'Batticaloa',
                'Anuradhapura',
                'Ratnapura',
                'Mannar',
                'Negombo'
              ], title: 'Select your prefered cities '),
              SizedBox(
                height: 20,
              ),
              buildPreferedItems(items: [
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday'
              ], title: 'Select your prefered days'),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                  child: Row(
                    children: [
                      button(
                          text: 'Cancel',
                          color: Colors.red.shade900,
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            Navigator.pushNamed(context, ProfilePage.id);
                          }),
                      SizedBox(
                        width: 10,
                      ),
                      button(
                          text: 'Save',
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            Navigator.pushNamed(context, ProfilePage.id);
                          },
                          color: Colors.teal.shade900),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  FormBuilderCheckboxGroup buildPlaceTypeField() {
    return FormBuilderCheckboxGroup(
      name: 'Places',
      options: [
        FormBuilderFieldOption(value: "Beach areas"),
        FormBuilderFieldOption(value: "Natural areas"),
        FormBuilderFieldOption(value: "Towns and cities"),
        FormBuilderFieldOption(value: "Winter spoot areas"),
        FormBuilderFieldOption(value: "Areas known for culture and heritage")
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelText: "Prefered Places",
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }

  FormBuilderCheckboxGroup buildPreferedTimeField() {
    return FormBuilderCheckboxGroup(
      name: 'Time',
      options: [
        FormBuilderFieldOption(value: "Morning"),
        FormBuilderFieldOption(value: "Afternoon"),
        FormBuilderFieldOption(value: "Evening"),
        FormBuilderFieldOption(value: "Night"),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelText: "Preferedtime",
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }

  GFMultiSelect buildPreferedItems({
    required List<String> items,
    required String title,
  }) {
    return GFMultiSelect(
      items: items,
      onSelect: (value) {
        print('selected $value ');
      },
      dropdownTitleTileText: title,
      dropdownTitleTileColor: Colors.grey.shade200,
      dropdownTitleTileMargin: EdgeInsets.all(0),
      dropdownTitleTilePadding: EdgeInsets.all(10),
      dropdownUnderlineBorder:
          const BorderSide(color: Colors.transparent, width: 2),
      dropdownTitleTileBorder:
          Border.all(color: Colors.grey.shade700, width: 1),
      dropdownTitleTileBorderRadius: BorderRadius.circular(15),
      expandedIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.black54,
      ),
      collapsedIcon: const Icon(
        Icons.keyboard_arrow_up,
        color: Colors.black54,
      ),
      submitButton: Text('OK'),
      dropdownTitleTileTextStyle:
          const TextStyle(fontSize: 14, color: Colors.black54),
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
      margin: const EdgeInsets.all(6),
      activeBgColor: Colors.grey.shade700,
      inactiveBorderColor: Colors.grey.shade200,
    );
  }

  Widget button({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) =>
      Container(
        height: 40,
        width: 100,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
          style: ElevatedButton.styleFrom(
            primary: color,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            onPrimary: Colors.white,
            shadowColor: Colors.blueGrey,
            elevation: 10,
          ),
        ),
      );
}
