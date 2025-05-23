import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controllers/grocery_controller.dart';
import 'package:grocery_app/views/home_view.dart';
import 'package:grocery_app/views/add_product_view.dart';
import 'package:grocery_app/views/profile_view.dart';

class RouteView extends StatefulWidget {
  const RouteView({super.key});

  @override
  State<RouteView> createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> {
  GroceryController groceryController = Get.put(GroceryController());

  final pageController = PageController(initialPage: 0);
  final NotchBottomBarController notchBottomBarController = NotchBottomBarController(index: 0);

  final List listScreens = [
    HomeView(),
    AddHomeProduct(),
    ProfileView(),
  ];

  @override
  void initState() {
    print('object');
    groceryController.getAdminData();
    groceryController.getMemberData();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(listScreens.length, (index) => listScreens[index]),
        ),

        bottomNavigationBar: AnimatedNotchBottomBar(

          notchBottomBarController: notchBottomBarController,
          onTap: (int value) {
            setState(() {
              pageController.jumpToPage(value);
            });
          },

          showLabel: false,
          notchColor: Colors.green.shade100,
          color: Colors.lightGreen.shade400,
          durationInMilliSeconds: 300,
          kIconSize: 24,
          kBottomRadius: 8.0,
          bottomBarWidth: MediaQuery.of(context).size.width,
          bottomBarItems: const [
            BottomBarItem(
              inActiveItem: Icon(
                Icons.home_filled,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.home_filled,
                color: Colors.lightGreen,
              ),
              // itemLabel: 'Home',
            ),
            BottomBarItem(
              inActiveItem: Icon(
                Icons.add,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.add,
                color: Colors.lightGreen,
              ),
              // itemLabel: 'Add',
            ),
            BottomBarItem(
              inActiveItem: Icon(
                Icons.person,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.person,
                color: Colors.lightGreen,
              ),
              // itemLabel: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
