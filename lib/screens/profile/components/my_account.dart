import 'package:bike_car_service/screens/profile/components/account_info.dart';
import 'package:bike_car_service/screens/profile/components/profile_pic.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class MyAccount extends StatelessWidget {
  static String routeName = "/myaccount";
  String email;
  String name;
  String mobile;
  String address;

  @override
  Widget build(BuildContext context) {

    final  Map<String, Object> data = ModalRoute.of(context).settings.arguments;
    mobile = data['mobile'];
    address = data['address'];
    email = data['email'];
    name = data['name'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Account Info"),
      ),
      body: SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          AccountInfo(
            text: name,
            icon: "assets/icons/User Icon.svg",
            press: () => {

            },
          ),
          AccountInfo(
            text: email,
            icon: "assets/icons/Mail.svg",
            press: () {

            },
          ),
          AccountInfo(
            text: mobile,
            icon: "assets/icons/Call.svg",
            press: () {

            },
          ),
          AccountInfo(
            text: address,
            icon: "assets/icons/Location point.svg",
            press: () {
              
            },
          ),
        ],
      ),
    ),
    );
  }
}
