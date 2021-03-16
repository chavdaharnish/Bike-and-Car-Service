import 'package:bike_car_service/components/mechanic_custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/enums.dart';

import 'components/body.dart';

class MechanicProfileScreen extends StatelessWidget {
  static String routeName = "/mechanicprofile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Body(),
      bottomNavigationBar: MechanicCustomBottomNavBar(selectedMenu: MechanicMenu.profile),
    );
  }
}
