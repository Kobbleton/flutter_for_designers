import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_for_designers/screens/profile_screen.dart';

import '../constants.dart';
import 'searchfield_widget.dart';
import 'sidebar_button.dart';

class HomeScreenNavBar extends StatelessWidget {
  HomeScreenNavBar({super.key, required this.triggerAnimation});

  void Function() triggerAnimation;
  final photoURL = FirebaseAuth.instance.currentUser!.photoURL;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SideBarButton(triggerAnimation: triggerAnimation),
          const SearchFieldWidget(),
          const Icon(
            Icons.notifications,
            color: kPrimaryLabelColor,
          ),
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: const Color(0xFFE7EEFB),
              radius: 30,
              child: (photoURL != null)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        photoURL!,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.person),
            ),
          )
        ],
      ),
    );
  }
}
