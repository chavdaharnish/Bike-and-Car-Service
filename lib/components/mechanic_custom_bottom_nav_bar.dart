import 'package:bike_car_service/screens/mechanic_home/home_screen.dart';
import 'package:bike_car_service/screens/mechanic_profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
import '../enums.dart';

class MechanicCustomBottomNavBar extends StatelessWidget {
  const MechanicCustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MechanicMenu selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/Shop Icon.svg",
                    color: MechanicMenu.home == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => {
                    if(MechanicMenu.home != selectedMenu){
                       Navigator.pushNamed(
                            context, MechanicHomeScreen.routeName),
                    }
                      }),
              IconButton(
                icon: SvgPicture.asset("assets/icons/Chat bubble Icon.svg"),
                onPressed: () {},
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  color: MechanicMenu.profile == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>{
                  if(MechanicMenu.profile != selectedMenu){
                 Navigator.pushNamed(
                    context, MechanicProfileScreen.routeName),
                  }
                }),
            ],
          )),
    );
  }
}
