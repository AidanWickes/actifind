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
  QuerySnapshot postSnapshot;
  String username;

  initiateList() {
    databaseMethods.getUserJoinedPosts(username).then((value) {
      postSnapshot = value;
    });
  }

  Widget postList() {
    return postSnapshot != null
        ? RefreshIndicator(
            onRefresh: _getData,
            child: ListView.builder(
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
                            title:
                                Text(postSnapshot.docs[index].data()["title"]),
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
          )
        : Container(
            child: Center(
              child: Text(
                "No Posts Found",
              ),
            ),
          );
  }

  Future<void> _getData() async {
    setState(() {
//set loading bool to true
      initiateList();
//set loading bool to false when done
    });
  }

  Future<void> _getUser() async {
    username = await SharedPrefFunctions.getUserNameSharedPreference();
  }

  @override
  initState() {
    super.initState();
    initiateList();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Groups"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print("tapped add button");
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        //change to loading widget
        child: Column(
          children: [
            Text(
              "Joined Groups",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            postList(),
          ],
        ),
      ),
    );
  }
}
