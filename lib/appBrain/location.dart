class PlaceLocation {
  PlaceLocation(this.lat, this.long);

  double? lat;
  double? long;

  double? getLatitude() {
    return this.lat;
  }

  double? getLongitude() {
    return this.long;
  }
}
