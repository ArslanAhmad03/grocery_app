import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controllers/grocery_controller.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/utils/back_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GroceryController groceryController = Get.put(GroceryController());

  @override
  void initState() {
    groceryController.getAdminData();
    groceryController.getItem();
    groceryController.getMemberData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackPage(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi !', style: Theme.of(context).textTheme.headlineLarge),
              Text('Your Grocery List',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(
                  () {
                    final items = groceryController.getSelectedItems;
                    if (items.isEmpty) {
                      return const Center(
                        child: Text(
                          "No items selected",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      );
                    }

                    return AnimationLimiter(
                      child: ListView.builder(
                        itemCount: groceryController.getSelectedItems.length,
                        itemBuilder: (context, index) {
                          final item = groceryController.getSelectedItems[index];

                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 100.0,
                              child: FadeInAnimation(
                                child: buildListItem(item),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildListItem(GroceryItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(2, 4),
              blurRadius: 4,
              spreadRadius: 0.5,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Spacer(),
            GestureDetector(
              onTap: () {
                groceryController.itemDeleted(item.name);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item ${item.name} deleted'), duration: const Duration(milliseconds: 300)));
              },
              child: const Icon(
                Icons.delete_forever,color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwipeBackground(IconData icon, Color color, {bool isEnd = false}) {
    return Container(
      alignment: isEnd ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(2, 4),
            blurRadius: 4,
            spreadRadius: 0.5,
          )
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
