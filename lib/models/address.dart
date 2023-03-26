class Address {
  String uid;
  String title;
  String description;
  double latitude;
  double longitude;

  Address({
    this.title,
    this.uid,
    this.description,
    this.latitude,
    this.longitude
  });

  factory Address.fromJson(Map<String,dynamic> data,String id){
    return Address(
      uid: id ?? data["id"],
      title: data["title"]??"",
      description: data["description"]??"",
      latitude: data["latitude"]??0.0,
      longitude: data["longitude"]??0.0
    );
  }


  Map<String,dynamic> toJson(){
    return {
      "id":uid,
      "title":title,
      "description":description,
      "latitude":latitude,
      "longitude":longitude
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}