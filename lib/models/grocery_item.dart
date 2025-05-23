import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryItem {
  final String name;
  final bool isDone;

  GroceryItem({required this.name, this.isDone = false});

  Map<String, dynamic> toJson() => {
    'item_name': name,
    'item_status': isDone,
  };

  factory GroceryItem.fromJson(Map<String, dynamic> json) => GroceryItem(
    name: json['item_name'] ?? '',
    isDone: json['item_status'] ?? false,
  );

  static List<GroceryItem> jsonToList(List<DocumentSnapshot> docs) {
    return docs.map((doc) => GroceryItem.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }
}
