import 'package:bike_car_service/components/verify.dart';
import 'package:bike_car_service/screens/complete_profile/complete_profile_screen.dart';
import 'package:bike_car_service/screens/home/home_screen.dart';
import 'package:bike_car_service/screens/login_success/login_success_screen.dart';
import 'package:bike_car_service/user_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/components/custom_surfix_icon.dart';
import 'package:bike_car_service/components/form_error.dart';
import 'package:bike_car_service/screens/forgot_password/forgot_password_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String location;
  bool remember = false;
  final List<String> errors = [];
  final auth = FirebaseAuth.instance;

  final Geolocator geolocator = Geolocator();
  Position _currentPosition;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference signIn =
      FirebaseFirestore.instance.collection('Customer_Sign_In');

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen
                // if (auth.currentUser.emailVerified) {
                auth
                    .signInWithEmailAndPassword(
                        email: email, password: password)
                    .then((_) {

                      verifyUser(email, location, context);

                  //_getCurrentPosition();

                  // if (auth.currentUser.emailVerified) {
                  //   Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (BuildContext context) => HomeScreen(),
                  //     ),
                  //     (route) => false,
                  //   );
                  // }

                  //KeyboardUtil.hideKeyboard(context);
                  //Navigator.pushNamed(context, LoginSuccessScreen.routeName);
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
                //}
                // else if (!auth.currentUser.emailVerified) {
                //   Navigator.pushNamed(context, VerifyScreen.routeName);
                //   Fluttertoast.showToast(
                //       msg: "Verify Email For Great Experience With Us",
                //       toastLength: Toast.LENGTH_SHORT,
                //       gravity: ToastGravity.BOTTOM,
                //       timeInSecForIosWeb: 1,
                //       backgroundColor: Colors.blue,
                //       textColor: Colors.white,
                //       fontSize: 16.0);
                // }
              }
            },
          ),
        ],
      ),
    );
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
  //     verifyUser(email, location, context);
  //     return "${place.thoroughfare}, ${place.locality}";
  //   }

  //   return "No address available";
  // }

  Future<void> verifyUser(String email, String location, BuildContext context) {
    // Call the user's CollectionReference to add a new user
    return signIn
        .where('email', isEqualTo: email)
        .get()
        .then((value) => {
              if (value.size > 0)
                {
                  value.docs.forEach((element) {
                    if (element.data()['profilestatus']) {
                      //signIn.doc(email).update({'location': location});
                      addEmail(email);
                      Fluttertoast.showToast(
                          msg: "...Sign In successful..",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      if (auth.currentUser.emailVerified) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => HomeScreen(),
                          ),
                          (route) => false,
                        );
                      } else if (!auth.currentUser.emailVerified) {
                        Navigator.pushNamed(context, VerifyScreen.routeName);
                      }
                      // Navigator.pushNamed(
                      //     context, LoginSuccessScreen.routeName);
                    } else {
                      Fluttertoast.showToast(
                          msg: "...Complete Your Profile to Continue...",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pushNamed(
                          context, CompleteProfileScreen.routeName, arguments: {
                        'location': ' ',
                        'email': email,
                        'password': password,
                        'customer': 'c'
                      });
                    }
                  }),
                }
              else
                {
                  Fluttertoast.showToast(
                      msg: "...User doesn't exist or check email...",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0),
                }
            })
        .catchError((error) {
      Fluttertoast.showToast(
          msg: "...Something went wrong...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        password = value;
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        email = value;
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
