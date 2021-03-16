import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/components/coustom_bottom_nav_bar.dart';
import 'package:bike_car_service/enums.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position _currentPosition;

  String location;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    // verify permissions
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
    }
    // get current position
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // get address
    String _currentAddress = await _getGeolocationAddress(_currentPosition);
    print("Logitute and Latitude -> " + _currentAddress);
  }

  // Method to get Address from position:

  Future<String> _getGeolocationAddress(Position position) async {
    // geocoding
    var places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (places != null && places.isNotEmpty) {
      final Placemark place = places.first;
      print("Place and City -> " + place.thoroughfare + place.locality);
      location = place.locality;

      addLocation(location);
      //verifyUser(email, location, context);
      return "${place.thoroughfare}, ${place.locality}";
    }

    return "No address available";
  }

  Future<void> addLocation(String location) async {
    CollectionReference signIn =
        FirebaseFirestore.instance.collection('Customer_Sign_In');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String email = prefs.getString('email');

    return signIn.doc(email).update({'location': location});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   static String routeName = "/home";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Body(),
//       bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
//     );
//   }
// }
