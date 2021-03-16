import 'package:bike_car_service/helper/utils.dart';
import 'package:bike_car_service/screens/mechanic_sign_in/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/components/custom_surfix_icon.dart';
import 'package:bike_car_service/components/default_button.dart';
import 'package:bike_car_service/components/form_error.dart';
import 'package:bike_car_service/screens/complete_profile/complete_profile_screen.dart';
import 'package:bike_car_service/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants.dart';
import '../../../size_config.dart';


class MechanicSignUpForm extends StatefulWidget {
  @override
  _MechanicSignUpFormState createState() => _MechanicSignUpFormState();
}

class _MechanicSignUpFormState extends State<MechanicSignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  // ignore: non_constant_identifier_names
  String conform_password;
  String shopName;
  bool remember = false;
  final List<String> errors = [];
  TextEditingController _emailController = TextEditingController();
  TextEditingController _shopNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference signUp = FirebaseFirestore.instance.collection('Mechanic_Sign_In');

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
          buildshopNameFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Sign Up",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen
                email = _emailController.text.trim();
                password = _passwordController.text.trim();
                shopName = _shopNameController.text.trim();

                if(email!=null && password!=null && shopName!=null){
                  checkEmail(email, context);
                  //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                }

              }
            },
          ),
        ],
      ),
    );
  }

   Future<void> addUser(String email,String password,String shopName,BuildContext context) {

     password = Utils.hashPassword(password);

      // Call the user's CollectionReference to add a new user
      return signUp
          .doc(email)
          .set({
            'email': email, 
            'password': password,
            'shopname': shopName,
            'profilestatus' : false
          })
           .then((_){
                  Fluttertoast.showToast(
                  msg: '...Registered Successfully...',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0
                  );
                  Navigator.pushNamed(context,CompleteProfileScreen.routeName,
                  arguments: {'shopName' : shopName , 'email': email , 'password': password, 'mechanic' : 'm'});
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
          });
    }

    Future<void> checkEmail(String email,BuildContext context){
      return signUp
            .where('email', isEqualTo: email)
            .get()
            .then((value) => {
               if(value.size > 0){
                  Fluttertoast.showToast(
                      msg: "...User already exist or check email..." ,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0
                  ),
                  Navigator.pushNamed(context, MechanicSignInScreen.routeName),
                  value.docs.forEach((element) {
                    print(element.data().toString());
                  }),
                }else{
                  addUser(email, password, shopName, context),
                }
            }).catchError((error){
                    Fluttertoast.showToast(
                    msg: "...Something went wrong..." ,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0
                    );
            });
    }

    // Future<void> checkUser(String shopName,BuildContext context){
    //   return signUp
    //         .where('username', isEqualTo: shopName)
    //         .get()
    //         .then((value) => {
    //            if(value.size > 0){
    //               Fluttertoast.showToast(
    //                   msg: "...Try differnt username..." ,
    //                   toastLength: Toast.LENGTH_SHORT,
    //                   gravity: ToastGravity.BOTTOM,
    //                   timeInSecForIosWeb: 1,
    //                   backgroundColor: Colors.blue,
    //                   textColor: Colors.white,
    //                   fontSize: 16.0
    //               ),
    //               // Navigator.pushNamed(context, MechanicSignInScreen.routeName),
    //               // value.docs.forEach((element) {
    //               //   print(element.data().toString());
    //               // }),
    //             }else{
    //               addUser(email, password, shopName, context),
    //             }
    //         }).catchError((error){
    //                 Fluttertoast.showToast(
    //                 msg: "...Something went wrong..." ,
    //                 toastLength: Toast.LENGTH_SHORT,
    //                 gravity: ToastGravity.BOTTOM,
    //                 timeInSecForIosWeb: 1,
    //                 backgroundColor: Colors.blue,
    //                 textColor: Colors.white,
    //                 fontSize: 16.0
    //                 );
    //         });
    // }



  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
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

  TextFormField buildshopNameFormField() {
    return TextFormField(
      onSaved: (newValue) => shopName = newValue,
      controller: _shopNameController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kShopnameNullError);
        } else if (value.isNotEmpty && value.length >= 5) {
          removeError(error: kShopnameLengthError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kShopnameNullError);
          return "";
        } else if ((value.length<5)) {
          addError(error: kShopnameLengthError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Shop Name",
        hintText: "Enter shopname",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }


  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      controller: _passwordController,
      onChanged: (value) {
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

