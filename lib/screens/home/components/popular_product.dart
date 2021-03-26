import 'package:flutter/material.dart';
import 'package:bike_car_service/components/product_card.dart';
import 'package:bike_car_service/models/Product.dart';

import '../../../size_config.dart';

class PopularProducts extends StatefulWidget {
  @override
  _PopularProductsState createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  // var demoProducts;

  @override
  void initState() {
    super.initState();
    //  demoProducts = addInitMechanics();
  }

  @override
  Widget build(BuildContext context) {
    // return Column(children: [
    //   Padding(
    //     padding:
    //         EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
    //     child: SectionTitle(title: "Popular Mechanic", press: () {}),
    //   ),
    //   SizedBox(height: getProportionateScreenWidth(20)),
    return Row(children: <Widget>[
      Expanded(
          child: SizedBox(
        height: 350,
        child: FutureBuilder(
            future: addMechanics(),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot != null) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text("Loading..."),
                  );
                } else {
                  var noMechanic = true;
                  return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      
                      //padding: EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                       
                        if (snapshot.data.length > 0) {
                          
                          if (snapshot.data[index].status == 'Opened'){
                            noMechanic = false;
                            return ProductCard(product: snapshot.data[index]);
                          }
                          else {
                            //snapshot.data.length = 0;
                            if(noMechanic && index == snapshot.data.length - 1){
                              noMechanic= false;
                            return Text.rich(
                              TextSpan(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                  text:
                                      'No Mechanics Available \nat Your Location'),
                            );

                            }
                          }
                        } else {
                          return Text.rich(
                            TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                                text:
                                    'No Mechanics Available \nat Your Location 2'),
                          );
                        }
                        return SizedBox.shrink();
                      },
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.white,
                            height: 0,
                            thickness: 0,
                          ),
                      itemCount: snapshot.data.length);
                }
              } else {
                return Text.rich(
                  TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      text: 'No Mechanics Available \nat Your Location'),
                );
              }
            }),
      )),
      SizedBox(width: getProportionateScreenWidth(5)),
    ]);
  }
}

// class PopularProducts extends StatelessWidget {

//   final demoProducts = addMechanics();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding:
//               EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
//           child: SectionTitle(title: "Popular Mechanic", press: () {}),
//         ),
//         SizedBox(height: getProportionateScreenWidth(20)),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: [
//               ...List.generate(
//                 demoProducts.length,
//                 (index) {
//                   if (demoProducts[index].isPopular)
//                     return ProductCard(product: demoProducts[index]);

//                   return SizedBox
//                       .shrink(); // here by default width and height is 0
//                 },
//               ),
//               SizedBox(width: getProportionateScreenWidth(20)),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }

// List.generate(snapshot.data.length, (index) {
//   if (snapshot.data.length > 0) {
//     if (snapshot.data[index].isPopular)
//       return ProductCard(
//           product: snapshot.data[index]);
//   } else {
//     return Text.rich(
//       TextSpan(
//         style: TextStyle(
//             color: Colors.black, fontSize: 20),
//         children: [
//           TextSpan(
//             text:
//                 'No Mechanics Available \nat Your Location',
//           )
//         ],
//       ),
//     );
//   }

//   return SizedBox
//       .shrink(); // here by default width and height is 0
// });
