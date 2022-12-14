import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_for_designers/components/lists/certificate_viewer.dart';
import 'package:flutter_for_designers/components/lists/completed_courses_list.dart';
import 'package:flutter_for_designers/constants.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var badges = [];

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;

  var name = 'Loading...';
  var bio = 'Loading...';
  String? photoURL = FirebaseAuth.instance.currentUser!.photoURL;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _auth.currentUser!.reload();
    loadUserData();
    loadBadges();
  }

  Future getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);

      _storage
          .ref('profile_pictures/${_auth.currentUser!.uid}.jpeg')
          .putFile(image)
          .then((snapshot) {
        snapshot.ref.getDownloadURL().then((url) {
          _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .update({'profilePic': url}).then((snapshot) {
            _auth.currentUser!.updatePhotoURL(url);
          });
        });
      });
    } else {}
  }

  void loadUserData() {
    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      setState(() {
        name = snapshot.data()!['name'];
        bio = snapshot.data()!['bio'];
      });
    });
  }

  void updateUserData() {
    _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'name': name,
      'bio': bio,
    }).then((value) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success!'),
            content: const Text('The profile data has been updated'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop,
                child: const Text('Okay'),
              ),
            ],
          );
        },
      ).catchError((err) {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Uh-oh!'),
              content: Text(err),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop,
                  child: const Text('Try again'),
                ),
              ],
            );
          },
        );
      });
    });
  }

  void loadBadges() {
    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      for (var badge in snapshot.data()!['badges']) {
        _storage.ref('badges/$badge').getDownloadURL().then((url) {
          setState(() {
            badges.add(url);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: kCardPopupBackgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: kShadowColor,
                    offset: Offset(0, 12),
                    blurRadius: 32,
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        bottom: 32,
                        left: 20,
                        right: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              maxWidth: 40,
                              maxHeight: 24,
                            ),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.arrow_back,
                                  color: kSecondaryLabelColor,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Profile',
                            style: kCalloutLabelStyle,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Update your profile'),
                                    content: Column(
                                      children: [
                                        TextField(
                                          cursorColor: kPrimaryLabelColor,
                                          decoration: InputDecoration(
                                            icon: const Icon(
                                              Icons.person,
                                              color: Color(0xFF5488F1),
                                              size: 20,
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'Name',
                                            hintStyle: kLoginInputTextStyle,
                                          ),
                                          style: kLoginInputTextStyle.copyWith(
                                              color: Colors.black),
                                          onChanged: (newValue) {
                                            setState(
                                              () {
                                                name = newValue;
                                              },
                                            );
                                          },
                                          controller: TextEditingController(
                                            text: name,
                                          ),
                                        ),
                                        TextField(
                                          cursorColor: kPrimaryLabelColor,
                                          decoration: InputDecoration(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Color(0xFF5488F1),
                                              size: 20,
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'Bio',
                                            hintStyle: kLoginInputTextStyle,
                                          ),
                                          style: kLoginInputTextStyle.copyWith(
                                              color: Colors.black),
                                          onChanged: (newValue) {
                                            setState(
                                              () {
                                                bio = newValue;
                                              },
                                            );
                                          },
                                          controller: TextEditingController(
                                            text: bio,
                                          ),
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop;
                                          updateUserData();
                                        },
                                        child: const Text('Okay'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: kShadowColor,
                                        offset: Offset(0, 12),
                                        blurRadius: 32),
                                  ]),
                              child: Icon(
                                Platform.isAndroid
                                    ? Icons.edit
                                    : CupertinoIcons.pencil,
                                color: kSecondaryLabelColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 84,
                            width: 84,
                            decoration: BoxDecoration(
                              gradient: const RadialGradient(
                                colors: [
                                  Color(0xFF00AEFF),
                                  Color(0XFF0076FF),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(42),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: GestureDetector(
                                onTap: () {
                                  getImage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: kBackgroundColor,
                                    borderRadius: BorderRadius.circular(42),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xFFE7EEFB),
                                    radius: 30,
                                    child: (photoURL != null)
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Image.network(
                                              photoURL!,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(Icons.person),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: kTitle2Style,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                bio,
                                style: kSecondaryCalloutLabelStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 28,
                        bottom: 16,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Badges',
                                  style: kHeadlineLabelStyle,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'See all',
                                      style: kSearchPlaceholderStyle,
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: kSecondaryLabelColor,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 112,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: index != 3 ? 0 : 20),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: kShadowColor.withOpacity(0.1),
                                        offset: const Offset(0, 12),
                                        blurRadius: 18,
                                      ),
                                    ],
                                  ),
                                  child: Image.network('${badges[index]}'),
                                );
                              },
                              padding: const EdgeInsets.only(
                                bottom: 28,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: badges.length,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 32, left: 20, right: 20, bottom: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Certificates',
                        style: kHeadlineLabelStyle,
                      ),
                      Row(
                        children: [
                          Text(
                            'See all',
                            style: kSearchPlaceholderStyle,
                          ),
                          const Icon(Icons.chevron_right,
                              color: kSecondaryLabelColor),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            const CertificateViewer(),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 12,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Completed courses',
                        style: kHeadlineLabelStyle,
                      ),
                      Row(
                        children: [
                          Text(
                            'See all',
                            style: kSearchPlaceholderStyle,
                          ),
                          const Icon(Icons.chevron_right,
                              color: kSecondaryLabelColor),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            const CompletedCoursesList(),
            const SizedBox(
              height: 28,
            ),
          ],
        ),
      ),
    );
  }
}
