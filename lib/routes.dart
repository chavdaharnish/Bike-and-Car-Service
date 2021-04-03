import 'package:bike_car_service/screens/details/components/book_mechanic.dart';
import 'package:bike_car_service/screens/details/components/date_time_picker.dart';
import 'package:bike_car_service/screens/home/components/list_mechanic.dart';
import 'package:bike_car_service/screens/mechanic_forgot_password/forgot_password_screen.dart';
import 'package:bike_car_service/screens/mechanic_home/components/add_staff_detail.dart';
import 'package:bike_car_service/screens/mechanic_home/home_screen.dart';
import 'package:bike_car_service/screens/mechanic_otp/otp_screen.dart';
import 'package:bike_car_service/screens/mechanic_profile/profile_screen.dart';
import 'package:bike_car_service/screens/mechanic_sign_in/sign_in_screen.dart';
import 'package:bike_car_service/screens/mechanic_sign_up/sign_up_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:bike_car_service/screens/cart/cart_screen.dart';
import 'package:bike_car_service/screens/complete_profile/complete_profile_screen.dart';
import 'package:bike_car_service/screens/details/details_screen.dart';
import 'package:bike_car_service/screens/forgot_password/forgot_password_screen.dart';
import 'package:bike_car_service/screens/home/home_screen.dart';
import 'package:bike_car_service/screens/login_success/login_success_screen.dart';
import 'package:bike_car_service/screens/otp/otp_screen.dart';
import 'package:bike_car_service/screens/profile/profile_screen.dart';
import 'package:bike_car_service/screens/profile/components/my_account.dart';
import 'package:bike_car_service/screens/sign_in/sign_in_screen.dart';
import 'package:bike_car_service/screens/splash/splash_screen.dart';
import 'package:bike_car_service/components/verify.dart';
import 'screens/mechanic_home/components/request_list.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  MechanicOtpScreen.routeName: (context) => MechanicOtpScreen(),
  MechanicSignUpScreen.routeName: (context) => MechanicSignUpScreen(),
  VerifyScreen.routeName: (context) => VerifyScreen(),
  MechanicSignInScreen.routeName: (context) => MechanicSignInScreen(),
  MechanicForgotPasswordScreen.routeName:(context)=>MechanicForgotPasswordScreen(),
  MyAccount.routeName:(context)=>MyAccount(),
  MechanicHomeScreen.routeName:(context)=>MechanicHomeScreen(),
  MechanicProfileScreen.routeName:(context)=>MechanicProfileScreen(),
  ListPage.routeName:(context)=>ListPage(),
  AddandRemoveStaff.routeName:(context)=>AddandRemoveStaff(),
  DateTimePicker.routeName:(context)=>DateTimePicker(),
  OperationList.routeName:(context)=>OperationList(),
  BookMechanic.routeName:(context)=>BookMechanic(),
};
