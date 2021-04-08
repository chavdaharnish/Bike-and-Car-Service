import 'package:bike_car_service/models/Location.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final double rating, price;
  final bool isFavourite, isPopular;
  final String status;
  final String email;
  final String mobile;
  final String location;

  Product({
    @required this.id,
    @required this.images,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    @required this.title,
    @required this.email,
    @required this.mobile,
    this.price,
    this.status,
    this.location,
    @required this.description,
  });
}

// Our demo Products

Future<List<Product>> addMechanics() async {
  CollectionReference signIn =
      FirebaseFirestore.instance.collection('Mechanic_Sign_In');

  //String location = object.finalLocation;

  demoProducts.clear();

  
  await signIn.where('location', isEqualTo: object.finalLocation.toLowerCase()).get().then((value) async {
    if (value.size > 0) {
      for (var shop_element in value.docs) {
        String description = " No Details Available";
        count++;

        String email = shop_element.id;

        await signIn.doc(email).collection('AboutStore').get().then((value) {
          for (var element in value.docs) {
            description = element.data()['description'];
            print('object' + element.data()['description']);
          }
        });
        demoProducts.add(Product(
          id: count,
          images: [
            "assets/images/app_logo.png",
          ],
          location: shop_element.data()['location'] ,
          title: shop_element.data()['shopname'],
          description: description,
          email: shop_element.id,
          mobile: shop_element.data()['mobile'],
          isFavourite: true,
          isPopular: true,
          status: shop_element.data()['status'],
          price: 0,
        ));
      }
    }
  });

  return demoProducts;
}

List<Product> demoProducts = [];
var count = 0;
