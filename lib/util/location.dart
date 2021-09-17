class PlaceLocation {
  PlaceLocation(this.lat, this.long);

  final double lat;
  final double long;

  double getLatitude() {
    return this.lat;
  }

  double getLongitude() {
    return this.long;
  }
}
