import 'package:bike_car_service/screens/home/home_screen.dart';
import 'package:bike_car_service/screens/mechanic_home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/body.dart';

class SignInScreen extends StatefulWidget {
   static String routeName = "/sign_in";
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Position _currentPosition;

  // String location;


  @override
  void initState(){
    super.initState();
    //_getCurrentPosition();
    _getEmail();
  }

  _getEmail()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
    String email = prefs.getString('email');
    if(email!=null && email.isNotEmpty){
       Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(),
        ),
        (route) => false,
      );
    }
   String memail = prefs.getString('memail');
    if(memail!=null && memail.isNotEmpty){
       Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MechanicHomeScreen(),
        ),
        (route) => false,
      );
    }
  }

  // Future<void> _getCurrentPosition() async {
  //   // verify permissions
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     await Geolocator.openAppSettings();
  //     await Geolocator.openLocationSettings();
  //   }
  //   // get current position
  //   _currentPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   // get address
  //   String _currentAddress = await _getGeolocationAddress(_currentPosition);
  //   print("Logitute and Latitude -> " + _currentAddress);
  // }

  // // Method to get Address from position:

  // Future<String> _getGeolocationAddress(Position position) async {
  //   // geocoding
  //   var places = await placemarkFromCoordinates(
  //     position.latitude,
  //     position.longitude,
  //   );
  //   if (places != null && places.isNotEmpty) {
  //     final Placemark place = places.first;
  //     print("Place and City -> " + place.thoroughfare + place.locality);
  //     location = place.locality;

  //     addLocation(location);
  //     //verifyUser(email, location, context);
  //     return "${place.thoroughfare}, ${place.locality}";
  //   }

  //   return "No address available";
  // }

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
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Body(),
    );
  }
}
