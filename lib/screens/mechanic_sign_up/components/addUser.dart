import 'package:bike_car_service/screens/complete_profile/complete_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';


FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference users = FirebaseFirestore.instance.collection('Mechanic_Sign_In');

Future<void> addUser(String email,String password,String mobile,BuildContext context) {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'email': email, // John Doe
            'password': password, // Stokes and Sons
            'mobile': mobile // 42
          })
           .then((_){
                  Fluttertoast.showToast(
                  msg: '...Registered Successfully...',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0
                  );
                  Navigator.pushNamed(context, CompleteProfileScreen.routeName);
              },
          ).catchError((error){
                 Fluttertoast.showToast(
                  msg: error.message != null ? error.message : "Something Went Wrong!" ,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0
                  );
          });
    }