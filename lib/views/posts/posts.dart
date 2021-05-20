import 'package:actifind/services/database.dart';
import 'package:actifind/services/shared_prefs.dart';
import 'package:actifind/views/posts/createpost.dart';
import 'package:actifind/views/posts/viewpost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostsView extends StatefulWidget {
  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot postSnapshot;
  QuerySnapshot userSnapshot;
  String username;

  initiateList() {
    databaseMethods.getAllPosts().then((value) {
      setState(() {
        postSnapshot = value;
      });
    });

    databaseMethods.getUserByUsername(username).then((value) {
      setState(() {
        userSnapshot = value;
      });
    });
  }

  //make ternary op on loading function =>go to postList

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
                              "Beginner",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: Icon(
                                    Icons.schedule,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
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
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: Icon(
                                    Icons.location_pin,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    postSnapshot.docs[index].data()["location"],
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    for (var i = 0;
                                        i <
                                            postSnapshot.docs[index]
                                                .data()["members"]
                                                .length;
                                        i++)
                                      CircleAvatar(
                                        backgroundColor: Colors.red,
                                        child: Text(postSnapshot.docs[index]
                                            .data()["members"][i]
                                            .toString()[0]
                                            .toUpperCase()),
                                      ),
                                  ],
                                ),
                                if (postSnapshot.docs[index]
                                        .data()["creator"] !=
                                    username)
                                  ButtonBar(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          //get document id
                                          //print(postSnapshot.docs[index].id);

                                          List memberPosts = userSnapshot
                                              .docs[0]
                                              .data()["joinedposts"];
                                          List members = postSnapshot
                                              .docs[index]
                                              .data()["members"];

                                          if (memberPosts.contains(
                                              postSnapshot.docs[index].id)) {
                                            memberPosts.remove(
                                                postSnapshot.docs[index].id);
                                          } else {
                                            memberPosts.add(
                                                postSnapshot.docs[index].id);
                                          }

                                          if (members.contains(username)) {
                                            members.remove(username);
                                          } else if (members.length <
                                              postSnapshot.docs[index]
                                                  .data()["groupsize"]) {
                                            members.add(username);
                                          }

                                          if (postSnapshot.docs[index]
                                                  .data()["creator"] ==
                                              username) {}

                                          CollectionReference user =
                                              FirebaseFirestore.instance
                                                  .collection("users");

                                          user
                                              .doc(userSnapshot.docs[0].id)
                                              .update(
                                                  {"joinedposts": memberPosts})
                                              .then((value) =>
                                                  print("User Posts updated"))
                                              .catchError((e) => print(
                                                  "failed to update user: $e"));

                                          CollectionReference posts =
                                              FirebaseFirestore.instance
                                                  .collection("posts");

                                          posts
                                              .doc(postSnapshot.docs[index].id)
                                              .update({"members": members})
                                              .then((value) =>
                                                  print("Members updated"))
                                              .catchError((e) => print(
                                                  "failed to update members: $e"));

                                          _getData();
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        label: Text("JOIN"),
                                      ),
                                    ],
                                  )
                              ],
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
        title: Text("Posts"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print("tapped add button");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreatePostView()));
            },
          ),
        ],
      ),
      body: Container(
        //change to loading widget
        child: postList(),
      ),
    );
  }
}
