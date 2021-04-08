import 'package:bike_car_service/helper/keyboard.dart';
import 'package:bike_car_service/helper/utils.dart';
import 'package:bike_car_service/screens/complete_profile/complete_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/components/custom_surfix_icon.dart';
import 'package:bike_car_service/components/default_button.dart';
import 'package:bike_car_service/components/form_error.dart';
import 'package:bike_car_service/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  // ignore: non_constant_identifier_names
  String conform_password;
  String mobile;
  String location;
  bool remember = false;
  final List<String> errors = [];

  final auth = FirebaseAuth.instance;

  //final Geolocator geolocator = Geolocator();
  //Position _currentPosition;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference signUp = FirebaseFirestore.instance.collection('Customer_Sign_In');

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
          SizedBox(height: getProportionateScreenHeight(15)),
          // buildmobileFormField(),
          // SizedBox(height: getProportionateScreenHeight(15)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Sign Up",
            press: () async{
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen
                //authentication();
                EasyLoading.show(status: 'loading...');
                auth.createUserWithEmailAndPassword(
                  email: email, 
                  password: password).then((_) {
                   // _getCurrentPosition();
                  //addEmail(email);
                  addUser(email, password, location, context);
                  KeyboardUtil.hideKeyboard(context);
                  //Navigator.pushNamed(context, VerifyScreen.routeName);
                }, onError: (e) => Fluttertoast.showToast(
                      msg: e.message != null ? e.message : "Something Went Wrong!" ,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0
                    ) );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  

  Future<void> addUser(String email,String password, String location, BuildContext context) {

     password = Utils.hashPassword(password);

      // Call the user's CollectionReference to add a new user
      return signUp
          .doc(email)
          .set({
            'email': email, 
            'password': password,
            'location': location,
            'profilestatus':false 
          })
           .then((_){
                  Fluttertoast.showToast(
                  msg: '...SignUp Successfully...',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0
                  );
                  Navigator.pushNamed(context,CompleteProfileScreen.routeName,
                    arguments: {'location' : location , 'email': email , 'password': password , 'customer' : 'c'});
                  EasyLoading.dismiss();
              },
          ).catchError((error){
                 Fluttertoast.showToast(
                  msg: error.message != null ? error.message : "Something Went Wrong!" ,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0
                  );
                  EasyLoading.dismiss();
          });
    }


  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      controller: _repasswordController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conform_password) {
          removeError(error: kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      controller: _passwordController,
      onChanged: (value) {
        password = value;
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
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
      controller: _emailController,
      onChanged: (value) {
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
  //   print("Logitute and Latitude -> "+_currentAddress);
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
  //     addUser(email, password, location, context);
  //     return "${place.thoroughfare}, ${place.locality}";
  //   }

  //   return "No address available";
  // }