import 'package:bike_car_service/screens/mechanic_sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../size_config.dart';

class MechanicAccountText extends StatelessWidget {
  const MechanicAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Login with Mechanic? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context,MechanicSignInScreen.routeName),
          child: Text(
            "Sign In",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
