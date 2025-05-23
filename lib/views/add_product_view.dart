import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controllers/grocery_controller.dart';
import 'package:grocery_app/utils/back_page.dart';

class AddHomeProduct extends StatefulWidget {
  const AddHomeProduct({super.key});

  @override
  State<AddHomeProduct> createState() => _AddHomeProductState();
}

class _AddHomeProductState extends State<AddHomeProduct> {
  GroceryController groceryController = Get.put(GroceryController());

  final List<Map<String, dynamic>> groceryItems = [
    // ===== Dairy & Alternatives =====
    {'item': 'Soy Milk', 'status': false},
    {'item': 'Almond Milk', 'status': false},
    {'item': 'Cow Milk', 'status': false},
    {'item': 'Greek Yogurt', 'status': false},
    {'item': 'Cheddar Cheese', 'status': false},
    {'item': 'Mozzarella Cheese', 'status': false},
    {'item': 'Butter', 'status': false},
    {'item': 'Margarine', 'status': false},
    {'item': 'Cottage Cheese', 'status': false},
    {'item': 'Whipping Cream', 'status': false},
    {'item': 'Eggs', 'status': false},
    {'item': 'Egg Whites', 'status': false},

    // ===== Bakery =====
    {'item': 'Multigrain Bread', 'status': false},
    {'item': 'White Bread', 'status': false},
    {'item': 'Whole Wheat Bread', 'status': false},
    {'item': 'Baguette', 'status': false},
    {'item': 'Croissants', 'status': false},
    {'item': 'Bagels', 'status': false},
    {'item': 'Tortillas', 'status': false},
    {'item': 'English Muffins', 'status': false},
    {'item': 'Pita Bread', 'status': false},

    // ===== Produce (Fruits & Vegetables) =====
    {'item': 'Apples', 'status': false},
    {'item': 'Bananas', 'status': false},
    {'item': 'Oranges', 'status': false},
    {'item': 'Strawberries', 'status': false},
    {'item': 'Blueberries', 'status': false},
    {'item': 'Grapes', 'status': false},
    {'item': 'Avocado', 'status': false},
    {'item': 'Tomatoes', 'status': false},
    {'item': 'Cucumber', 'status': false},
    {'item': 'Carrots', 'status': false},
    {'item': 'Bell Peppers', 'status': false},
    {'item': 'Spinach', 'status': false},
    {'item': 'Lettuce', 'status': false},
    {'item': 'Broccoli', 'status': false},
    {'item': 'Cauliflower', 'status': false},
    {'item': 'Potatoes', 'status': false},
    {'item': 'Sweet Potatoes', 'status': false},
    {'item': 'Onions', 'status': false},
    {'item': 'Garlic', 'status': false},
    {'item': 'Ginger', 'status': false},
    {'item': 'Lemons', 'status': false},
    {'item': 'Limes', 'status': false},

    // ===== Meat & Seafood =====
    {'item': 'Chicken Breast', 'status': false},
    {'item': 'Chicken Thighs', 'status': false},
    {'item': 'Ground Beef', 'status': false},
    {'item': 'Pork Chops', 'status': false},
    {'item': 'Bacon', 'status': false},
    {'item': 'Turkey', 'status': false},
    {'item': 'Salmon', 'status': false},
    {'item': 'Shrimp', 'status': false},
    {'item': 'Tilapia', 'status': false},
    {'item': 'Canned Tuna', 'status': false},
    {'item': 'Sausages', 'status': false},
    {'item': 'Deli Ham', 'status': false},

    // ===== Pantry Staples =====
    {'item': 'Rice', 'status': false},
    {'item': 'Pasta', 'status': false},
    {'item': 'Quinoa', 'status': false},
    {'item': 'Oatmeal', 'status': false},
    {'item': 'Lentils', 'status': false},
    {'item': 'Black Beans', 'status': false},
    {'item': 'Chickpeas', 'status': false},
    {'item': 'Tomato Sauce', 'status': false},
    {'item': 'Olive Oil', 'status': false},
    {'item': 'Vegetable Oil', 'status': false},
    {'item': 'Flour', 'status': false},
    {'item': 'Sugar', 'status': false},
    {'item': 'Salt', 'status': false},
    {'item': 'Black Pepper', 'status': false},
    {'item': 'Cinnamon', 'status': false},
    {'item': 'Honey', 'status': false},
    {'item': 'Peanut Butter', 'status': false},
    {'item': 'Jam', 'status': false},
    {'item': 'Coffee', 'status': false},
    {'item': 'Tea Bags', 'status': false},
    {'item': 'Canned Soup', 'status': false},

    // ===== Snacks & Beverages =====
    {'item': 'Granola Bars', 'status': false},
    {'item': 'Chips', 'status': false},
    {'item': 'Popcorn', 'status': false},
    {'item': 'Dark Chocolate', 'status': false},
    {'item': 'Cookies', 'status': false},
    {'item': 'Crackers', 'status': false},
    {'item': 'Nuts', 'status': false},
    {'item': 'Trail Mix', 'status': false},
    {'item': 'Soda', 'status': false},
    {'item': 'Sparkling Water', 'status': false},
    {'item': 'Juice', 'status': false},
    {'item': 'Sports Drink', 'status': false},
    {'item': 'Ice Cream', 'status': false},
  ];

  String searchQuery = '';

  void toggleItemStatus(int index) {
    setState(() {
      // swap the status
      groceryItems[index]['status'] = !groceryItems[index]['status'];
      groceryItems.sort((a, b) {
        if (a['status'] && !b['status']) {
          return -1;
        } else if (!a['status'] && b['status']) {
          return 1;
        } else {
          return 0;
        }
      });
    });
  }

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
                
                const SizedBox(height: 10),
                
                Text('Add Products', style: Theme.of(context).textTheme.headlineLarge),
                Text('To Your Grocery List', style: Theme.of(context).textTheme.titleMedium),
                
                const SizedBox(height: 20),
                
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: 'SEARCH PRODUCT',
                      hintStyle: const TextStyle(color: Colors.white),
                      contentPadding:
                          const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                      ),
                      fillColor: Colors.green.shade400,
                      filled: true,
                      suffixIcon: const Icon(Icons.search, color: Colors.white)),
                ),
                
                const SizedBox(height: 10),
                
                Center(child: Text('Your Favorites'.toUpperCase(), style: Theme.of(context).textTheme.titleSmall)),
                
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: groceryItems.length,
                      itemBuilder: (context, index) {
                        final item = groceryItems[index];

                        if (searchQuery.isEmpty || item['item'].toLowerCase().contains(searchQuery.toLowerCase())) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 100.0,
                              child: FadeInAnimation(
                                child: buildCheckableListItem(item, index),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }

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

  Widget buildCheckableListItem(Map<String, dynamic> item, int index) {
    final isChecked = item['status'];
    return GestureDetector(
      onTap: () {

        if(item['status'] == false) {
          toggleItemStatus(index);

          print(item['item']!);
          print(item['status']!);

          // add items
          groceryController.addItem(itemName: item['item']!, itemStatus: item['status']!);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item ${item['item']!} added'), duration: Duration(milliseconds: 300)));
        }else{
          toggleItemStatus(index);
        }

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                child: Text(item['item']!,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis),
              ),
              const Spacer(),
              Flexible(
                child: isChecked
                    ? const Icon(Icons.check, color: Colors.green)
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}