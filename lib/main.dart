import 'package:actifind/services/shared_prefs.dart';
import 'package:actifind/views/authenticate/authenticate.dart';
import 'package:flutter/material.dart';

//Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() {
  SharedPrefFunctions.setMockInitialValues();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Set default _init and _error state to false
  bool _init = false, _error = false;

  //Define an async function to init FlutterFire
  void initializeFlutterFire() async {
    try {
      //wait for Firebase to init and set _init to true
      await Firebase.initializeApp();
      setState(() {
        _init = true;
      });
    } catch (e) {
      //Set _error state to true if init fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //show error message if init failed
    if (_error) {
      return Container(
        child: Center(
          child: Text(
            _error.toString(),
          ),
        ),
      );
    }

    //show loader until initialised
    if (!_init) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Authenticate(),
    );
  }
}
