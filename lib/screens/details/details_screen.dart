import 'package:bike_car_service/constants.dart';
import 'package:bike_car_service/helper/request_mail.dart';
import 'package:bike_car_service/models/BookingSchedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/Product.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';
import 'components/book_mechanic.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(rating: agrs.product.rating),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Transform.scale(
        scale: 1.1,
        child: FloatingActionButton.extended(
          label: Text('Book Mechanic'),
          icon: Icon(Icons.build_circle),
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.pushNamed(context, BookMechanic.routeName, arguments: ProductDetailsArguments(
                          product: agrs.product, 
                          //schedule: agrs.schedule
                          ), );
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => BookMechanic(), ));
            // if (agrs.schedule !=null && agrs.schedule.date != null) {
              
            //   _setBookingSchedule(agrs, context);
            // }
          },
        ),
      ),
      body: Body(
        product: agrs.product,
        schedule: agrs.schedule,
      ),
    );
  }

  _setBookingSchedule(var agrs, var context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String email = prefs.getString('email');

    CollectionReference signIn = FirebaseFirestore.instance
        .collection('Customer_Sign_In')
        .doc(email)
        .collection('BookingDetails');

    return signIn.add({
      'date': agrs.schedule.date,
      'startTime': agrs.schedule.startTime,
      'endTime': agrs.schedule.endTime,
      'shopName': agrs.product.title,
      'mechanicEmail': agrs.product.email,
      'mechanicMobile': agrs.product.mobile,
      'customerEmail': email,
    }).then((value) {
      String id = value.id;
      _setRequestToMechanic(agrs, context, id);
    });
  }

  _setRequestToMechanic(var agrs, var context, var id) async {
    String email = agrs.product.email;

    CollectionReference signIn = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(email)
        .collection('Request');

    signIn.doc(id).set({
      'date': agrs.schedule.date,
      'startTime': agrs.schedule.startTime,
      'endTime': agrs.schedule.endTime,
      'shopName': agrs.product.title,
      'mechanicEmail': agrs.product.email,
      'mechanicMobile': agrs.product.mobile,
      'customerEmail': email,
    }).then((value) {

      requestMail(agrs.product.email , agrs.product.title , context);
      // Navigator.pop(context);
    });
  }
}

class ProductDetailsArguments {
  final Product product;
  final BookingSchedule schedule;

  ProductDetailsArguments({@required this.product, this.schedule});
}