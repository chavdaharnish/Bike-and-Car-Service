import 'package:bike_car_service/screens/mechanic_sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../size_config.dart';

class MechanicNoAccountText extends StatelessWidget {
  const MechanicNoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "New Mechanic? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context,MechanicSignUpScreen.routeName),
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
