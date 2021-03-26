import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../size_config.dart';

class StaffInfo extends StatefulWidget {
  const StaffInfo({
    Key key,
  }) : super(key: key);

  @override
  _StaffInfoState createState() => _StaffInfoState();
}

class _StaffInfoState extends State<StaffInfo> {
  
  var data = [
    //   {
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
        // Padding(
        //   padding:
        //       EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        //   child: SectionTitle(
        //     title: "Staff Information",
        //     press: () {},
        //   ),
        // ),
        // SizedBox(height: getProportionateScreenWidth(10)),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: data
                .map(
                  (element) => SpecialOfferCard(
                    name: element['name'],
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

  Future addMechanics() async{
    var email;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('memail');

    CollectionReference signIn = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(email)
        .collection('StaffInfo');

    print('email........' + email);

    return signIn.get().then((value) => {
          if (value.size > 0)
            {
              value.docs.forEach((element) {
                setState(() {
                  data.add({
                    'name': element.data()['name'],
                    'mobile': element.data()['mobile']
                  });
                });
              })
            }
          else
            {
              data.add({'name': 'No Staff Found', 'mobile': 'Add Now...'})
            }
        });
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key key,
    @required this.name,
    @required this.mobile,
    @required this.press,
  }) : super(key: key);

  final String name;
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
          width: getProportionateScreenWidth(350),
          height: getProportionateScreenWidth(80),
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
                          text: "$name\n",
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

// class SpecialOffers extends StatelessWidget {
//   const SpecialOffers({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding:
//               EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
//           child: SectionTitle(
//             title: "Mechanics",
//             press: () {},
//           ),
//         ),
//         SizedBox(height: getProportionateScreenWidth(20)),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: [
//               SpecialOfferCard(
//                 image: "assets/images/wash_logo.png",
//                 shopname: 'shopName',
//                 numOfStaff: 10,
//                 press: () {},
//               ),
//               SpecialOfferCard(
//                 image: "assets/images/success.png",
//                 shopname: 'shopName',
//                 numOfStaff: 24,
//                 press: () {},
//               ),
//               SizedBox(width: getProportionateScreenWidth(20)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
