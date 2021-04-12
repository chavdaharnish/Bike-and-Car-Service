import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../size_config.dart';

class MechanicRunningOrder extends StatefulWidget {
  @override
  _MechanicRunningOrderState createState() => _MechanicRunningOrderState();
}

class _MechanicRunningOrderState extends State<MechanicRunningOrder> {
  Future _data;
  TextEditingController _priceController = TextEditingController();
  String price;
  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('memail');

    QuerySnapshot qn = await firestore
        .collection("Mechanic_Sign_In")
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
                        // leading: Image.asset(
                        //   "assets/images/app_logo.png",
                        // ),
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: <Widget>[
                            InkWell(
                              child: Icon(Icons.edit_rounded,
                                  color: Colors.lightGreen),
                              onTap: () {
                                _showDialog(snapshot.data[index]);
                              },
                            ), // icon-1
                            // InkWell(
                            //   child: Icon(Icons.remove_circle_rounded,
                            //       color: Colors.orange),
                            //   onTap: () {},
                            // ), // icon-2
                          ],
                        ),
                        title: Text.rich(
                          TextSpan(
                            style: TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text: 'Booking Details',
                                style: TextStyle(
                                  //fontSize: getProportionateScreenWidth(),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // subtitle: Text.rich(
                        //   TextSpan(
                        //     style: TextStyle(color: Colors.white),
                        //     children: [
                        //       TextSpan(text: snapshot.data[index].data()['']),
                        //     ],
                        //   ),
                        // ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              'Email : ' +
                                  snapshot.data[index].data()['customerEmail'],
                              maxLines: null,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              'Address : ' +
                                  snapshot.data[index].data()['vehicleAddress'],
                              maxLines: null,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              'Vehicle Type : ' +
                                  snapshot.data[index].data()['vehicleType'],
                              maxLines: null,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              'Vehicle Name : ' +
                                  snapshot.data[index].data()['vehicleName'],
                              maxLines: null,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              'Vehicle Issue : ' +
                                  snapshot.data[index].data()['vehicleIssue'],
                              maxLines: null,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                              'Date : ' + snapshot.data[index].data()['date'],
                              maxLines: null,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Text(
                                'Duration : ' +
                                    snapshot.data[index].data()['startTime'] +
                                    ' - ' +
                                    snapshot.data[index].data()['endTime'],
                                maxLines: null,
                                style: TextStyle(color: Colors.white)),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            // Text(
                            //     'Price : ' + price != null
                            //         ? 'Price : ' + price + ' INR'
                            //         : 'Price : ' +
                            //                     snapshot.data[index]
                            //                         .data()['price'] !=
                            //                 ''
                            //             ? 'Price : ' +
                            //                 snapshot.data[index]
                            //                     .data()['price'] +
                            //                 ' INR'
                            //             : 'not updated',
                            //     maxLines: null,
                            //     style: TextStyle(color: Colors.white)),
                            // SizedBox(
                            //   height: getProportionateScreenHeight(10),
                            // ),
                            // Text(
                            //     'Payment Status : ' +
                            //         snapshot.data[index]
                            //             .data()['paymentstatus'],
                            //     maxLines: null,
                            //     style: TextStyle(color: Colors.white)),
                          ],
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
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: "Charges",
                      hintText: "Enter Charges of this Order",
                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ],
              )),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              new FlatButton(
                  child: const Text('Not Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              // ignore: deprecated_member_use
              new FlatButton(
                  child: const Text('OK'),
                  onPressed: () {
                    if (_priceController.text.trim().isNotEmpty) {
                      EasyLoading.show(status: 'loading...');
                      _updatePrice(product);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Fill Proper",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }),

              // ignore: deprecated_member_use
              // new FlatButton(child: const Text('YES'), onPressed: () {})
            ],
          );
        });
  }

  _updatePrice(var product) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    String mechanicEmail = user.getString('memail');
    String customerEmail = product.data()['customerEmail'];

    CollectionReference mechanicSignIn = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(mechanicEmail)
        .collection('RunningOrders');

    CollectionReference customerSignIn = FirebaseFirestore.instance
        .collection('Customer_Sign_In')
        .doc(customerEmail)
        .collection('RunningOrders');

    mechanicSignIn
        .doc(product.id)
        .update({
          'price': _priceController.text.trim(),
        })
        .then((value) => {
              setState(() {
                price = _priceController.text.trim();
              }),
              customerSignIn.doc(product.id).update({
                'price': _priceController.text.trim(),
              }),
              EasyLoading.dismiss(),
              Navigator.pop(context)
            })
        .onError((error, stackTrace) => {
              EasyLoading.dismiss(),
            });
  }
}
