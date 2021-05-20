import 'package:actifind/services/auth.dart';
import 'package:actifind/services/database.dart';
import 'package:actifind/services/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  final Function onExit;
  ProfileView({this.onExit});
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String username;
  QuerySnapshot userSnapshot;

  Future<String> _getUser() async {
    username = await SharedPrefFunctions.getUserNameSharedPreference();
    databaseMethods.getUserByUsername(username).then((value) {
      setState(() {
        userSnapshot = value;
      });
    });
    return username;
  }

  Color hexToColor(String code) {
    //https://stackoverflow.com/a/50382196
    //print(code);
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: FutureBuilder<String>(
        future: _getUser(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
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
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {
                    authMethods
                        .resetPassword(userSnapshot.docs[0].data()["email"]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Sent password reset link to: " +
                            userSnapshot.docs[0].data()["email"]),
                      ),
                    );
                  },
                  child: Container(
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: widget.onExit,
                  child: Container(
                    child: Text(
                      "Log out",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
