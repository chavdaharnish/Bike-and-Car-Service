import 'package:bike_car_service/screens/mechanic_home/components/mechanic_running_order.dart';
import 'package:bike_car_service/screens/mechanic_home/components/section_title.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'categories.dart';
import 'home_header.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(20)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SectionTitle(
                title: "My Orders",
                press: () {},
              ),
            ),
            Categories(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SectionTitle(
                title: "Running Order        ",
                press: () {},
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(10)),
            //StaffInfo(),
            SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Container(
                      height: getProportionateScreenHeight(600),
                      padding: EdgeInsets.all(12.0),
                      child: MechanicRunningOrder(),
                    ),
                  )),
                  SizedBox(
                    height: getProportionateScreenHeight(200),
                  ),
                ],
              ),
            ),
            // MechanicRunningOrder(),
            //SizedBox(height: getProportionateScreenWidth(200)),
            //PopularProducts(),
          ],
        ),
      ),
    );
  }
}
