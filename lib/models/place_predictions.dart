class PlacePredictions {
  String secondaryText;
  String mainText;
  String placeId;

  PlacePredictions({this.secondaryText, this.mainText, this.placeId});

  PlacePredictions.fromJson(Map<String, dynamic> json) {
    placeId = json["placeId"];
    mainText = json["mainText"];
    secondaryText = json["secondaryText"];
  }
}
