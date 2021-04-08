import 'package:bike_car_service/screens/home/components/list_mechanic.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    @required this.title,
    @required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(getProportionateScreenWidth(5)),
      scrollDirection: Axis.horizontal,
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.black,
          ),
        ),
        SizedBox(width: getProportionateScreenWidth(80),),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ListPage.routeName);
          },
          child: Text(
            "See More",
            style: TextStyle(color: Color(0xFFBBBBBB)),
          ),
        ),
      ],
    ));
  }
}
