import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grocery_item.dart';

class GroceryController extends GetxController {
  var listId = ''.obs;
  var items = <GroceryItem>[].obs;
  var userName = ''.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void initList(String id) {
    listId.value = id;
    firestore.collection('lists').doc(id).snapshots().listen((doc) {
      if (doc.exists && doc.data() != null) {
        final list = List<Map<String, dynamic>>.from(doc['items'] ?? []);
        items.value = list.map((e) => GroceryItem.fromJson(e)).toList();
      }
    });
  }

  void createNewList(String user) {
    listId.value = DateTime.now().millisecondsSinceEpoch.toString();
    userName.value = user;
    firestore.collection('lists').doc(listId.value).set({'items': []});
  }

  void addItem(String itemName) {
    final newItem = GroceryItem(name: itemName, addedBy: userName.value);
    items.add(newItem);
    _updateFirestore();
  }

  void toggleItem(int index) {
    items[index] = GroceryItem(
      name: items[index].name,
      addedBy: items[index].addedBy,
      isDone: !items[index].isDone,
    );
    _updateFirestore();
  }

  void _updateFirestore() {
    firestore.collection('lists').doc(listId.value).update({
      'items': items.map((e) => e.toJson()).toList(),
    });
  }
}
