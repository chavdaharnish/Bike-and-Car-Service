import 'package:flutter/material.dart';
import 'package:bike_car_service/components/default_button.dart';
import 'package:bike_car_service/models/Product.dart';
import 'package:bike_car_service/size_config.dart';

// import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatelessWidget {
  final Product product;

  const Body({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: product,
                pressOnSeeMore: () {},
              ),
              // TopRoundedContainer(
              //   color: Color(0xFFF6F7F9),
              //   child: Column(
              //     children: [
                    //ColorDots(product: product),
                    TopRoundedContainer(
                      color: Color(0xFFF6F7F9),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.15,
                          right: SizeConfig.screenWidth * 0.15,
                          bottom: getProportionateScreenWidth(20),
                          top: getProportionateScreenWidth(80),
                        ),
                        child: DefaultButton(
                          text: "Book Mechanic",
                          press: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
    //       ),
    //     ),
    //   ],
     );
  }
}
