import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controllers/grocery_controller.dart';
import 'package:grocery_app/models/app_user.dart';
import 'package:grocery_app/route_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GroceryController groceryController = Get.put(GroceryController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int uniqueId = 0;

  Future<void> uploadToCloudinary(ImageSource source) async {
    try{
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      final cloudName = 'dbaszvjvp';
      final uploadPreset = 'flutter_unsigned';

      final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      final resStr = await response.stream.bytesToString();
      final resJson = jsonDecode(resStr);

      if (response.statusCode == 200) {
        groceryController.imageUrl.value = resJson['secure_url'];
        print('cloudinary url: ${groceryController.imageUrl.value}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('failed to get image')));
      }
    }catch(exception){

      if(exception is SocketException){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('check internet connectivity')));
      } else if(exception is TimeoutException){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('connection time out')));
      } else if(exception is http.ClientException){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('upload later in the app')));
      } else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('something went wrong')));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          //
          Obx(() => Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                    Center(child: Text('Welcome!', style: Theme.of(context).textTheme.headlineLarge)),
                    Center(child: Text('To Grocery', style: Theme.of(context).textTheme.titleMedium)),
                
                    const SizedBox(height: 20),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black54,
                                  spreadRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Obx(
                                        () => ClipOval(
                                      child: groceryController.imageUrl.value ==
                                          ""
                                          ? Image.asset(
                                        'assets/images/profile.png',
                                        fit: BoxFit.cover,
                                      )
                                          : Image.network(
                                        groceryController.imageUrl.value,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 120,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                topLeft: Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 60,
                                                        width: 60,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            uploadToCloudinary(ImageSource.gallery);
                                                            Get.back();
                                                          },
                                                          icon: Image.asset(
                                                            'assets/images/gallery.png',
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      const Expanded(
                                                        child: Text(
                                                          'Gallery',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 60,
                                                        width: 60,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            uploadToCloudinary(ImageSource.camera);
                                                            Get.back();
                                                          },
                                                          icon: Image.asset(
                                                            'assets/images/camera.png',
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      const Expanded(
                                                        child: Text(
                                                          'Camera',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                      uniqueId = DateTime.now().millisecond;
                                      print(uniqueId);
                                    },
                                    icon: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20.0),
                                        color: Colors.amber,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                
                    const SizedBox(height: 20),
                
                    // name text
                    TextFormField(
                      controller: groceryController.nameController.value,
                      decoration: const InputDecoration(
                        hintText: 'Enter Name',
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter Name';
                        }
                        return null;
                      },
                    ),
                
                    const SizedBox(height: 20),
                
                    // as a member of group
                
                    Text('    Go as member'),
                
                    TextFormField(
                      controller: groceryController.referenceController.value,
                      decoration: const InputDecoration(
                        hintText: 'Enter Reference',
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                
                    const SizedBox(height: 20),
                
                    //
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                          if(groceryController.imageUrl.value.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("waiting for image")));
                          }else{

                            if (!_formKey.currentState!.validate()) return;

                            if(groceryController.referenceController.value.text.isEmpty){

                              print('Admin: ${groceryController.nameController.value.text}');

                              groceryController.addUser(
                                appUser: AppUser(
                                  name: groceryController.nameController.value.text.trim(),
                                  image: groceryController.imageUrl.value,
                                ),
                                id: uniqueId.toString(),
                              );
                              groceryController.rememberStatus(
                                name: groceryController.nameController.value.text.trim(),
                                adminId: uniqueId.toString(),
                              );

                              Get.offAll(() => RouteView());

                            }else{

                              print('Member (Reference: ${groceryController.referenceController.value.text})');

                              groceryController.addMember(
                                appUser: AppUser(
                                  name: groceryController.nameController.value.text.trim(),
                                  image: groceryController.imageUrl.value,
                                ),
                                adminId: groceryController.referenceController.value.text,
                              );
                              groceryController.rememberStatus(
                                name: groceryController.nameController.value.text.trim(),
                                adminId: uniqueId.toString(),
                              );

                              Get.offAll(() => RouteView());

                            }
                          }
                
                        },
                        child: Text("Continue"),
                      ),
                    ),
                
                  ],
                ),
              ),
            ),
          ),),
        ],
      ),
    );
  }
}
