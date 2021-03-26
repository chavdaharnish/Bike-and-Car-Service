import 'package:bike_car_service/constants.dart';
import 'package:bike_car_service/models/BookingSchedule.dart';
import 'package:bike_car_service/models/Product.dart';
import 'package:bike_car_service/screens/details/details_screen.dart';
import 'package:bike_car_service/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

import '../../../size_config.dart';

class DateTimePicker extends StatefulWidget {
  static String routeName = '/date';
  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
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
        _showDialog(_startTimeController.text, _endTimeController.text,
            _dateController.text);
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());
    _startTimeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    _endTimeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour + 1, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dateTime = DateFormat.yMd().format(DateTime.now());
    final ProductDetailsArguments args =
        ModalRoute.of(context).settings.arguments;
    tempProduct = args.product;
    return Scaffold(
      appBar: AppBar(
        title: Text('Date time picker'),
      ),
      body: Container(
        // width: _width,
        // height: _height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: getProportionateScreenWidth(50)),
                Text(
                  'Choose Date',
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextFormField(
                      style: TextStyle(fontSize: 40, color: Colors.white),
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      onSaved: (String val) {
                        _setDate = val;
                      },
                      decoration: InputDecoration(
                          disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          // labelText: 'Time',
                          contentPadding: EdgeInsets.only(top: 0.0)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenWidth(30)),
            Text(
              'Choose The Time That Suits You Best',
            ),
            SizedBox(height: getProportionateScreenWidth(20)),
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    _selectStartTime(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    height: 50,
                    width: 140,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                      style: TextStyle(fontSize: 10, color: Colors.white),
                      textAlign: TextAlign.center,
                      onSaved: (String val) {
                        _setStartTime = val;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _startTimeController,
                      // decoration: InputDecoration(
                      //     disabledBorder: UnderlineInputBorder(
                      //         borderSide: BorderSide.none),
                      //     // labelText: 'Time',
                      //     contentPadding: EdgeInsets.only(top: 0.0)),
                    ),
                  ),
                ),

                Text(
                  'To',
                ),

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
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                      style: TextStyle(fontSize: 10, color: Colors.white),
                      textAlign: TextAlign.center,
                      onSaved: (String val) {
                        _setEndTime = val;
                        // _showDialog(_setStartTime,_setEndTime, _setDate);
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _endTimeController,
                      // decoration: InputDecoration(
                      //     disabledBorder: UnderlineInputBorder(
                      //         borderSide: BorderSide.none),
                      //     // labelText: 'Time',
                      //     contentPadding: EdgeInsets.only(top: 0.0)),
                    ),
                  ),
                ),

                //   InkWell(
                //   onTap: () {
                //     _selectEndTime(context);
                //   },
                //   child: Container(
                //     margin: EdgeInsets.all(5),
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(20)),
                //     child: TextFormField(
                //       style: TextStyle(fontSize: 10,color: Colors.white),
                //       textAlign: TextAlign.center,
                //       onSaved: (String val) {
                //         _setTime = val;
                //       },
                //       enabled: false,
                //       keyboardType: TextInputType.text,
                //       controller: _timeController,
                //       decoration: InputDecoration(
                //           disabledBorder:
                //               UnderlineInputBorder(borderSide: BorderSide.none),
                //           // labelText: 'Time',
                //           contentPadding: EdgeInsets.only(top: 0.0)),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
