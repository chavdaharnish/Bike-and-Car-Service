import 'package:bike_car_service/components/mechanic_custom_bottom_nav_bar.dart';
import 'package:bike_car_service/screens/mechanic_home/components/add_staff_detail.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/enums.dart';
import 'components/body.dart';

class MechanicHomeScreen extends StatelessWidget {
  static String routeName = "/mechanichome";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar:
          MechanicCustomBottomNavBar(selectedMenu: MechanicMenu.home),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddandRemoveStaff.routeName);
        },
        child: Icon(Icons.edit),
        backgroundColor: Color(0xFF4A3298),
      ),
    );
  }
}
