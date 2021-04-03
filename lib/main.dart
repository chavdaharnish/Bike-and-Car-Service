import 'package:bike_car_service/screens/home/home_screen.dart';
import 'package:bike_car_service/screens/mechanic_home/home_screen.dart';
import 'package:bike_car_service/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/routes.dart';
import 'package:bike_car_service/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String mechanicEmail;
  String customerEmail;

  String mEmail;
  String cEmail;

  @override
  void initState() {
    super.initState();
    getMechanicEmail();
    getEmail();
  }

  getMechanicEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    mechanicEmail = prefs.getString('memail');
    //return email;
    if (mechanicEmail != null && mechanicEmail != '') {

      setState(() {
        mEmail = mechanicEmail;
      });
      

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => MechanicHomeScreen()),
      // );
    }
  }

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    customerEmail = prefs.getString('email');
    //return email;

    if (customerEmail != '' && customerEmail != null) {

      setState(() {
        cEmail = customerEmail;
      });
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rapid Service',
      theme: theme(),
      // home: SplashScreen(),
      initialRoute: cEmail != null
          ? HomeScreen.routeName
          : mEmail != null
              ? MechanicHomeScreen.routeName
              : SplashScreen.routeName,
      routes: routes,
      builder: EasyLoading.init(),
      
    );
  }
}

// class MyApp extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Bike and Car',
//       theme: theme(),
//       // home: SplashScreen(),
//       initialRoute: SplashScreen.routeName,
//       routes: routes,
//     );
//   }
// }
