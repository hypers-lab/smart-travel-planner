class PlaceLocation {
  PlaceLocation({required this.coordinates, required this.placeName});

  String coordinates;
  String placeName;

  List setLatnLong() {
    List<String> coo = this.coordinates.split(',');
    List<double> latNlong = [double.parse(coo[0]), double.parse(coo[1])];
    return latNlong;
  }
}
