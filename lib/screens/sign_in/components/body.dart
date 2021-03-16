import 'package:bike_car_service/components/mechanic_account_text.dart';
import 'package:bike_car_service/screens/home/home_screen.dart';
import 'package:bike_car_service/user_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/components/no_account_text.dart';
import 'package:bike_car_service/components/socal_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../size_config.dart';
import 'sign_form.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class Body extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final Geolocator geolocator = Geolocator();
  Position _currentPosition;
  String location;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () {
                        signInWithGoogle().then((result) {
                          if (result != null) {
                            addEmail(result.email);
                            Fluttertoast.showToast(
                                msg: '...Sign In Successfully done...',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomeScreen(),
                                ),
                                (route) => false);
                          }
                        },
                            onError: (e) => Fluttertoast.showToast(
                                msg: e.message != null
                                    ? e.message
                                    : "Something Went Wrong!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0));
                      },
                    ),
                    SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {},
                    ),
                    SocalCard(
                      icon: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
                SizedBox(height: getProportionateScreenHeight(20)),
                MechanicAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      _getCurrentPosition();
      print('signInWithGoogle succeeded: $user');

      return user;
    }

    return null;
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

  Future<void> addLocation(String location) {
    CollectionReference signIn =
        FirebaseFirestore.instance.collection('Customer_Sign_In');

    return signIn.doc(_auth.currentUser.email).update({'location': location});
  }
}
