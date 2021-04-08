import 'package:bike_car_service/models/Location.dart';
import 'package:bike_car_service/models/Product.dart';
import 'package:bike_car_service/screens/profile/components/my_account.dart';
import 'package:bike_car_service/screens/sign_in/sign_in_screen.dart';
import 'package:bike_car_service/user_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  CollectionReference info =
      FirebaseFirestore.instance.collection('Customer_Sign_In');
  final FirebaseAuth auth = FirebaseAuth.instance;
  String email;
  String fname,lname;
  String mobile;
  String address;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              information(context),
            },
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              signOutGoogle(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> signOutGoogle(BuildContext context) async {

    _removeDeviceToken();

    await googleSignIn.signOut();


    addEmail('');
    demoProducts.clear();
    object = UserLocation(finalLocation: '');
    Fluttertoast.showToast(
        msg: '...User Signed Out...',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SignInScreen(),
      ),
      (route) => false,
    );
    //print("User Signed Out");
  }

  _removeDeviceToken()async{

    return await info.doc(auth.currentUser.email).update({
      'devicetoken': ' ',
    });
  }

  Future<void> information(BuildContext context) {
    return info
        .where('email', isEqualTo: auth.currentUser.email)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                fname = element.data()['fname'];
                lname = element.data()['lname']; 
                mobile = element.data()['mobile'];
                address = element.data()['address'];
                email = auth.currentUser.email;
                Navigator.pushNamed(context, MyAccount.routeName, arguments: {
                  'email': email,
                  'mobile': mobile,
                  'address': address,
                  'fname': fname,
                  'lname': lname
                });
              })
            });
  }
}
