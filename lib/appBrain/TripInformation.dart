import 'dart:typed_data';
import 'package:smart_travel_planner/appBrain/Trip.dart';

class TripInformation {
  final Trip trip;
  final Uint8List image;

  TripInformation(this.trip, this.image);
}
