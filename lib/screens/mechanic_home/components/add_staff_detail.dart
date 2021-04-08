import 'package:bike_car_service/screens/mechanic_home/home_screen.dart';
import 'package:bike_car_service/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../size_config.dart';
import '../../../constants.dart';
import 'package:bike_car_service/components/custom_surfix_icon.dart';
import 'package:bike_car_service/components/form_error.dart';

class AddandRemoveStaff extends StatefulWidget {
  static String routeName = "/addremovestaff";
  @override
  _AddandRemoveStaffState createState() => _AddandRemoveStaffState();
}

class _AddandRemoveStaffState extends State<AddandRemoveStaff> {
  final _formKey = GlobalKey<FormState>();
  String name;
  String mobile;
  final List<String> errors = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Staff"),
      ),
      body: ListOfStaff(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF4A3298),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => name = newValue,
      controller: _nameController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Full Name",
        hintText: "Full Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildMobileFormField() {
    return TextFormField(
      //obscureText: true,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => mobile = newValue,
      controller: _mobileController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kMobileNullError);
        } else if (value.length == 10) {
          removeError(error: kMobileLengthNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kMobileNullError);
          return "";
        } else if (value.length != 10) {
          addError(error: kMobileLengthNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mobile",
        hintText: "Mobile",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Call.svg"),
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Staff Member'),
            content: Form(
                key: _formKey,
                child: Column(children: [
                  buildNameFormField(),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  buildMobileFormField(),
                  SizedBox(height: getProportionateScreenHeight(10)),
                ])),
            scrollable: true,
            actions: <Widget>[
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(5)),
              // ignore: deprecated_member_use
              new FlatButton(
                child: new Text('Add'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    name = _nameController.text.trim();
                    mobile = _mobileController.text.trim();

                    if (name != null && mobile != null) {
                      addStaff();
                    }
                  }
                },
              )
            ],
          );
        });
  }

  Future<void> addStaff() async {
    CollectionReference signIn =
        FirebaseFirestore.instance.collection('Mechanic_Sign_In');

    var email;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('memail');

    return signIn.doc(email).collection('StaffInfo').doc(name).set(
      {'name': name, 'mobile': mobile},
    ).then((value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MechanicHomeScreen(),
        ),
        ModalRoute.withName("/mechanichome")));
  }

  @override
  void dispose() {
    super.dispose();
    _mobileController.dispose();
    _nameController.dispose();
  }
}

class ListOfStaff extends StatefulWidget {
  @override
  _ListOfStaffState createState() => _ListOfStaffState();
}

class _ListOfStaffState extends State<ListOfStaff> {
  var data = [];

  @override
  void initState() {
    addStaff();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          //SizedBox(height: getProportionateScreenWidth(10)),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: data
                  .map(
                    (element) => SpecialOfferCard(
                      name: element['name'],
                      mobile: element['mobile'],
                      press: () async {
                        String url = "tel:" + element['mobile'];
                        //print('urllllllllll..........'+element['mobile']);
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    )));
  }

  Future addStaff() async {
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
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(5)),
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
                      horizontal: getProportionateScreenHeight(15.0),
                      vertical: getProportionateScreenWidth(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: getProportionateScreenWidth(290),
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
                                TextSpan(text: "$mobile"),
                              ],
                            ),
                          ),
                        ),
                        // DropdownButton(
                        //   value: _selectedCompany,
                        //   items: _dropdownMenuItems,
                        //   onChanged: onChangeDropdownItem,
                        // ),
                        //SizedBox(width: getProportionateScreenWidth(0),),
                        // InkWell(
                        //   child: Icon(Icons.more_vert, color: Colors.white,),
                        //   onTap: (){

                        //   },
                        // ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
