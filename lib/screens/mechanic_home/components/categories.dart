import 'package:bike_car_service/screens/mechanic_home/components/request_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../size_config.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var length1, length2, length3 = 0;

  @override
  void initState() {
    super.initState();
    _requestLength();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/icons/Flash Icon.svg", "text": "Completed"},
      {"icon": "assets/icons/Bill Icon.svg", "text": "Running"},
      {"icon": "assets/icons/Gift Icon.svg", "text": "Requests"},
    ];
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            numOfitem: notify(index),
            press: () {
              if (index == 2) {
                //print('object');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestList()),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _requestLength() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String email = prefs.getString('memail');

    CollectionReference request = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(email)
        .collection('Request');

    CollectionReference running = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(email)
        .collection('RunningOrders');

    await running.get().then((value) async {
      setState(() {
        length1 = value.docs.length;
      });
      await request.get().then((value) {
        setState(() {
          length2 = value.docs.length;
        });
      });
    });
  }

  int notify(int index) {
    if (index == 1) {
      return length1;
    } else if (index == 2) {
      return length2;
    }
    return null;
  }
}
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,
    this.numOfitem,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;
  final numOfitem;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
          onTap: press,
          child: Stack(
          overflow: Overflow.visible, 
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              height: getProportionateScreenWidth(60),
              width: getProportionateScreenWidth(60),
              decoration: BoxDecoration(
                color: Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(icon),
            ),
            if (numOfitem != 0 && numOfitem != null)
            Positioned(
              top: -3,
              right: 0,
              child: Container(
                height: getProportionateScreenWidth(20),
                width: getProportionateScreenWidth(20),
                decoration: BoxDecoration(
                  color: Color(0xFFFF4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "$numOfitem",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(10),
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
          ])
          // ),
          ),
      Text(
        text,
        textAlign: TextAlign.center,
      )
    ]);
  }
}

// class CategoryCard extends StatelessWidget {
//   const CategoryCard({
//     Key key,
//     @required this.icon,
//     @required this.text,
//     @required this.press,
//     this.numOfitem,
//   }) : super(key: key);

//   final String icon, text;
//   final GestureTapCallback press;
//   final numOfitem;

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       InkWell(
//           onTap: press,
//           // child: InkWell(
//           //width: getProportionateScreenWidth(75),
//           child: Stack(overflow: Overflow.visible, children: [
//             //  Column(
//             // children: [
//             //if (numOfitem != 0 && numOfitem != null)
//             // Positioned(
//             //   top: -3,
//             //   right: 0,

//             //   child: Container(
//             //     height: getProportionateScreenWidth(16),
//             //     width: getProportionateScreenWidth(16),
//             //     decoration: BoxDecoration(
//             //       color: Color(0xFFFF4848),
//             //       shape: BoxShape.circle,
//             //       border: Border.all(width: 1.5, color: Colors.white),
//             //     ),
//             //     child: Center(
//             //       child: Text(
//             //         "0",
//             //         //"$numOfitem",
//             //         style: TextStyle(
//             //           fontSize: getProportionateScreenWidth(10),
//             //           height: 1,
//             //           fontWeight: FontWeight.w600,
//             //           color: Colors.white,
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             Container(
//               padding: EdgeInsets.all(getProportionateScreenWidth(15)),
//               height: getProportionateScreenWidth(60),
//               width: getProportionateScreenWidth(60),
//               decoration: BoxDecoration(
//                 color: Color(0xFFFFECDF),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: SvgPicture.asset(icon),
//             ),
//             if (numOfitem != 0 && numOfitem != null)
//             Positioned(
//               top: -3,
//               right: 0,
//               child: Container(
//                 height: getProportionateScreenWidth(20),
//                 width: getProportionateScreenWidth(20),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFFF4848),
//                   shape: BoxShape.circle,
//                   border: Border.all(width: 1.5, color: Colors.white),
//                 ),
//                 child: Center(
//                   child: Text(
//                     //"0",
//                     "$numOfitem",
//                     style: TextStyle(
//                       fontSize: getProportionateScreenWidth(10),
//                       height: 1,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 5),
//             //   ],
//             // ),
//           ])
//           // ),
//           ),
//       Text(
//         text,
//         textAlign: TextAlign.center,
//         // style: TextStyle(fontSize: , color: Color(0xFF4A3298)),
//       )
//     ]);
//   }
// }

// class Categories extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> categories = [
//       {"icon": "assets/icons/Flash Icon.svg", "text": "Completed"},
//       {"icon": "assets/icons/Bill Icon.svg", "text": "Running"},
//       {"icon": "assets/icons/Gift Icon.svg", "text": "Requests"},
//     ];
//     return Padding(
//       padding: EdgeInsets.all(getProportionateScreenWidth(20)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: List.generate(
//           categories.length,
//           (index) => CategoryCard(
//             icon: categories[index]["icon"],
//             text: categories[index]["text"],
//             numOfitem: _requestLength(index),
//             press: () {
//               if (index == 2) {
//                 //print('object');
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RequestList()),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   _requestLength(var index) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //Return String
//     String email = prefs.getString('memail');

//     int length;

//     if (index == 2) {
//       CollectionReference signIn = FirebaseFirestore.instance
//           .collection('Mechanic_Sign_In')
//           .doc(email)
//           .collection('Request');

//       await signIn.get().then((value) => {length = value.docs.length});
//     }

//     return length != null ? length : 0;
//   }
// }


// class PendingRequest extends StatefulWidget {
//   @override
//   _PendingRequestState createState() => _PendingRequestState();
// }

// class _PendingRequestState extends State<PendingRequest> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
