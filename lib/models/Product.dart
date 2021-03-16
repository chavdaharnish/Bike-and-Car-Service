import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final double rating, price;
  final bool isFavourite, isPopular;

  Product({
    @required this.id,
    @required this.images,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    @required this.title,
    this.price,
    @required this.description,
  });
}

// Our demo Products

Future<List<Product>> addMechanics() async {
  CollectionReference signIn =
      FirebaseFirestore.instance.collection('Mechanic_Sign_In');

  demoProducts.clear();

  await signIn.where('address', isEqualTo: 'Upleta').get().then((value) async {
    if (value.size > 0) {
      for (var shop_element in value.docs) {
        String description = " No Details Available";
        // value.docs.forEach((element) {
        count++;

        String email = shop_element.id;

        await signIn.doc(email).collection('AboutStore').get().then((value) {
          for (var element in value.docs) {
            //value.docs.forEach((element) {
            description = element.data()['description'];
            print('object' + element.data()['description']);
          }
        });
        demoProducts.add(Product(
          id: count,
          images: [
            "assets/images/app_logo.png",
          ],
          title: shop_element.data()['shopname'],
          description: description,
          isFavourite: true,
          isPopular: true,
          price: 0,
        ));
      }
    }
  });

  return demoProducts;
}

List<Product> demoProducts = [
  // Product(
  //   id: 1,
  //   images: [
  //     // "assets/images/Image.png",
  //     // "assets/images/Image.png",
  //     // "assets/images/Image.png",
  //     // "assets/images/Image.png",
  //   ],

  //   title: "A to Z Mechanic Center",
  //   //price: 0,
  //   description: description,
  //   rating: 4.8,
  //   isFavourite: true,
  //   isPopular: true,
  // ),
  // Product(
  //   id: 2,
  //   images: [
  //     "assets/images/Image.png",
  //   ],

  //   title: "Maruti Suzuki Service Center",
  //   //price: 50.5,
  //   description: description,
  //   rating: 4.1,
  //   isPopular: true,
  // ),
  // Product(
  //   id: 3,
  //   images: [
  //     "assets/images/Image.png",
  //   ],

  //   title: "AutoMobile Bike and Car Service Center",
  //   //price: 36.55,
  //   description: description,
  //   rating: 4.1,
  //   isFavourite: true,
  //   isPopular: true,
  // ),
  // Product(
  //   id: 4,
  //   images: [
  //     "assets/images/Image.png",
  //   ],

  //   title: "Radhe-Krishna Bike Service Center",
  //   //price: 20.20,
  //   description: description,
  //   rating: 4.1,
  //   isFavourite: true,
  // ),
];

var count = 0;
