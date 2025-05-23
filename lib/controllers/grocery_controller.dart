import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/models/app_user.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/route_view.dart';
import 'package:grocery_app/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroceryController extends GetxController {

  RxString imageUrl = ''.obs;
  RxString adminName = ''.obs;
  RxString adminType = ''.obs;
  RxString adminId = ''.obs;
  RxBool imageLoadingError = false.obs;

  // text_field controller's
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> referenceController = TextEditingController().obs;

  // add Admin Data
  Future<void> addAdmin({required AppUser appUser, required String id}) async {
    await FirebaseFirestore.instance.collection('AppUsers').doc("admin$id").set({
      "user_name" : appUser.name,
      "user_image" : appUser.image,
      "user_type" : appUser.type,
    });
  }

  // get Admin Data
  getAdminData(){
    print('get admin:${(adminId.value)}');
    try{
      FirebaseFirestore.instance.collection('AppUsers').doc("admin${adminId.value}").snapshots().listen((doc){
        if (doc.exists) {
          adminName.value = doc['user_name'];
          imageUrl.value = doc['user_image'];
          adminType.value = doc['user_type'];
          print(doc['user_name']);
          print(doc['user_image']);
        }
      });
    }  catch (e){
      print(e.toString());
    }
  }

  // add Member Data
  Future<void> addMember({required AppUser appUser, required String adminId}) async {
    await FirebaseFirestore.instance.collection('AppUsers').doc("admin$adminId").collection('Members').add({
      "user_name" : appUser.name,
      "user_image" : appUser.image,
      "user_type" : appUser.type,
    });
  }
  // get Member Data
  RxList<AppUser> membersData = <AppUser>[].obs;
  void getMemberData() {
    FirebaseFirestore.instance.collection('AppUsers').doc("admin${adminId.value}").collection('Members').snapshots().listen((event) {
      membersData.value = AppUser.jsonToList(event.docs);
    });
  }

  // delete member
  void deleteMember({required String name}) async {
    final snapshot = await FirebaseFirestore.instance.collection('AppUsers').doc("admin${adminId.value}").collection('Members').where('user_name', isEqualTo: name).get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Add Items
  void addItem({required String itemName, required bool itemStatus}) {
    FirebaseFirestore.instance.collection('AppUsers').doc("admin${adminId.value}").collection('ItemsList').add({
      "item_name" : itemName,
      "item_status" : itemStatus,
    });
  }
  // get selected items
  RxList<GroceryItem> getSelectedItems = <GroceryItem>[].obs;
  void getItem(){
    FirebaseFirestore.instance.collection('AppUsers').doc("admin${adminId.value}").collection('ItemsList').snapshots().listen((event){
      getSelectedItems.value = GroceryItem.jsonToList(event.docs);

      print(getSelectedItems);
    });
  }
  // delete selected item
  void itemDeleted(String itemName) async {
    print('deleted');
    final snapshot = await FirebaseFirestore.instance.collection('AppUsers').doc("admin${adminId.value}").collection('ItemsList').where('item_name', isEqualTo: itemName).get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // store data locally
  RxBool isLoggedIn = false.obs;
  void rememberStatus({required String name, required String adminId}) async {
    final prefs = await SharedPreferences.getInstance();
    print(name + adminId);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', name);
    await prefs.setString('userId', adminId);
    isLoggedIn.value = true;
  }
  void loginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogIn = prefs.getBool('isLoggedIn') ?? false;
    isLoggedIn.value = isLogIn;

    if(isLoggedIn.value){
      nameController.value.text = prefs.getString('userName')!;
      adminId.value = prefs.getString('userId')!;

      print(nameController.value.text);
      print(adminId.value);
      Future.delayed(Duration(seconds: 4)).then((_){
        Get.offAll(() => RouteView());
      });
    }else{
      Future.delayed(Duration(seconds: 4)).then((_){
        Get.offAll(() => LoginScreen());
      });
    }
  }
  void notRemember() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userName');
    await prefs.remove('userId');
  }
}
