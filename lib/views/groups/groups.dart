import 'package:actifind/services/database.dart';
import 'package:actifind/services/shared_prefs.dart';
import 'package:actifind/views/posts/viewpost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupsView extends StatefulWidget {
  @override
  _GroupsViewState createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String username;
  QuerySnapshot postSnapshot;

  Future<String> _getPosts() async {
    username = await SharedPrefFunctions.getUserNameSharedPreference();
    //print(username);
    databaseMethods.getUserJoinedPosts(username).then((value) {
      setState(() {
        postSnapshot = value;
      });
    });
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Groups"),
        ),
        body: FutureBuilder<String>(
          future: _getPosts(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                ListView.builder(
                    itemCount: postSnapshot.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewPostView()));
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                    postSnapshot.docs[index].data()["title"]),
                                subtitle: Text(
                                  DateFormat('dd/MM/yyyy hh:mm a').format(
                                      postSnapshot.docs[index]
                                          .data()["datetime"]
                                          .toDate()),
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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
        ));
  }
}
