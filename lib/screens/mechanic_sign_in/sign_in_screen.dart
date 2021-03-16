import 'package:flutter/material.dart';

import 'components/body.dart';

class MechanicSignInScreen extends StatelessWidget {
  static String routeName = "/mechanic_sign_in";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Body(),
    );
  }
}
