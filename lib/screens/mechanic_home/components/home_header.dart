import 'package:bike_car_service/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShopStatus(),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Star Icon.svg",
            numOfitem: 4,
            press: () {},
          ),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfitem: 3,
            press: () {},
          ),
        ],
      ),
    );
  }
}

class ShopStatus extends StatefulWidget {
  @override
  _ShopStatusState createState() => _ShopStatusState();
}

class _ShopStatusState extends State<ShopStatus> {
  String status;
  var brown = Colors.brown;
  var green = Colors.green;
  var red = Colors.red;
  var color;

  @override
  void initState() {
    super.initState();
    _getStatus();
    _deviceToken();
  }

  _deviceToken() {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      // ignore: missing_return
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called');
        //return null;
      },
      // ignore: missing_return
      onResume: (Map<String, dynamic> message) {
        print('onResume called');
        //return null;
      },
      // ignore: missing_return
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called');
        //return null;
      },
    );
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    ));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Hello');
    });
    _firebaseMessaging.getToken().then((token) {
      print(token); // Print the Token in Console
      //finalToken = DeviceToken(finalToken: token);
      finalToken = token;
      _updateDeviceToken(token);
    });
  }

  _updateDeviceToken(String token) async {
    CollectionReference signIn =
        FirebaseFirestore.instance.collection('Mechanic_Sign_In');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String email = prefs.getString('memail');
    if (token.isNotEmpty) {
      return signIn.doc(email).update({'devicetoken': token});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
      ),
      child: Container(
          width: SizeConfig.screenWidth * 0.5,
          height: SizeConfig.screenWidth * 0.1,
          color: Colors.white,
          // decoration: BoxDecoration(
          //   color: kSecondaryColor.withOpacity(0.1),
          //   borderRadius: BorderRadius.circular(15),
          // ),
          child: Row(children: [
            Icon(
              Icons.arrow_right_sharp,
              color: brown,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Shop Status : $status',
                style: TextStyle(color: Colors.brown),
              ),
            ),
          ])),
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return new AlertDialog(
                content: Container(
                  padding: EdgeInsets.all(0),
                  child: Text('Current Status Is : $status\n\nWant to change?'),
                ),
                actions: <Widget>[
                  // ignore: deprecated_member_use
                  new FlatButton(
                      child: const Text('NO'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  // ignore: deprecated_member_use
                  new FlatButton(
                      child: const Text('YES'),
                      onPressed: () {
                        setState(() {
                          if (status == 'Opened') {
                            status = 'Closed';
                            color = red;
                            _setStatus(status);
                            Navigator.pop(context);
                          } else {
                            status = 'Opened';
                            color = green;
                            _setStatus(status);
                            Navigator.pop(context);
                          }
                        });
                      })
                ],
              );
            });
      },
      onLongPress: () {},
    );
  }

  _getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('memail');
    CollectionReference signIn =
        FirebaseFirestore.instance.collection('Mechanic_Sign_In');

    return signIn.where('email', isEqualTo: email).get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          status = element.data()['status'];
          if (status == 'Opened') {
            color = green;
          } else {
            color = red;
          }
        });
      });
    });
  }

  _setStatus(String stat) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('memail');
    CollectionReference signIn =
        FirebaseFirestore.instance.collection('Mechanic_Sign_In');

    return signIn.doc(email).update({'status': stat}).then((value) {});
  }
}
