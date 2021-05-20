import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getAllPosts() async {
    return await FirebaseFirestore.instance.collection("posts").get();
  }

  // getUserCreatedPosts(String username) async {
  //   return await FirebaseFirestore.instance
  //       .collection("posts")
  //       .where("creator", isEqualTo: username)
  //       .get();
  // }

  getUserJoinedPosts(String username) async {
    return await FirebaseFirestore.instance
        .collection("posts")
        .where("members", arrayContains: username)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  uploadPost(postMap) {
    FirebaseFirestore.instance.collection("posts").add(postMap).catchError((e) {
      print(e.toString());
    });
  }
}
