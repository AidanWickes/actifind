import 'dart:math';

import 'package:actifind/services/auth.dart';
import 'package:actifind/services/database.dart';
import 'package:actifind/services/shared_prefs.dart';
import 'package:actifind/views/wrapper.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function toggle;
  RegisterPage(this.toggle);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordConfirmController =
      new TextEditingController();

  List colors = ["#FF0000", "#00FF00", "#0000FF"];
  Random random = new Random();
  int index = 0;

  register() async {
    if (formKey.currentState.validate()) {
      Map<String, String> userMap = {
        "name": _usernameController.text,
        "email": _emailController.text,
        "color": colors[index],
        "initial": '${_usernameController.text[0].toUpperCase()}',
      };

      setState(() {
        isLoading = true;
        index = random.nextInt(3);
      });

      await SharedPrefFunctions.saveUserNameSharedPreference(
          _usernameController.text);
      print(SharedPrefFunctions.getUserNameSharedPreference());
      await SharedPrefFunctions.saveUserEmailSharedPreference(
          _emailController.text);

      authMethods
          .signUpWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((value) {
        databaseMethods.uploadUserInfo(userMap);
        SharedPrefFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Wrapper()));
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
                          decoration: BoxDecoration(
                            color: Colors.green,
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
                              controller: _usernameController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.person),
                                labelText: "Username",
                                enabledBorder: UnderlineInputBorder(),
                              ),
                            ),
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
                            TextFormField(
                              controller: _passwordConfirmController,
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
                      ElevatedButton(
                        onPressed: () {
                          register();
                        },
                        child: Text(
                          "CREATE ACCOUNT",
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
                        icon: Icon(Icons.person),
                        label: Text("SIGN IN"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
