import 'package:actifind/services/auth.dart';
import 'package:actifind/services/database.dart';
import 'package:actifind/services/shared_prefs.dart';
import 'package:actifind/views/authenticate/authenticate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  final Function onExit;
  ProfileView({this.onExit});
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String username;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot userSnapshot;

  _getUserDetails() {
    //print(username);
    databaseMethods.getUserByUsername(username).then((value) {
      setState(() {
        userSnapshot = value;
      });
    });
  }

  Future<void> _getUser() async {
    username = await SharedPrefFunctions.getUserNameSharedPreference();
  }

  @override
  initState() {
    super.initState();
    _getUserDetails();
    _getUser();
  }

  Color hexToColor(String code) {
    //https://stackoverflow.com/a/50382196
    //print(code);
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Widget user() {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor:
                      hexToColor(userSnapshot.docs[0].data()["color"]),
                  child: Text(
                    userSnapshot.docs[0].data()["initial"],
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Text(userSnapshot.docs[0].data()["name"]),
              Text(userSnapshot.docs[0].data()["email"]),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width - 50,
          height: MediaQuery.of(context).size.height / 3,
          color: Colors.black,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              authMethods.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Authenticate(),
                  ),
                  (route) => false);
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => Authenticate()));
            },
          ),
        ],
      ),
      body: Container(
        child: Center(child: user()),
      ),
    );
  }
}
