
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/route_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
      useImmersiveMode: true,
      gifPath: 'assets/gif/splash_screen.gif',
      gifWidth: 270,
      gifHeight: 475,
      backgroundColor: Colors.white,
      // duration: Duration(seconds: 3),
      // onEnd: (){
      //   Get.offAll(() => const RouteView());
      // },
      asyncNavigationCallback: () async {
        await Future.delayed(const Duration(seconds: 3)).then((value){
          if(context.mounted){
            Get.offAll(() => const RouteView());
          }
        });
      },
    );
  }
}