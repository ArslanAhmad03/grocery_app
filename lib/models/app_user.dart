
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String name;
  final String image;

  AppUser({required this.name, required this.image});

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
  };

  factory AppUser.fromJson(Map<String , dynamic>? json) => AppUser(
    name: json?['name'],
    image: json?['image'],
  );

  static List<AppUser> jsonToList(List<DocumentSnapshot> docs) {return docs.map((doc) => AppUser.fromJson(doc.data() as Map<String, dynamic>)).toList();}

}
