import 'package:bike_car_service/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../size_config.dart';

class CustomerRunningOrder extends StatefulWidget {
  @override
  _CustomerRunningOrderState createState() => _CustomerRunningOrderState();
}

class _CustomerRunningOrderState extends State<CustomerRunningOrder> {
  Future _data;
  String price;
  int totalAmount = 0;
  Razorpay _razorpay;

  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');

    QuerySnapshot qn = await firestore
        .collection("Customer_Sign_In")
        .doc(email)
        .collection('RunningOrders')
        .get();

    return qn.docs;
  }

  // navigateToDetail(DocumentSnapshot post) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => DetailPage(
  //                 post: post,
  //               )));
  // }

  @override
  void initState() {
    super.initState();
    _data = getPosts();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _data,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading..."),
            );
          } else {
            if (snapshot.data.length == 0) {
              return Container(
                child: Align(child: Text('No Running Orders Available...')),
              );
              //Text('No Running Orders Available');
            } else {
              return ListView.separated(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(10),
                  clipBehavior: Clip.hardEdge,
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.white,
                        height: 10,
                        thickness: 0,
                      ),
                  shrinkWrap: false,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: ListTile(
                        subtitle: InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                'Shop Name : ' +
                                    snapshot.data[index].data()['shopName'],
                                maxLines: null,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                'Email : ' +
                                    snapshot.data[index]
                                        .data()['mechanicEmail'],
                                maxLines: null,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                'Mobile : ' +
                                    snapshot.data[index]
                                        .data()['mechanicMobile'],
                                maxLines: null,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                            ],
                          ),
                          onTap: () {
                            _showDialog(snapshot.data[index]);
                          },
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF4A3298),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  });
            }
          }
        });
  }

  _showDialog(var product) {
    showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
            insetPadding: EdgeInsets.all(5),
            content: Container(
              padding: EdgeInsets.all(0),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Running Order Details',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  Text(
                    'Shop Name : ' + product.data()['shopName'],
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  Text(
                    'Mechanic Email : ' + product.data()['mechanicEmail'],
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  Text(
                    'Mechanic mobile : ' + product.data()['mechanicMobile'],
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  Text(
                    'Date : ' + product.data()['date'],
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  Text(
                    'Request Time : ' +
                        product.data()['startTime'] +
                        ' - ' +
                        product.data()['endTime'],
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  Text(
                    'Vehicle Type : ' + product.data()['vehicleType'],
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  Text(
                    'Vehicle Name : ' + product.data()['vehicleName'],
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  Text(
                    'Vehicle Issue : ' + product.data()['vehicleIssue'],
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                  Text(
                    'Vehicle Type : ' + product.data()['vehicleType'],
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(20)),
                ],
              )),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              new FlatButton(
                  child: const Text('Make Payment'),
                  onPressed: () {
                    openCheckout(product);
                    // Navigator.pop(context);
                  }),
              // ignore: deprecated_member_use
              new FlatButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              // ignore: deprecated_member_use
              // new FlatButton(child: const Text('YES'), onPressed: () {})
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(var product) async {
    setState(() {
      price = product.data()['price'];
      totalAmount = num.parse(price);
    });

    var options = {
      'key': 'rzp_test_1761NCYXNz6QmS',
      'amount': totalAmount * 100,
      'name': 'Rapid Service',
      'description': 'Test Payment',
      'prefill': {'contract': '', 'email': product.data()['customerEmail']},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS:" + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "ERROR:" + response.message);

    // + response.code.toString() + " - "
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL WALLET" + response.walletName);
  }
}

// leading: Image.asset(
//   "assets/images/app_logo.png",
// ),
// trailing: Wrap(
//   spacing: 12, // space between two icons
//   children: <Widget>[
//     InkWell(
//       child: Icon(Icons.edit_rounded,
//           color: Colors.lightGreen),
//       onTap: () {

//       },
//     ), // icon-1
//     // InkWell(
//     //   child: Icon(Icons.remove_circle_rounded,
//     //       color: Colors.orange),
//     //   onTap: () {},
//     // ), // icon-2
//   ],
// ),
// title: Text.rich(
//   TextSpan(
//     style: TextStyle(color: Colors.white),
//     children: [
//       TextSpan(
//         text:
//             'Booking Details',
//         style: TextStyle(
//           //fontSize: getProportionateScreenWidth(),
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ],
//   ),
// ),
// subtitle: Text.rich(
//   TextSpan(
//     style: TextStyle(color: Colors.white),
//     children: [
//       TextSpan(text: snapshot.data[index].data()['']),
//     ],
//   ),
// ),
