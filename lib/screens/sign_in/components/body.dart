import 'package:bike_car_service/components/mechanic_account_text.dart';
import 'package:bike_car_service/screens/complete_profile/complete_profile_screen.dart';
import 'package:bike_car_service/screens/home/home_screen.dart';
import 'package:bike_car_service/user_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/components/no_account_text.dart';
import 'package:bike_car_service/components/socal_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../size_config.dart';
import 'sign_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String location;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () {
                        signInWithGoogle().then((result) {
                          if (result != null) {
                            _checkUser(result.email, context);
                            //addEmail(result.email);
                          } else {
                            EasyLoading.dismiss();
                          }
                        },
                            onError: (e) => Fluttertoast.showToast(
                                msg: e.message != null
                                    ? e.message
                                    : "Something Went Wrong!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0));
                        EasyLoading.dismiss();
                      },
                    ),
                    SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {},
                    ),
                    SocalCard(
                      icon: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
                SizedBox(height: getProportionateScreenHeight(20)),
                MechanicAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<User> signInWithGoogle() async {
    //EasyLoading.show(status: 'loading...');
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    EasyLoading.show(status: 'loading...');
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    //EasyLoading.show(status: 'loading...');
    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      print('signInWithGoogle succeeded: $user');

      return user;
    }

    return null;
  }

  // deviceToken() {
  //   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //   _firebaseMessaging.configure(
  //     onLaunch: (Map<String, dynamic> message) {
  //       print('onLaunch called');
  //       return null;
  //     },
  //     onResume: (Map<String, dynamic> message) {
  //       print('onResume called');
  //       return null;
  //     },
  //     onMessage: (Map<String, dynamic> message) {
  //       print('onMessage called');
  //       return null;
  //     },
  //   );
  //   _firebaseMessaging.subscribeToTopic('all');
  //   _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
  //     sound: true,
  //     badge: true,
  //     alert: true,
  //   ));
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     print('Hello');
  //   });
  //   _firebaseMessaging.getToken().then((token) {
  //     print(token); // Print the Token in Console
  //     finalToken = DeviceToken(finalToken: token);
  //   });
  // }

  _checkUser(var email, var context) {
    EasyLoading.show(status: 'loading...');
    CollectionReference checkUser =
        FirebaseFirestore.instance.collection('Customer_Sign_In');

    checkUser.where('email', isEqualTo: email).get().then((value) => {
          if (value.size > 0)
            {
              value.docs.forEach((element) {
                if (element.data()['profilestatus']) {
                  addEmail(email);
                  Fluttertoast.showToast(
                      msg: "...Sign In successful..",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  EasyLoading.dismiss();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(),
                    ),
                    (route) => false,
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "...Complete Your Profile to Continue...",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  EasyLoading.dismiss();
                  Navigator.pushNamed(context, CompleteProfileScreen.routeName,
                      arguments: {
                        'location': ' ',
                        'email': email,
                        'password':
                            'User Signed in with Google(No Password Available)',
                        'customer': 'c'
                      });
                }
              })
            }
          else
            {
              checkUser.doc(email).set({
                'email': email,
                'password': 'User Signed in with Google(No Password Available)',
                'location': ' ',
                'profilestatus': false
              }).then((value) => {
                    EasyLoading.dismiss(),
                    Navigator.pushNamed(
                        context, CompleteProfileScreen.routeName,
                        arguments: {
                          'location': ' ',
                          'email': email,
                          'password':
                              'User Signed in with Google(No Password Available)',
                          'customer': 'c'
                        })
                  })
            }
        });
  }
}
