import 'package:actifind/services/auth.dart';
import 'package:actifind/services/database.dart';
import 'package:actifind/services/shared_prefs.dart';
import 'package:actifind/views/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  final Function toggle;
  SignInPage(this.toggle);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      snapshotUserInfo =
          await databaseMethods.getUserByUserEmail(_emailController.text);

      await SharedPrefFunctions.saveUserNameSharedPreference(
          snapshotUserInfo.docs[0].data()["name"]);

      authMethods
          .signInWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((val) {
        if (val != null) {
          SharedPrefFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Wrapper()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.green,
                            size: 200,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: 48,
                          color: Colors.green,
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.mail),
                                labelText: "Email",
                                enabledBorder: UnderlineInputBorder(),
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                labelText: "Password",
                                enabledBorder: UnderlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            authMethods.resetPassword(_emailController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Sent password reset link to: " +
                                    _emailController.text),
                              ),
                            );
                          },
                          child: Text(
                            "FORGOT PASSWORD",
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          signIn();
                        },
                        child: Text(
                          "SIGN IN",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                          ),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          widget.toggle();
                        },
                        icon: Icon(Icons.person_add),
                        label: Text("CREATE ACCOUNT"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
