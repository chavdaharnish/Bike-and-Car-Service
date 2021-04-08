import 'package:bike_car_service/models/Location.dart';
import 'package:bike_car_service/models/Payment.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'section_title.dart';

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
            DiscountBanner(),
            Categories(),
            // MechanicInfo(),
            // SizedBox(height: getProportionateScreenWidth(30)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SectionTitle(title: "Running Order", press: null,),
            ),
            Payment(),
            
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SectionTitle(title: "Mechanics ( " + object.finalLocation + " )", press: () {}),
            ),

            SizedBox(height: getProportionateScreenWidth(10)),
            
            PopularProducts(),
            //SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}
