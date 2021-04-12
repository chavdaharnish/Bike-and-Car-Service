import 'dart:ui';

import 'package:bike_car_service/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bike_car_service/models/Product.dart';
import '../../../size_config.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(
            product.title,
            style: TextStyle(
                color: kPrimaryColor, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(15)),
            width: getProportionateScreenWidth(64),
            decoration: BoxDecoration(
              color:
                  product.isFavourite ? Color(0xFFFFE6E6) : Color(0xFFF5F6F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: SvgPicture.asset(
              "assets/icons/Heart Icon_2.svg",
              color:
                  product.isFavourite ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
              height: getProportionateScreenWidth(16),
            ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: 'Email : ' + product.email,
                  style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '\nMobile : ' + product.mobile,
                  style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                // TextSpan(
                //   text: description != null
                //       ? description
                //       : 'Click on Edit Icon To Add About Your Store',
                //   style: TextStyle(
                //     fontSize:
                //         getProportionateScreenWidth(18),
                //     //fontWeight: FontWeight.bold,
                //   ),
                // ),
              ],
            ),
          ),

          // Text('Email : '+
          //   product.email + '\nMobile : ' + product.mobile,
          //   style: Theme.of(context).textTheme.caption,
          // ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: Text(
            product.bike && product.car
                ? 'Servicing Bike and Car Both'
                : product.bike && !product.car
                    ? 'Servicing Only Bikes'
                    : product.car && !product.bike
                        ? ''
                        : !product.car && !product.bike
                            ? 'Not Updated by Mechanic'
                            : 'Not Updated by Mechanic',
            maxLines: null,
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),

        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: Text(
            'Price Range : ' + product.price,
            maxLines: 1,
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: Text(
            'Speciality : ' + product.speciality,
            maxLines: null,
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: Text(
            'Description : ' + product.description,
            maxLines: 10,
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        // Padding(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: getProportionateScreenWidth(20),
        //     vertical: 10,
        //   ),
        //   child: GestureDetector(
        //     onTap: () {},
        //     child: Row(
        //       children: [
        //         Text(
        //           "See More Detail",
        //           style: TextStyle(
        //               fontWeight: FontWeight.w600, color: kPrimaryColor),
        //         ),
        //         SizedBox(width: 5),
        //         Icon(
        //           Icons.arrow_forward_ios,
        //           size: 12,
        //           color: kPrimaryColor,
        //         ),
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }
}
