import 'package:bike_car_service/screens/mechanic_home/home_screen.dart';
import 'package:bike_car_service/screens/sign_in/sign_in_screen.dart';
import 'package:bike_car_service/user_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../size_config.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class Body extends StatelessWidget {
  String email;
  String name;
  String mobile;
  String address;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          MechanicProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "About My Store",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutMechanics()),
              )
            },
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Contact Admin",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              addMechanicEmail('');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SignInScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class AboutMechanics extends StatefulWidget {
  @override
  _AboutMechanicsState createState() => _AboutMechanicsState();
}

class _AboutMechanicsState extends State<AboutMechanics>
    with TickerProviderStateMixin {
  TextEditingController _textEditingController = TextEditingController();
  String description;
  var _data;
  List<Asset> images = [];

  AnimationController _controller;

  static const List<IconData> icons = const [
    Icons.edit,
    Icons.remove,
    Icons.camera
  ];

  Future<void> pickImages() async {
    List<Asset> resultList = [];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 50,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Rapid Service",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About My Store"),
        ),
        floatingActionButton: new Column(
          mainAxisSize: MainAxisSize.min,
          children: new List.generate(icons.length, (int index) {
            Widget child = new Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: new ScaleTransition(
                scale: new CurvedAnimation(
                  parent: _controller,
                  curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                      curve: Curves.easeOut),
                ),
                child: new FloatingActionButton(
                    heroTag: null,
                    backgroundColor: Color(0xFF4A3298),
                    mini: true,
                    child: new Icon(icons[index], color: Colors.white),
                    onPressed: () {
                      if (index == 0) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return new AlertDialog(
                                //contentPadding: const EdgeInsets.all(0.0),
                                content: Container(
                                  padding: EdgeInsets.all(0),
                                  child: TextField(
                                    controller: _textEditingController,
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter Description'),
                                  ),
                                ),
                                actions: <Widget>[
                                  // ignore: deprecated_member_use
                                  new FlatButton(
                                      child: const Text('CANCEL'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                  // ignore: deprecated_member_use
                                  new FlatButton(
                                      child: const Text('SUBMIT'),
                                      onPressed: () {
                                        description =
                                            _textEditingController.text.trim();
                                        addDetails(description);
                                      })
                                ],
                              );
                            });
                      } else if (index == 1) {
                        if (description != null) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return new AlertDialog(
                                  //contentPadding: const EdgeInsets.all(0.0),
                                  content: Container(
                                      padding: EdgeInsets.all(0),
                                      child: Text(
                                          "Sure You want to remove this description?")),
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
                                          // description =
                                          //     _textEditingController.text.trim();
                                          removeDetails();
                                        })
                                  ],
                                );
                              });
                        }
                      } else if (index == 2) {
                        pickImages();
                      }
                    }),
              ),
            );
            return child;
          }).toList()
            ..add(
              new FloatingActionButton(
                heroTag: null,
                backgroundColor: Color(0xFF4A3298),
                child: new AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    return new Transform(
                      transform: new Matrix4.rotationZ(
                          _controller.value * 0.5 * math.pi),
                      alignment: FractionalOffset.center,
                      child: new Icon(_controller.isDismissed
                          ? Icons.arrow_upward
                          : Icons.close),
                    );
                  },
                ),
                onPressed: () {
                  if (_controller.isDismissed) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                },
              ),
            ),
        ),
        body: Column(
          children: [
            // Container(
            //   padding: EdgeInsets.all(20),
            //   child: TextField(
            //     controller: _textEditingController,
            //     textInputAction: TextInputAction.newline,
            //     keyboardType: TextInputType.multiline,
            //     maxLines: null,
            //     decoration: InputDecoration(
            //         border: InputBorder.none, hintText: 'Enter Description'),
            //   ),
            // ),

            // Container(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       SocalCard(
            //           icon: "assets/icons/edit.svg",
            //           press: () {
            //             showDialog(
            //                 context: context,
            //                 builder: (_) {
            //                   return new AlertDialog(
            //                     //contentPadding: const EdgeInsets.all(0.0),
            //                     content: Container(
            //                       padding: EdgeInsets.all(0),
            //                       child: TextField(
            //                         controller: _textEditingController,
            //                         textInputAction: TextInputAction.newline,
            //                         keyboardType: TextInputType.multiline,
            //                         maxLines: null,
            //                         decoration: InputDecoration(
            //                             border: InputBorder.none,
            //                             hintText: 'Enter Description'),
            //                       ),
            //                     ),
            //                     actions: <Widget>[
            //                       // ignore: deprecated_member_use
            //                       new FlatButton(
            //                           child: const Text('CANCEL'),
            //                           onPressed: () {
            //                             Navigator.pop(context);
            //                           }),
            //                       // ignore: deprecated_member_use
            //                       new FlatButton(
            //                           child: const Text('SUBMIT'),
            //                           onPressed: () {
            //                             description =
            //                                 _textEditingController.text.trim();
            //                             addDetails(description);
            //                           })
            //                     ],
            //                   );
            //                 });
            //           }),
            //       SocalCard(
            //         icon: "assets/icons/remove.svg",
            //         press: () {
            //           if (description != null) {
            //             showDialog(
            //                 context: context,
            //                 builder: (_) {
            //                   return new AlertDialog(
            //                     //contentPadding: const EdgeInsets.all(0.0),
            //                     content: Container(
            //                         padding: EdgeInsets.all(0),
            //                         child: Text(
            //                             "Sure You want to remove this description?")),
            //                     actions: <Widget>[
            //                       // ignore: deprecated_member_use
            //                       new FlatButton(
            //                           child: const Text('NO'),
            //                           onPressed: () {
            //                             Navigator.pop(context);
            //                           }),
            //                       // ignore: deprecated_member_use
            //                       new FlatButton(
            //                           child: const Text('YES'),
            //                           onPressed: () {
            //                             // description =
            //                             //     _textEditingController.text.trim();
            //                             removeDetails();
            //                           })
            //                     ],
            //                   );
            //                 });
            //           } else {
            //             Fluttertoast.showToast(
            //                 msg: "First Add Something",
            //                 toastLength: Toast.LENGTH_SHORT,
            //                 gravity: ToastGravity.BOTTOM,
            //                 timeInSecForIosWeb: 1,
            //                 backgroundColor: Colors.blue,
            //                 textColor: Colors.white,
            //                 fontSize: 16.0);
            //           }
            //           // removeDetails();
            //         },
            //       ),
            //       SocalCard(
            //         icon: "assets/icons/Camera Icon.svg",
            //         press: () => {
            //           pickImages(),
            //         },
            //       )
            //     ],
            //   ),
            // ),

            FutureBuilder(
                future: _data,
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("Loading..."),
                    );
                  } else {
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(getProportionateScreenWidth(20)),
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: getProportionateScreenWidth(15),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF4A3298),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(color: Colors.white),
                          children: [
                            //TextSpan(text: description),
                            TextSpan(
                              text: description != null
                                  ? description
                                  : 'Click Edit Icon To Add About Your Store',
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(18),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }),

            // Align(
            //   alignment: Alignment.bottomLeft,
            //   child: SocalCard(
            //       icon: "assets/icons/remove.svg",
            //       press: () {
            //         if (description != null) {
            //           showDialog(
            //               context: context,
            //               builder: (_) {
            //                 return new AlertDialog(
            //                   //contentPadding: const EdgeInsets.all(0.0),
            //                   content: Container(
            //                       padding: EdgeInsets.all(0),
            //                       child: Text(
            //                           "Sure You want to remove this description?")),
            //                   actions: <Widget>[
            //                     // ignore: deprecated_member_use
            //                     new FlatButton(
            //                         child: const Text('NO'),
            //                         onPressed: () {
            //                           Navigator.pop(context);
            //                         }),
            //                     // ignore: deprecated_member_use
            //                     new FlatButton(
            //                         child: const Text('YES'),
            //                         onPressed: () {
            //                           // description =
            //                           //     _textEditingController.text.trim();
            //                           removeDetails();
            //                         })
            //                   ],
            //                 );
            //               });
            //         } else {
            //           Fluttertoast.showToast(
            //               msg: "First Add Something",
            //               toastLength: Toast.LENGTH_SHORT,
            //               gravity: ToastGravity.BOTTOM,
            //               timeInSecForIosWeb: 1,
            //               backgroundColor: Colors.blue,
            //               textColor: Colors.white,
            //               fontSize: 16.0);
            //         }
            //         // removeDetails();
            //       },
            //     ),
            // ),

            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: SocalCard(
            //       icon: "assets/icons/Camera Icon.svg",
            //       press: () => {
            //         pickImages(),
            //       },
            //     )
            // ),

            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: SocalCard(
            //       icon: "assets/icons/Camera Icon.svg",
            //       press: () => {
            //         pickImages(),
            //       },
            //     )
            // ),

            Expanded(
              child: GridView.count(
                padding: EdgeInsets.all(10),
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                scrollDirection: Axis.vertical,
                children: List.generate(images.length, (index) {
                  Asset asset = images[index];
                  return AssetThumb(
                    asset: asset,
                    width: 500,
                    height: 500,
                  );
                }),
              ),
            )
          ],
        ));
  }

  // Future<void> pickImages() async {
  //   // ignore: unused_local_variable
  //   List<Asset> resultList = [];

  //   try {
  //       resultList = await MultiImagePicker.pickImages(
  //       maxImages: 300,
  //       enableCamera: true,
  //       selectedAssets: images,
  //       materialOptions: MaterialOptions(
  //       actionBarTitle: "FlutterCorner.com",
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  //   return GridView.count(
  //                       crossAxisCount: 1,
  //                       children: List.generate(images.length, (index) {
  //                         Asset asset = images[index];
  //                         return AssetThumb(
  //                           asset: asset,
  //                           width: 300,
  //                           height: 300,
  //                         );
  //                       }),
  //                     );
  // }

  addDetails(String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('memail');

    CollectionReference signIn = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(email)
        .collection('AboutStore');

    return signIn.doc('about').set({'description': description}).then(
        (value) => //Navigator.pop(context));

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MechanicHomeScreen(),
                ),
                (route) => false));
                
  }

  Future<void> getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('memail');
    CollectionReference signIn = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(email)
        .collection('AboutStore');

    return signIn.get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['description'] != null) {
          setState(() {
            description = element.data()['description'];
            _textEditingController =
                new TextEditingController(text: description);
          });
          
        } 
      });
    });

    // var firestore = FirebaseFirestore.instance;
    // QuerySnapshot qn = (await firestore
    //     .collection("Mechanic_Sign_In").doc(email)
    //     .get()) as QuerySnapshot;

    // return qn;
  }

  removeDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('memail');
    CollectionReference signIn = FirebaseFirestore.instance
        .collection('Mechanic_Sign_In')
        .doc(email)
        .collection('AboutStore');

    return signIn
        .doc('about')
        .delete()
        .then((_) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MechanicHomeScreen(),
            ),
            (route) => false));
  }

  @override
  void initState() {
    _data = getDetails();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
  }
}
