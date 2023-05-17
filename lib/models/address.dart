import 'package:firebase_auth/firebase_auth.dart';

class Address {
  String? uid;
  String title;
  String description;
  double latitude;
  double longitude;

  Address({
    required this.title,
    this.uid,
    required this.description,
    required this.latitude,
    required this.longitude
  });

  factory Address.fromJson(dynamic data,String? id){
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
      "longitude":longitude,
      "userId":FirebaseAuth.instance.currentUser?.uid??""
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}