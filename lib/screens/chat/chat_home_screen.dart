// static String routeName = '/chatpage';

import 'package:bike_car_service/screens/chat/components/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:bike_car_service/components/coustom_bottom_nav_bar.dart';
import 'package:bike_car_service/enums.dart';


class ChatHomeScreen extends StatelessWidget {
  static String routeName = '/chatpage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Page"),
      ),
      body: ChatPage(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.message),
    );
  }
}
