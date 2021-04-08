import 'dart:async';
import 'package:bike_car_service/constants.dart';
import 'package:bike_car_service/models/BookingSchedule.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/models/Product.dart';
// import 'color_dots.dart';
import 'date_time_picker.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatelessWidget {
  final Product product;
  final BookingSchedule schedule;

  const Body({Key key, @required this.product, this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: product),
        TopRoundedContainer(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProductDescription(
                  product: product,
                  pressOnSeeMore: () {},
                ),

                SizedBox(height: 200,)
                // TopRoundedContainer(
                //   color: Color(0xFFF6F7F9),
                //   child: Column(
                //     children: [
                //       //ColorDots(product: product),
                //       Row(
                //         children: [
                //           Padding(padding: EdgeInsets.all(10)),
                //           InkWell(
                //               child: Text(
                //                 'Pick Date and Time for Booking',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.w600,
                //                     color: kPrimaryColor),
                //               ),
                //               onTap: () {
                //                 Navigator.pushNamed(
                //                   context,
                //                   DateTimePicker.routeName,
                //                   arguments:
                //                       ProductDetailsArguments(product: product),
                //                 );
                //               }),
                //           SizedBox(width: getProportionateScreenWidth(10)),
                //           Icon(Icons.arrow_right),
                //           SizedBox(width: getProportionateScreenWidth(60)),
                //           Container(
                //             height: getProportionateScreenWidth(40),
                //             width: getProportionateScreenWidth(40),
                //             decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               boxShadow: [
                //                 BoxShadow(
                //                   offset: Offset(0, 6),
                //                   blurRadius: 10,
                //                   color: Color(0xFFB0B0B0).withOpacity(0.2),
                //                 ),
                //               ],
                //             ),
                //             child: FlatButton(
                //               padding: EdgeInsets.zero,
                //               color: kPrimaryColor,
                //               shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(50)),
                //               onPressed: () {
                //                 Navigator.pushNamed(
                //                     context, DateTimePicker.routeName,
                //                     arguments: ProductDetailsArguments(
                //                         product: product));
                //               },
                //               child: Icon(
                //                 Icons.schedule,
                //                 color: Colors.white,
                //               ),
                //             ),
                //           ),
                //           // IconButton(
                //           //     color: kPrimaryColor,
                //           //     icon: Icon(Icons.schedule),
                //           //     onPressed: () {}),
                //           // RoundedIconBtn(
                //           //     showShadow: true,
                //           //     icon: Icons.schedule,
                //           //     press: () {
                //           // Navigator.push(
                //           //   context,
                //           //   MaterialPageRoute(
                //           //       builder: (context) => DateTimePicker()),
                //           // );
                //           //     }),
                //         ],
                //       ),
                //       // TopRoundedContainer(
                //       //   color: Color(0xFFF6F7F9),
                //       //   child: Padding(
                //       //       padding: EdgeInsets.only(
                //       //         left: SizeConfig.screenWidth * 0.05,
                //       //         right: SizeConfig.screenWidth * 0.05,
                //       //         // bottom: getProportionateScreenWidth(),
                //       //       ),
                //       //       child: schedule != null
                //       //           ? Text('Date :' +
                //       //               schedule.date +
                //       //               '\nTime : ' +
                //       //               schedule.startTime +
                //       //               ' - ' +
                //       //               schedule.endTime, style: TextStyle(color: Colors.purple))
                //       //           : Text('Selected Date and Time will be Shown Here',style: TextStyle(color: Colors.purple))
                //       //       // DefaultButton(
                //       //       //   text: "Book Mechanic",
                //       //       //   press: () {},
                //       //       // ),
                //       //       ),
                //       // ),
                //       SizedBox(height : 100)
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class LoadingButton extends StatefulWidget {
  LoadingButton({Key key, this.text, this.press}) : super(key: key);

  final String text;
  final Function press;

  @override
  _LoadingButtonState createState() => new _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton>
    with TickerProviderStateMixin {
  int _state = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new PhysicalModel(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(25.0),
              child: new MaterialButton(
                  child: setUpButtonChild(),
                  onPressed: () {
                    setState(() {
                      if (_state == 0) {
                        animateButton();
                      }
                    });
                  },
                  elevation: 4.0,
                  minWidth: double.infinity,
                  height: 48.0,
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DateTimePicker()),
                    );
                  }),
            ))
      ],
    );
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        widget.text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 2;
      });
    });
  }
}
