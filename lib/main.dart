import 'package:bike_car_service/screens/home/home_screen.dart';
import 'package:bike_car_service/screens/mechanic_home/home_screen.dart';
import 'package:bike_car_service/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/routes.dart';
import 'package:bike_car_service/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  String mechanicEmail;
  String customerEmail;

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
    if (mechanicEmail != '' && mechanicEmail != null) {
      Navigator.pushNamed(context, MechanicHomeScreen.routeName);
    }

  }

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    customerEmail = prefs.getString('email');
    //return email;

    if(customerEmail != '' && customerEmail != null){
      Navigator.pushNamed(context, HomeScreen.routeName);
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rapid Service',
      theme: theme(),
      // home: SplashScreen(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
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
