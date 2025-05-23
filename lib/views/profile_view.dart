import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:grocery_app/controllers/grocery_controller.dart';
import 'package:grocery_app/utils/back_page.dart';
import 'package:grocery_app/views/login_view.dart';
import 'package:share_plus/share_plus.dart';

class ProfileView extends StatefulWidget {
  ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  GroceryController groceryController = Get.put(GroceryController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        BackPage(),

        Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 10),

                  Text('Profiles', style: Theme.of(context).textTheme.headlineLarge),
                  Text('Allow People To Add To Your\nGrocery List', style: Theme.of(context).textTheme.titleMedium),

                  const SizedBox(height: 30),

                  groceryController.adminName.value.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          SizedBox(width: 6.0),

                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              groceryController.imageUrl.value,
                            ),
                            radius: 25,
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(groceryController.adminName.value.toLowerCase(), style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Text(
                            'Admin'
                          ),
                          SizedBox(width: 6.0),
                        ],
                      ),
                    ),
                  ) : SizedBox(child: Center(child: Text('No Admin Data')),),

                  groceryController.membersData.isEmpty
                      ? Center(
                    child: Text(
                      "No Member's",
                      style: TextStyle(fontSize: 24),
                    ),
                  )
                      : AnimationLimiter(
                    child: Column(
                      children: List.generate(
                        groceryController.membersData.length, (index) {
                          final user = groceryController.membersData[index];
                          print("User $user");
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 100.0,
                              child: FadeInAnimation(
                                child: _buildProfileTile(context, user.image, user.name, groceryController.adminType.value),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),


                  SizedBox(height: 20),

                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await SharePlus.instance.share(ShareParams(title: 'Grocery App', text: "Join my group with reference 'admin${groceryController.adminId.value}'"));
                      },
                      child: Text('Send Link to Invite'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileTile(BuildContext context,String image, String name, String userType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            SizedBox(width: 6.0),

            CircleAvatar(
              backgroundImage: NetworkImage(
                image,
            ),
                radius: 25,
              onBackgroundImageError: (exception, stackTrace) {
                groceryController.imageLoadingError.value = true;
              },
              child: groceryController.imageLoadingError.value
                  ? const Icon(Icons.person, size: 25)
                  : null,
            ),

            SizedBox(width: 14),

            Expanded(child: Text(name.toLowerCase(), style: Theme.of(context).textTheme.titleMedium)),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red,size: 34),
              onPressed: () {

                if(userType == '1'){

                  groceryController.deleteMember(name: name);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('member $name deleted')));
                  setState(() {});

                } else if(name == groceryController.nameController.value.text){

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have deleted your own account')));
                  groceryController.notRemember();
                  Get.offAll(() => LoginScreen());

                }else{

                  groceryController.deleteMember(name: name);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('member $name deleted')));
                  setState(() {});

                }

              },
            ),
            SizedBox(width: 6.0),
          ],
        ),
      ),
    );
  }
}
