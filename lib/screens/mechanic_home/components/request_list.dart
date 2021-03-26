import 'package:bike_car_service/screens/mechanic_home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../size_config.dart';

class RequestList extends StatefulWidget {
  static String routeName = "/list_mechanic";
  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  Future _data;

  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String email = prefs.getString('memail');

    // CollectionReference signIn =
    //     FirebaseFirestore.instance.collection('Customer_Sign_In').doc(email).collection('BookingDetails');

    QuerySnapshot qn = await firestore
        .collection("Mechanic_Sign_In")
        .doc(email)
        .collection('Request')
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Request List"),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: FutureBuilder(
            future: _data,
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Loading..."),
                );
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
                                child: Icon(Icons.add_circle_rounded,
                                    color: Colors.lightGreen),
                                onTap: () {
                                  _showDialog('Accept', snapshot.data[index]);
                                },
                              ), // icon-1
                              InkWell(
                                child: Icon(Icons.remove_circle_rounded,
                                    color: Colors.orange),
                                onTap: () {
                                  _showDialog('Denied', snapshot.data[index]);
                                },
                              ), // icon-2
                            ],
                          ),
                          title: Text.rich(
                            TextSpan(
                              style: TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text: snapshot.data[index]
                                      .data()['customerEmail'],
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(15),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text.rich(
                            TextSpan(
                              style: TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                    text: 'Date : ' +
                                        snapshot.data[index].data()['date'] +
                                        '\n' +
                                        'Time : ' +
                                        snapshot.data[index]
                                            .data()['startTime'] +
                                        ' - ' +
                                        snapshot.data[index].data()['endTime']),
                              ],
                            ),
                          ),
                          onTap: () => () {},
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF4A3298),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }

  _showDialog(var type, var data) {
    showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
            content: Container(
              padding: EdgeInsets.all(0),
              child: Text('To $type Request Press Yes'),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              new FlatButton(
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              // ignore: deprecated_member_use
              new FlatButton(
                  child: const Text('YES'),
                  onPressed: () {
                    if (type == 'Accept') {
                      onPressAccept(data);
                    } else {
                      onPressDenied(data);
                    }
                  })
            ],
          );
        });
  }

  onPressAccept(var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String email = prefs.getString('memail');

    CollectionReference signIn = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(email)
        .collection('RunningOrders');

    CollectionReference remove = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(email)
        .collection('Request');

    signIn.doc(data.id).set({
      'date': data.data()['date'],
      'startTime': data.data()['startTime'],
      'endTime': data.data()['endTime'],
      'shopName': data.data()['shopName'],
      'mechanicEmail': email,
      'mechanicMobile': data.data()['mechanicMobile'],
      'customerEmail': data.data()['customerEmail'],
    }).then((value) => {
          remove.doc(data.id).delete().then((value) {
            // setState(() {
            //   getPosts();
            // });
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MechanicHomeScreen()));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RequestList()),
            );
          })
        });
  }

  onPressDenied(var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String email = prefs.getString('memail');

    CollectionReference remove = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(email)
        .collection('Request');

    remove.doc(data.id).delete().then((value) {
      // setState(() {
      //   getPosts();
      // });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MechanicHomeScreen()));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RequestList()),
      );
    });
  }
}