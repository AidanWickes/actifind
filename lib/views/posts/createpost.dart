import 'package:actifind/services/database.dart';
import 'package:actifind/services/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
//time data
import 'package:intl/intl.dart';
//session id for API
import 'package:uuid/uuid.dart';
//views and services
import 'package:actifind/views/posts/address_search.dart';
import 'package:actifind/services/places_service.dart';

class CreatePostView extends StatefulWidget {
  @override
  _CreatePostViewState createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final _formKey = GlobalKey<FormBuilderState>();
  final _locationController = new TextEditingController();

  List sportOptions = [
    "Swimming",
    "Netball",
    "Football",
    "Cricket",
    "Basketball",
    "Tennis",
    "Running",
    "Rugby",
    "Hockey",
    "Other",
  ];

  List levelOptions = [
    "Beginner",
    "Amateur",
    "Semi-Pro",
    "Professional",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              print("tapped add button");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderDropdown(
                      name: 'sport',
                      decoration: InputDecoration(
                        labelText: 'Sport',
                      ),
                      // initialValue: '',
                      allowClear: true,
                      hint: Text('Select Sport'),
                      validator: FormBuilderValidators.required(context),
                      items: sportOptions
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text('$value'),
                              ))
                          .toList(),
                    ),
                    FormBuilderDropdown(
                      name: 'level',
                      decoration: InputDecoration(
                        labelText: 'Level',
                      ),
                      // initialValue: '',
                      allowClear: true,
                      hint: Text('Select Level'),
                      validator: FormBuilderValidators.required(context),
                      items: levelOptions
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text('$value'),
                              ))
                          .toList(),
                    ),
                    FormBuilderTextField(
                      name: 'title',
                      validator: FormBuilderValidators.required(context),
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                    ),
                    FormBuilderDateTimePicker(
                      name: 'datetime',
                      validator: FormBuilderValidators.required(context),
                      firstDate: DateTime.now(),
                      format: DateFormat('dd/MM/yyyy').add_jm(),
                      decoration: InputDecoration(
                        labelText: "Date & Time",
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
                    FormBuilderTextField(
                      name: 'location',
                      validator: FormBuilderValidators.required(context),
                      controller: _locationController,
                      readOnly: true,
                      onTap: () async {
                        // generate a new token here
                        final sessionToken = Uuid().v4();
                        final Suggestion result = await showSearch(
                          context: context,
                          delegate: AddressSearch(sessionToken),
                        );
                        // This will change the text displayed in the TextField
                        if (result != null) {
                          setState(() {
                            _locationController.text = result.description;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.location_pin),
                        labelText: "Location",
                      ),
                    ),
                    FormBuilderSlider(
                      name: 'group size',
                      onChanged: (value) {},
                      min: 2,
                      max: 20,
                      initialValue: 7,
                      divisions: 18,
                      activeColor: Colors.green,
                      inactiveColor: Colors.green[100],
                      decoration: InputDecoration(
                        labelText: 'Looking for # (Including yourself):',
                      ),
                    ),
                    FormBuilderSwitch(
                      name: "fees",
                      initialValue: true,
                      title: Text("Payment Required?"),
                    ),
                    FormBuilderTextField(
                      name: 'description',
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        //save form values
                        _formKey.currentState.save();

                        String username = await SharedPrefFunctions
                            .getUserNameSharedPreference();

                        //fix adding init username so not null

                        //print(username + "username");

                        Map<String, dynamic> postMap = {
                          "sport": _formKey.currentState.fields["sport"].value,
                          "level": _formKey.currentState.fields["level"].value,
                          "title": _formKey.currentState.fields["title"].value
                              .toString(),
                          "datetime":
                              _formKey.currentState.fields["datetime"].value,
                          "location": _formKey
                              .currentState.fields["location"].value
                              .toString(),
                          "groupsize":
                              _formKey.currentState.fields["group size"].value,
                          "fees": _formKey.currentState.fields["fees"].value,
                          "description": _formKey
                              .currentState.fields["description"].value
                              .toString(),
                          "members": [
                            username,
                          ],
                          "creator": username,
                        };

                        databaseMethods.uploadPost(postMap);
                        _formKey.currentState.reset();
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _formKey.currentState.reset();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
