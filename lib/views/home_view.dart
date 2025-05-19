import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:grocery_app/models/grocery_item.dart';
import 'package:grocery_app/utils/back_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final List<GroceryItem> _groceryItems = [
    GroceryItem(name: 'Salmon', addedBy: 'arslan'),
    GroceryItem(name: 'Greek Yogurt', addedBy: 'shahzad'),
    GroceryItem(name: 'Bell Peppers', addedBy: 'saif'),
    GroceryItem(name: 'Quinoa', addedBy: 'arslan'),
    GroceryItem(name: 'Dark Chocolate', addedBy: 'shahzad'),
    GroceryItem(name: 'Pita Bread', addedBy: 'saif'),
    GroceryItem(name: 'Canned Tuna', addedBy: 'arslan'),
    GroceryItem(name: 'Spinach', addedBy: 'shahzad'),
    GroceryItem(name: 'Granola Bars', addedBy: 'saif'),
    GroceryItem(name: 'Olive Oil', addedBy: 'arslan'),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        BackPage(),

        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text('Hi Arslan !', style: Theme.of(context).textTheme.headlineLarge),
                Text('Your Grocery List', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 20),

                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: _groceryItems.length,
                      itemBuilder: (context, index) {
                        final item = _groceryItems[index];

                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 100.0,
                            child: FadeInAnimation(
                              child: Dismissible(
                                key: Key(item.name),
                                direction: DismissDirection.horizontal,
                                onDismissed: (direction) {
                                  setState(() => _groceryItems.removeAt(index));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${item.name} removed'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          setState(() {
                                            _groceryItems.insert(index, item);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                                background: buildSwipeBackground(Icons.check, Colors.green, isEnd: false),
                                secondaryBackground: buildSwipeBackground(Icons.close, Colors.red, isEnd: true),

                                confirmDismiss: (direction) async {
                                  if (direction == DismissDirection.endToStart) {
                                    return await AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      headerAnimationLoop: false,
                                      animType: AnimType.leftSlide,
                                      title: 'Confirm Deletion',
                                      desc: 'Are you sure you want to remove this item?',
                                      buttonsTextStyle: const TextStyle(color: Colors.black),
                                      showCloseIcon: false,
                                      btnCancelOnPress: () {
                                        Get.back();
                                      },
                                      btnOkOnPress: () {
                                        Get.back();
                                      },
                                    ).show();
                                  }
                                  return true;
                                },
                                child: buildListItem(item),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
            Flexible(
              child: Text(item.name,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis),
            ),
            Flexible(
              child: Text('added by ${item.addedBy}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700])),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwipeBackground(IconData icon, Color color,
      {bool isEnd = false}) {
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