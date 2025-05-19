import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grocery_app/models/app_user.dart';
import 'package:grocery_app/utils/back_page.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});


  final List<AppUser> appUser = [
    AppUser(name: 'Arslan', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI_LqewXMXkyR_DpYJzygqLiAh6PE5ggekiw&s'),
    AppUser(name: 'Shahzad', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeGnFu9NwouiTpqCBF6jNgBoFxE1z795uEAQ&s'),
    AppUser(name: 'Saif', image: 'https://www.befunky.com/images/prismic/0d88c466-8c06-4ddc-8534-1047b109136d_features-background-remover4.png?auto=avif,webp&format=jpg&width=581'),
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

                SizedBox(height: 10),

                Text('Profiles', style: Theme.of(context).textTheme.headlineLarge),
                Text('Allow People To Add To Your\nGrocery List', style: Theme.of(context).textTheme.titleMedium),

                const SizedBox(height: 60),

                AnimationLimiter(
                  child: Column(
                    children: List.generate(appUser.length, (int index) {
                      final user = appUser[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 100.0,
                          child: FadeInAnimation(
                              child: _buildProfileTile(context, user.image, user.name),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle invite action
                    },
                    child: Text('Send Link to Invite'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25), // Rounded corners
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProfileTile(BuildContext context,String image, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
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
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text(name.toLowerCase(), style: Theme.of(context).textTheme.titleMedium),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red,size: 34),
              onPressed: () {
                // Handle remove profile action
              },
            ),
            SizedBox(width: 6.0),
          ],
        ),
      ),
    );
  }
}
