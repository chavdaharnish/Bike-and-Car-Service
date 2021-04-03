import 'package:bike_car_service/constants.dart';
import 'package:bike_car_service/screens/mechanic_home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../size_config.dart';

class OperationList extends StatefulWidget {
  static String routeName = "/operation";
  @override
  _OperationListState createState() => _OperationListState();
}

class _OperationListState extends State<OperationList> {
  Future _data;
  String operation;

  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String email = prefs.getString('memail');

    // CollectionReference signIn =
    //     FirebaseFirestore.instance.collection('Customer_Sign_In').doc(email).collection('BookingDetails');

    if (operation == '2') {
      QuerySnapshot qn = await firestore
          .collection("Mechanic_Sign_In")
          .doc(email)
          .collection('Request')
          .get();

      return qn.docs;
    } else if (operation == '1') {
      QuerySnapshot qn = await firestore
          .collection("Mechanic_Sign_In")
          .doc(email)
          .collection('RunningOrders')
          .get();

      return qn.docs;
    } else if (operation == '0') {
      QuerySnapshot qn = await firestore
          .collection("Mechanic_Sign_In")
          .doc(email)
          .collection('CompletedOrders')
          .get();

      return qn.docs;
    }
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
    final Map<String, Object> data = ModalRoute.of(context).settings.arguments;
    operation = data['operation'];
    return Scaffold(
      appBar: AppBar(
        title: operation == '2'
            ? Text("Request List")
            : operation == '1'
                ? Text("Running Order List")
                : Text('Completed Order List'),
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
                                child: operation == '2'
                                    ? Icon(Icons.add_circle_rounded,
                                        color: Colors.lightGreen)
                                    : operation == '1'
                                        ? Icon(null)
                                        : operation == '0'
                                            ? Icon(null)
                                            : operation,
                                onTap: () {
                                  if (operation == '2') {
                                    _showDialog('Accept', snapshot.data[index]);
                                  }
                                },
                              ), // icon-1
                              InkWell(
                                child: operation == '2'
                                    ? Icon(Icons.remove_circle_rounded,
                                        color: Colors.orange)
                                    : operation == '1'
                                        ? Icon(Icons.archive,
                                            color: Colors.lightGreen)
                                        : operation == '0'
                                            ? Icon(null)
                                            : operation,
                                onTap: () {
                                  if (operation == '2') {
                                    _showDialog('Denied', snapshot.data[index]);
                                  } else if (operation == '1') {
                                    _showDialog(
                                        'RunningOrders', snapshot.data[index]);
                                  }
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
                          onTap: () {
                            // if (operation == '2') {
                            //   _showBookingData(snapshot.data[index]);
                            // }else if(operation == '1'){

                            // }
                            _showBookingData(snapshot.data[index]);
                          },
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

  _showBookingData(var data) {
    showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
              backgroundColor: Colors.black,
              // Color(0xFF4A3298),
              insetPadding: EdgeInsets.all(5),
              content: Container(
                  height: getProportionateScreenHeight(250),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Details',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        Text(
                          'Email : ' + data.data()['customerEmail'],
                          maxLines: null,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        Text(
                          'Address : ' + data.data()['vehicleAddress'],
                          maxLines: null,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        Text(
                          'Vehicle Type : ' + data.data()['vehicleType'],
                          maxLines: null,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        Text(
                          'Vehicle Name : ' + data.data()['vehicleName'],
                          maxLines: null,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        Text(
                          'Vehicle Issue : ' + data.data()['vehicleIssue'],
                          maxLines: null,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        Text(
                          'Date : ' + data.data()['date'],
                          maxLines: null,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        Text(
                            'Duration : ' +
                                data.data()['startTime'] +
                                ' - ' +
                                data.data()['endTime'],
                            maxLines: null,
                            style: TextStyle(color: Colors.white)),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                      ],
                    ),
                  )));
        });
  }

  _showDialog(var type, var data) {
    showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
            content: Container(
              padding: EdgeInsets.all(0),
              child: operation == '2'
                  ? Text('To $type Request Press Yes')
                  : operation == '1'
                      ? Text(
                          'Press Yes if order is completed\n\nMake sure that customer paid all the bills.')
                      : operation,
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
                    } else if (type == 'Denied') {
                      onPressDenied(data);
                    } else if (operation == '1') {
                      onPressArchive(data);
                    }
                  })
            ],
          );
        });
  }

  onPressArchive(var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String email = prefs.getString('memail');
    CollectionReference remove = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(email)
        .collection('RunningOrders');

    CollectionReference signIn = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(email)
        .collection('CompletedOrders');

    signIn.doc(data.id).set({
      'date': data.data()['date'],
      'startTime': data.data()['startTime'],
      'endTime': data.data()['endTime'],
      'shopName': data.data()['shopName'],
      'mechanicEmail': email,
      'mechanicMobile': data.data()['mechanicMobile'],
      'customerEmail': data.data()['customerEmail'],
      'vehicleType': data.data()['vehicleType'],
      'vehicleName': data.data()['vehicleName'],
      'vehicleAddress': data.data()['vehicleAddress'],
      'vehicleIssue': data.data()['vehicleIssue'],
    }).then((value) => {
          remove.doc(data.id).delete().then((value) {
            // setState(() {
            //   _data = getPosts();
            // });
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MechanicHomeScreen()));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MechanicHomeScreen()),
            );
          })
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
      'vehicleType': data.data()['vehicleType'],
      'vehicleName': data.data()['vehicleName'],
      'vehicleAddress': data.data()['vehicleAddress'],
      'vehicleIssue': data.data()['vehicleIssue'],
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
              MaterialPageRoute(builder: (context) => MechanicHomeScreen()),
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
        MaterialPageRoute(builder: (context) => MechanicHomeScreen()),
      );
    });
  }
}
