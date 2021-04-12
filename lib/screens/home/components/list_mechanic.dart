import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class ListPage extends StatefulWidget {
  static String routeName = "/list_mechanic";
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future _data;

  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("Mechanic_Sign_In").get();

    return qn.docs;
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                )));
  }

  @override
  void initState() {
    super.initState();

    _data = getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MechanicList"),
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
                          height: 20,
                          thickness: 0,
                        ),
                    shrinkWrap: false,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: ListTile(
                            leading: Image.asset(
                              "assets/images/app_logo.png",
                            ),
                            trailing: InkWell(
                              onTap: () => {},
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                            ),
                            title: Text.rich(
                              TextSpan(
                                style: TextStyle(color: Colors.white),
                                children: [
                                  TextSpan(
                                    text:
                                        snapshot.data[index].data()['shopname'],
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(21),
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
                                      text: snapshot.data[index]
                                          .data()['mobile']),
                                  TextSpan(
                                    text: '\n' +
                                        snapshot.data[index].data()['email'],
                                  ),
                                  TextSpan(
                                    text: '\n' +
                                        snapshot.data[index].data()['location'] != null ? '\n' +
                                        snapshot.data[index].data()['location'] : 'not found!!!',
                                  )
                                ],
                              ),
                            ),
                            onTap: () => {
                                  navigateToDetail(snapshot.data[index]),
                                }),

                        decoration: BoxDecoration(
                          color: Color(0xFF4A3298),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        // decoration: BoxDecoration(
                        //   gradient: LinearGradient(
                        //     begin: Alignment.centerLeft,
                        //     end: Alignment.centerRight,
                        //     colors: [
                        //       Colors.purple[900],
                        //       Colors.white,
                        //       // Colors.blue[100],
                        //       // Colors.green[500]
                        //     ],
                        //   ),
                        //   borderRadius: BorderRadius.circular(20),
                        // ),
                      );
                    });
              }
            }),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("List"),
        ),
        body: Container(
          child: Card(
            child: ListTile(
              title: Text(widget.post.data()['fname']),
              subtitle: Text(widget.post.data()['lname']),
            ),
          ),
        ));
  }
}
