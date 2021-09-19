import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:smart_travel_planner/util/const.dart';

class LocationService implements Exception {
  //Handling TimeoutException, PermissionDeniedException,LocationServiceDisabledException
  static Future<dynamic> getPosition(LocationConstant serviceName) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
      //return Future.error('Location services are disabled.');
    }

    //When Permissions are denied
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //return Future.error('Location permissions are denied');
        throw PermissionDeniedException('Permission denied');
      }
    }

    // When Permissions are denied forever
    if (permission == LocationPermission.deniedForever) {
      //return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      throw DeniedForeverException('Location access denied Forever');
    }

    // Now permissions are granted and continue accessing the position of the device.
    if (serviceName == LocationConstant.CurrentPosition) {
      try {
        return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 20));
      } catch (exception) {
        throw exception;
      }
    } else if (serviceName == LocationConstant.LastReadPosition) {
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (exception) {
        throw exception;
      }
    }
  }

  void getPositionStream() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Request users of the app to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position pos;
    try {
      Geolocator.getPositionStream().listen((Position position) {
        pos = position;
      });
    } catch (e) {}
  }

  static double getDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }
}

//LocationPermission permission = await Geolocator.checkPermission();
//LocationPermission permission = await Geolocator.requestPermission();

class DeniedForeverException implements Exception {
  String cause;
  DeniedForeverException(this.cause);
}
