import 'package:flutter/material.dart';
import 'package:pawfectmatch/screens/matching_screen.dart';
import 'package:pawfectmatch/screens/userprofile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int myIndex = 0;
  List<Widget> widgetList = const [
    MatchingScreen(),
    Text("CHAT SCREEN"),
    Text("APPOINTMENT SCREEN"),
    UserProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: widgetList[myIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                myIndex = index;
              });
            },
            currentIndex: myIndex,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today), label: 'Appointments'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), label: 'Profile'),
            ]));
  }
}
