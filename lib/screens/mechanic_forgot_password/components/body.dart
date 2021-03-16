import 'package:bike_car_service/helper/utils.dart';
import 'package:bike_car_service/screens/mechanic_otp/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/components/custom_surfix_icon.dart';
import 'package:bike_car_service/components/default_button.dart';
import 'package:bike_car_service/components/no_account_text.dart';
import 'package:bike_car_service/size_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              MechanicForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}


class MechanicForgotPassForm extends StatefulWidget {
  @override
  _MechanicForgotPassFormState createState() => _MechanicForgotPassFormState();
}

class _MechanicForgotPassFormState extends State<MechanicForgotPassForm> {

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

  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  // ignore: non_constant_identifier_names
  String conform_password;
  String uname;
  bool visibility = true;
  bool remember = false;
  final List<String> errors = [];
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference signUp = FirebaseFirestore.instance.collection('Mechanic_Sign_In');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          buildemailFormfield(),
          SizedBox(height: getProportionateScreenHeight(15)),

          // buildnewPasswordfield(),
          // SizedBox(height: getProportionateScreenHeight(15)),

          // buildconfirmPasswordfield(),
          // SizedBox(height: getProportionateScreenHeight(15)),

          DefaultButton(
            text: "Continue",
            press: () {

                email = _emailController.text.trim();

                if(emailValidatorRegExp.hasMatch(email)){

                  checkEmail(email, context);

                }else if(email.length == 10){

                  Navigator.pushNamed(
                    context, MechanicOtpScreen.routeName,arguments: {'mobile' : email});

                }else{
                  Fluttertoast.showToast(
                    msg: "...Check details again...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0
                    );
                }
              

                //checkEmail(email, context);

              }
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          NoAccountText(),
        ],
      ),
    );
  }

  Future<void> checkEmail(String email,BuildContext context){
      return signUp
            .where('email', isEqualTo: email)
            .get()
            .then((value) => {

              value.docs.forEach((element) {

                //String id =  element.id;

                Fluttertoast.showToast(
                      msg: "...User exist..." ,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0
                );

                Navigator.pushNamed(
                    context, MechanicOtpScreen.routeName,arguments: {'mobile' : email});

                //visibility = false;
                //updatePassword(id,context);

                
              }),

            }).catchError((error){
                    Fluttertoast.showToast(
                    msg: error + "\n...Something went wrong...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0
                    );
            });
    }


    // Future<void> phoneAuth(String mobile, BuildContext context) async{

    //   FirebaseAuth auth = FirebaseAuth.instance;

    //   await FirebaseAuth.instance.verifyPhoneNumber(
    //     phoneNumber: '+91' + mobile,
    //     verificationCompleted: (PhoneAuthCredential credential) async {

    //       await auth.signInWithCredential(credential);

    //     },
    //     verificationFailed: (FirebaseAuthException e) {

    //       if (e.code == 'invalid-phone-number') {
    //         print('The provided phone number is not valid.');
    //       }

    //     },
    //     codeSent: (String verificationId, [int forceResendingToken] ) async{

    //       // Update the UI - wait for the user to enter the SMS code
    //       String smsCode = 'xxxx';

    //       // Create a PhoneAuthCredential with the code
    //       PhoneAuthCredential phoneAuthCredential = 
            
    //           PhoneAuthProvider.credential(
    //             verificationId: verificationId, 
    //             smsCode: smsCode
    //           );

    //       // Sign the user in (or link) with the credential
    //       await auth.signInWithCredential(phoneAuthCredential);

    //     },

    //     timeout: const Duration(seconds: 60),

    //     codeAutoRetrievalTimeout: (String verificationId) {

    //     },

    //   );

    // }



    Future<void> updatePassword(String id, BuildContext context){

      password = Utils.hashPassword(password);

      return signUp
      .doc(id)
      .update({'password' : password})
      .then((value) => Fluttertoast.showToast(
                      msg: "...Password Successfully Updated..." ,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0
                  ),);

    } 

  TextFormField buildemailFormfield(){
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      controller: _emailController,
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

  TextFormField buildnewPasswordfield(){
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

  TextFormField buildconfirmPasswordfield(){
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
}
