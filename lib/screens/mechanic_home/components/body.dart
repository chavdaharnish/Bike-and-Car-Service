import 'package:bike_car_service/screens/mechanic_home/components/section_title.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'categories.dart';
import 'home_header.dart';
import 'staff_info.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(10)),
            Categories(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SectionTitle(
                title: "Staff Information",
                press: () {},
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(10)),
            StaffInfo(),
            SizedBox(height: getProportionateScreenWidth(30)),
            //PopularProducts(),
          ],
        ),
      ),
    );
  }
}
