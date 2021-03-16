import 'package:bike_car_service/screens/otp/components/otp_form.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/size_config.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: OtpForm(),
    );
  }
}
