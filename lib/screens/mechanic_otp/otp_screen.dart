import 'package:flutter/material.dart';
import 'package:bike_car_service/size_config.dart';

import 'components/body.dart';

class MechanicOtpScreen extends StatelessWidget {
  static String routeName = "/mechanic_otp";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: Body(),
    );
  }
}
