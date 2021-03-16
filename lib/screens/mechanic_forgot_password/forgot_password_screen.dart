import 'package:flutter/material.dart';

import 'components/body.dart';

class MechanicForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/mechanic_forgot_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mechanic Forgot Password"),
      ),
      body: Body(),
    );
  }
}
