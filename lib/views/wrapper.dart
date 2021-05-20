import 'package:actifind/views/authenticate/authenticate.dart';
import 'package:actifind/views/groups/groups.dart';
import 'package:actifind/views/messages/messages.dart';
import 'package:actifind/views/profile/profile.dart';
import 'package:actifind/views/settings/settings.dart';
import 'package:actifind/views/posts/posts.dart';
import 'package:actifind/widgets/bottomNav.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CommonBottomNavigationBar(
        selectedIndex: _selectedIndex,
        navigatorKeys: _navigatorKeys,
        children: [
          PostsView(),
          GroupsView(),
          ProfileView(
            onExit: _exit,
          ),
          MessagesView(),
          SettingsView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.grey,
            ),
            label: "Home",
            activeIcon: Icon(
              Icons.home,
              color: Colors.green,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.grid_view,
              color: Colors.grey,
            ),
            label: "Groups",
            activeIcon: Icon(
              Icons.grid_view,
              color: Colors.green,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              color: Colors.grey,
            ),
            label: "Profile",
            activeIcon: Icon(
              Icons.account_circle,
              color: Colors.green,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.email,
              color: Colors.grey,
            ),
            label: "Messages",
            activeIcon: Icon(
              Icons.email,
              color: Colors.green,
            ),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.settings,
          //     color: Colors.grey,
          //   ),
          //   label: "Settings",
          //   activeIcon: Icon(
          //     Icons.settings,
          //     color: Colors.green,
          //   ),
          // ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  void _exit() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Authenticate()));
  }
}
