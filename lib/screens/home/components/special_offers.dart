import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class MechanicInfo extends StatefulWidget {
  const MechanicInfo({
    Key key,
  }) : super(key: key);

  @override
  _MechanicInfoState createState() => _MechanicInfoState();
}

class _MechanicInfoState extends State<MechanicInfo> {
  String shopName;
  String mobile;
  //List<String> shops = ["shop 1","shop 2"];
  var data = [
    // {
    //   'shopName': 'shop 1',
    //   'numOfStaff': '123544454542'
    //   },
    //    {
    //   'shopName': 'shop 2',
    //   'numOfStaff': '123456789'
    //   }
  ];

  @override
  void initState() {
    addMechanics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "Mechanics",
            press: () {},
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: data
                .map(
                  (element) => SpecialOfferCard(
                    shopname: element['shopName'],
                    mobile: element['mobile'],
                    press: () {},
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Future addMechanics() {
    CollectionReference signIn =
        FirebaseFirestore.instance.collection('Mechanic_Sign_In');

    return signIn.where('address', isEqualTo: 'Upleta').get().then((value) => {
          if (value.size > 0)
            {
              value.docs.forEach((element) {
                setState(() {
                  data.add({
                    'shopName': element.data()['shopname'],
                    'mobile': element.data()['mobile']
                  });
                });
              })
            }
          else
            {
              data.add({
                'shopName': 'No Mechanics Found',
                'mobile': 'on your location'
              })
            }
        });
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key key,
    @required this.shopname,
    @required this.mobile,
    @required this.press,
  }) : super(key: key);

  final String shopname;
  final String mobile;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
              EdgeInsets.symmetric(vertical: getProportionateScreenWidth(5)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(300),
          height: getProportionateScreenWidth(120),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFF4A3298),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF4A3298),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$shopname\n",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$mobile")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
