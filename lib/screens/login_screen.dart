import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_for_designers/constants.dart';
import 'package:flutter_for_designers/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> createNewUserData() async {
    _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      'name': 'User',
      'uid': _auth.currentUser!.uid,
      'bio': 'Design+Code student',
      'completed': [],
      'recents': [],
      'badges': [],
      'certificates': [],
      'profilePic': ''
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kSidebarBackgroundColor,
        child: ListView(children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    transform: Matrix4.translationValues(0, -75, 0),
                    child: Image.asset(
                      'assets/illustrations/illustration-14.png',
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(0, -170, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Learn to design\nand code apps',
                          style: kLargeTitleStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          'Complete courses about the best\ntools and design systems',
                          style: kHeadlineLabelStyle.copyWith(
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                transform: Matrix4.translationValues(0, -150, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 52,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Log in to',
                        style: kTitle1Style,
                      ),
                      Text(
                        'Start learning',
                        style: kTitle1Style.apply(
                          color: const Color(0xFF5B4CF0),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        // height: 140,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: kShadowColor,
                                    offset: Offset(0, 12),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 6,
                                      right: 16,
                                      left: 16,
                                    ),
                                    child: TextField(
                                      cursorColor: kPrimaryLabelColor,
                                      decoration: InputDecoration(
                                        icon: const Icon(
                                          Icons.email,
                                          color: Color(0xFF5488F1),
                                          size: 20,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Email Adress',
                                        hintStyle: kLoginInputTextStyle,
                                      ),
                                      style: kLoginInputTextStyle.copyWith(
                                          color: Colors.black),
                                      onChanged: (textEntered) {
                                        email = textEntered;
                                      },
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 6,
                                      right: 16,
                                      left: 16,
                                    ),
                                    child: TextField(
                                      cursorColor: kPrimaryLabelColor,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        icon: const Icon(
                                          Icons.lock,
                                          color: Color(0xFF5488F1),
                                          size: 20,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Password',
                                        hintStyle: kLoginInputTextStyle,
                                      ),
                                      style: kLoginInputTextStyle.copyWith(
                                          color: Colors.black),
                                      onChanged: (textEntered) {
                                        password = textEntered;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    try {
                                      await _auth.signInWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(),
                                            fullscreenDialog: false),
                                      );
                                    } on FirebaseAuthException catch (err) {
                                      if (err.code == 'user-not-found') {
                                        try {
                                          await _auth
                                              .createUserWithEmailAndPassword(
                                            email: email,
                                            password: password,
                                          )
                                              .then(
                                            (user) {
                                              user.user!
                                                  .sendEmailVerification();
                                              createNewUserData();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeScreen(),
                                                    fullscreenDialog: false),
                                              );
                                            },
                                          );
                                        } catch (err) {}
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Error'),
                                              content: Text(err.message!),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Okay'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF73A0F4),
                                          Color(0xFF4A47F5),
                                        ],
                                      ),
                                    ),
                                    height: 48,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      'Login',
                                      style: kCalloutLabelStyle.copyWith(
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                _auth
                                    .sendPasswordResetEmail(email: email)
                                    .then((value) => {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Email sent!'),
                                                content: const Text(
                                                    'The password reset email has been sent!'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Ok'),
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        });
                              },
                              child: Container(
                                child: Text(
                                  'Forget Password?',
                                  style: kCalloutLabelStyle.copyWith(
                                    color: const Color(0x721B1E9C),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
