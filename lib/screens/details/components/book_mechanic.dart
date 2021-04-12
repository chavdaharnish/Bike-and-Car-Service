import 'package:bike_car_service/helper/request_mail.dart';
import 'package:bike_car_service/models/DeviceToken.dart';
import 'package:bike_car_service/screens/details/components/top_rounded_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/models/BookingSchedule.dart';
import 'package:bike_car_service/models/Product.dart';
import 'package:bike_car_service/screens/details/details_screen.dart';
import 'package:bike_car_service/screens/home/home_screen.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

enum Vehicle { bike, car, none }

class BookMechanic extends StatefulWidget {
  static String routeName = '/bookMechanic';
  @override
  _BookMechanicState createState() => _BookMechanicState();
}

class _BookMechanicState extends State<BookMechanic> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _issueController = TextEditingController();

  String modelName, address, issue;

  var vehicle = Vehicle.none;

  String vehicleType;

  // ignore: unused_field
  String _setStartTime, _setEndTime, _setDate;

  String _startHour, _startMinute, _startTime;
  String _endHour, _endMinute, _endTime;
  Product product;
  String dateTime;
  var tempProduct;
  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(now.year, now.month, now.day + 2));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _startHour = selectedTime.hour.toString();
        _startMinute = selectedTime.minute.toString();
        _startTime = _startHour + ' : ' + _startMinute;
        _startTimeController.text = _startTime;
        _startTimeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _endHour = selectedTime.hour.toString();
        _endMinute = selectedTime.minute.toString();
        _endTime = _endHour + ' : ' + _endMinute;
        _endTimeController.text = _endTime;
        _endTimeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        // _showDialog(_startTimeController.text, _endTimeController.text,
        //     _dateController.text);
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());
    _startTimeController.text = formatDate(
        DateTime(2021, 03, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    _endTimeController.text = formatDate(
        DateTime(2021, 03, 1, DateTime.now().hour + 1, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();

    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        //_timer?.cancel();
      }
    });
    //EasyLoading.showSuccess('Use in initState');
  }

  _checkDetails(var agrs) async {
    if (vehicle == Vehicle.none) {
      final snackBar =
          SnackBar(content: Text("Select Vehicle Type(Bike / Car)"));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Fluttertoast.showToast(
      //     msg: "Select Vehicle Type(Bike / Car)",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.TOP,
      //     timeInSecForIosWeb: 2,
      //     backgroundColor: Colors.blue,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      //return null;
    } else if (modelName.isEmpty ||
        // modelName == "" ||
        address.isEmpty ||
        //address == "" ||
        issue.isEmpty) {
      final snackBar =
          SnackBar(content: Text("Fill all the field to book mechanic"));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      await EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );
      _storeData(agrs);
    }
  }

  _storeData(var agrs) async {
    SharedPreferences user = await SharedPreferences.getInstance();
    String email = user.getString('email');

    CollectionReference signIn = FirebaseFirestore.instance
        .collection('Customer_Sign_In')
        .doc(email)
        .collection('BookingDetails');

    CollectionReference mechanic = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(agrs.email)
        .collection('Request');

    EasyLoading.show(status: 'Sending Request To Mechanic');

    return signIn.add({
      'date': _dateController.text.trim(),
      'startTime': _startTimeController.text.trim(),
      'endTime': _endTimeController.text.trim(),
      'shopName': agrs.title,
      'mechanicEmail': agrs.email,
      'mechanicMobile': agrs.mobile,
      'customerEmail': email,
      'vehicleType': vehicleType,
      'vehicleName': modelName,
      'vehicleAddress': address,
      'vehicleIssue': issue,
      'devicetoken' : finalToken,
      'price': ' ',
      'paymentstatus': false,
    }).then((value) {
      String id = value.id;
      EasyLoading.show(status: 'Data Stored Successfully');
      mechanic.doc(id).set({
        'date': _dateController.text.trim(),
        'startTime': _startTimeController.text.trim(),
        'endTime': _endTimeController.text.trim(),
        'shopName': agrs.title,
        'mechanicEmail': agrs.email,
        'mechanicMobile': agrs.mobile,
        'customerEmail': email,
        'vehicleType': vehicleType,
        'vehicleName': modelName,
        'vehicleAddress': address,
        'vehicleIssue': issue,
        'devicetoken' : finalToken,
        'price': ' ',
        'paymentstatus': false,
      }).then((value) {
        EasyLoading.show(status: 'Sending Mail To Mechanic');
        sendMechanicNotification('Request', finalToken);
        requestMail(agrs.email, agrs.title, context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    dateTime = DateFormat.yMd().format(DateTime.now());
    final ProductDetailsArguments args =
        ModalRoute.of(context).settings.arguments;
    tempProduct = args.product;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Booking"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: showFab
            ? Transform.scale(
                scale: 1.1,
                child: FloatingActionButton.extended(
                  label: Text('Submit'),
                  icon: Icon(Icons.verified_user),
                  backgroundColor: kPrimaryColor,
                  onPressed: () {
                    setState(() {
                      modelName = _nameController.text.trim();
                      address = _addressController.text.trim();
                      issue = _issueController.text.trim();
                    });
                    _checkDetails(tempProduct);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => BookMechanic()));
                    // if (agrs.schedule !=null && agrs.schedule.date != null) {

                    //   _setBookingSchedule(agrs, context);
                    // }
                  },
                ),
              )
            : null,
        body: TopRoundedContainer(
            color: Colors.white,
            child: SingleChildScrollView(
                child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Padding(padding: EdgeInsets.all(20)),
                new Row(
                  // mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: getProportionateScreenWidth(20),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text('Bike'),
                        leading: Radio(
                          value: Vehicle.bike,
                          groupValue: vehicle,
                          activeColor: Colors.deepPurple,
                          onChanged: (Vehicle value) {
                            setState(() {
                              vehicle = value;
                              vehicleType = 'Bike';
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Car'),
                        leading: Radio(
                          value: Vehicle.car,
                          groupValue: vehicle,
                          activeColor: Colors.deepPurple,
                          onChanged: (Vehicle value) {
                            setState(() {
                              vehicle = value;
                              vehicleType = 'Car';
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                TopRoundedContainer(
                    color: Color(0xFFF6F7F9),
                    child: Column(children: [
                      Column(
                        children: <Widget>[
                          //SizedBox(height: getProportionateScreenWidth(50)),
                          Text(
                            'Date',
                          ),
                          InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: getProportionateScreenWidth(50),
                              width: getProportionateScreenWidth(120),
                              //margin: EdgeInsets.all(20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _dateController,
                                onSaved: (String val) {
                                  _setDate = val;
                                },
                                decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    // labelText: 'Time',
                                    contentPadding: EdgeInsets.only(top: 0.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenWidth(10)),
                      Text(
                        'Choose The Time That Suits You Best',
                      ),
                      SizedBox(height: getProportionateScreenWidth(10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // ignore: deprecated_member_use
                          FlatButton(
                            onPressed: () {
                              _selectStartTime(context);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: getProportionateScreenWidth(50),
                              width: getProportionateScreenWidth(140),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                                textAlign: TextAlign.center,
                                onSaved: (String val) {
                                  _setStartTime = val;
                                },
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _startTimeController,
                                decoration: InputDecoration(
                                    // suffixIcon: Icon(
                                    //   Icons.timelapse,

                                    // ),
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    // labelText: 'Time',
                                    contentPadding: EdgeInsets.only(top: 0.0)),
                              ),
                            ),
                          ),
                          Text(
                            'To',
                          ),
                          // ignore: deprecated_member_use
                          FlatButton(
                            onPressed: () {
                              _selectEndTime(context);
                            },
                            child: Container(
                              //margin: EdgeInsets.all(10),
                              height: 50,
                              width: 140,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                                textAlign: TextAlign.center,
                                onSaved: (String val) {
                                  _setEndTime = val;
                                  // _showDialog(_setStartTime,_setEndTime, _setDate);
                                },
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _endTimeController,
                                decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    // labelText: 'Time',
                                    contentPadding: EdgeInsets.only(top: 0.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ])),
                //SizedBox(height: getProportionateScreenWidth(20)),

                TopRoundedContainer(
                  color: Color(0xFFF6F7F9),
                  child: Column(
                    children: [
                      Text(
                        'Fill Datails to get more idea about service',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      SizedBox(height: getProportionateScreenWidth(10)),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            // color: Colors.tealAccent,
                            //borderRadius: BorderRadius.circular(0),
                            ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 17),
                            hintText: 'Model/Name of your vehicle',
                            suffixIcon: Icon(
                              Icons.account_box,
                              color: kPrimaryColor,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            // border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                          ),
                          textAlign: TextAlign.center,
                          controller: _nameController,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            // color: Colors.tealAccent,
                            //borderRadius: BorderRadius.circular(0),
                            ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 17),
                            hintText: 'Address where your vehicle present',
                            suffixIcon: Icon(
                              Icons.home,
                              color: kPrimaryColor,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            //border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: null,
                          controller: _addressController,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            // color: Colors.tealAccent,
                            //borderRadius: BorderRadius.circular(0),
                            ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 17),
                            hintText: 'Issue occured with your vehicle',
                            suffixIcon: Icon(
                              Icons.error,
                              color: kPrimaryColor,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple),
                            ),
                            //border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: null,
                          controller: _issueController,
                        ),
                      ),
                    ],
                  ),
                ),
                //TopRoundedContainer(color: Color(0xFFF6F7F9), child: null),
                SizedBox(
                  height: 200,
                )
              ],
            ))));
  }

  // ignore: unused_element
  _showDialog(String st, String et, String dt) {
    showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
            content: Container(
              padding: EdgeInsets.all(0),
              child: Text(
                  'Your Booking Schedule is :\n\nDate: $dt\nTime:$st - $et'),
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => DetailsScreen(),
                    //   ),
                    // );
                    schedule = BookingSchedule(
                      date: dt,
                      startTime: st,
                      endTime: et,
                    );
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomeScreen()));
                    Navigator.pushNamed(
                      context,
                      DetailsScreen.routeName,
                      arguments: ProductDetailsArguments(
                          product: tempProduct, schedule: schedule),
                    );
                  })
            ],
          );
        });
  }
}
