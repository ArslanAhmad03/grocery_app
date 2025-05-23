
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String name;
  final String image;
  final String type;

  AppUser({required this.name, required this.image, required this.type});

  Map<String, dynamic> toJson() => {
    'user_name': name,
    'user_image': image,
    'user_type': type,
  };

  factory AppUser.fromJson(Map<String , dynamic>? json) => AppUser(
    name: json?['user_name'],
    image: json?['user_image'],
    type: json?['user_type'],
  );

  static List<AppUser> jsonToList(List<DocumentSnapshot> docs) {return docs.map((doc) => AppUser.fromJson(doc.data() as Map<String, dynamic>)).toList();}

}
