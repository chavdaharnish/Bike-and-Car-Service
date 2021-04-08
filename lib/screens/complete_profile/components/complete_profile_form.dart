import 'package:bike_car_service/components/verify.dart';
import 'package:bike_car_service/screens/mechanic_home/home_screen.dart';
import 'package:bike_car_service/user_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/components/custom_surfix_icon.dart';
import 'package:bike_car_service/components/default_button.dart';
import 'package:bike_car_service/components/form_error.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  //test commit
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String firstName;
  String lastName;
  String mobile;
  String address;
  String shopName;
  String email;
  String password;
  String location;
  String customer;
  String mechanic;
  QuerySnapshot uid;
  TextEditingController _addressController = TextEditingController();
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
    final Map<String, Object> data = ModalRoute.of(context).settings.arguments;
    shopName = data['shopName'];
    location = data['location'];
    email = data['email'];
    password = data['password'];
    customer = data['customer'];
    mechanic = data['mechanic'];

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "continue",
            press: () {
              if (_formKey.currentState.validate()) {
                firstName = _fnameController.text.trim();
                lastName = _lnameController.text.trim();
                address = _addressController.text.trim();
                mobile = _mobileController.text.trim();
                if (mechanic == 'm') {
                  updateMechanicData(firstName, lastName, email, password,
                      address, mobile, context);
                  EasyLoading.show(status: 'loading...');
                } else if (customer == 'c') {
                  updateCustomerData(firstName, lastName, email, password,
                      address, mobile, location, context);
                  EasyLoading.show(status: 'loading...');
                }

                //Navigator.pushNamed(context, OtpScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> updateMechanicData(
      String firstname,
      String lastname,
      String email,
      String password,
      String address,
      String mobile,
      BuildContext context) {
    CollectionReference profile =
        FirebaseFirestore.instance.collection('Mechanic_Sign_In');

    return profile.doc(email).set({
      'shopname': shopName,
      'email': email,
      'password': password,
      'fname': firstName,
      'lname': lastName,
      'mobile': mobile,
      'address': address,
      'profilestatus': true,
      'status': 'Closed',
      'devicetoken': ' ',
    }).then(
      (_) {
        addMechanicEmail(email);
        Fluttertoast.showToast(
            msg: '...Data Added Successfully...',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MechanicHomeScreen(),
          ),
          (route) => false,
        );
        EasyLoading.dismiss();
      },
    ).catchError((error) {
      Fluttertoast.showToast(
          msg: error.message != null ? error.message : "Something Went Wrong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      EasyLoading.dismiss();
    });
  }

  Future<void> updateCustomerData(
      String firstname,
      String lastname,
      String email,
      String password,
      String address,
      String mobile,
      String location,
      BuildContext context) {
    CollectionReference profile =
        FirebaseFirestore.instance.collection('Customer_Sign_In');

    return profile.doc(email).set({
      'email': email,
      'password': password,
      'fname': firstName,
      'lname': lastName,
      'mobile': mobile,
      'address': address,
      'location': location,
      'profilestatus': true,
      'devicetoken': ' ',
    }).then(
      (_) {
        addEmail(email);
        Fluttertoast.showToast(
            msg: '...Data Added Successfully...',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
        //Navigator.pushNamed(context,HomeScreen.routeName);
        Navigator.pushNamed(context, VerifyScreen.routeName);
        EasyLoading.dismiss();
      },
    ).catchError((error) {
      Fluttertoast.showToast(
          msg: error.message != null ? error.message : "Something Went Wrong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      EasyLoading.dismiss();
    });
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      controller: _addressController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter your phone address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => mobile = newValue,
      controller: _mobileController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      controller: _lnameController,
      decoration: InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      controller: _fnameController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
