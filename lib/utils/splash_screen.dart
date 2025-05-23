
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controllers/grocery_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GroceryController groceryController = Get.put(GroceryController());
  
  @override
  void initState() {

    groceryController.loginStatus();

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
      useImmersiveMode: true,
      gifPath: 'assets/gif/splash_screen.gif',
      gifWidth: 270,
      gifHeight: 475,
      backgroundColor: Colors.white,
    );
  }
}