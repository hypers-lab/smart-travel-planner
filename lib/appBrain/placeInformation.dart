import 'dart:typed_data';

import 'package:smart_travel_planner/appBrain/TravelDestination.dart';

class PlaceInformation {
  final TravelDestination travelDestination;
  final Uint8List image;

  PlaceInformation(this.travelDestination, this.image);
}
