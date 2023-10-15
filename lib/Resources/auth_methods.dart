import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/Models/user.dart' as model;
import 'package:instagram_clone/Resources/storage_methods.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    /* return model.User(followers: (snapshot.data() as Map<String,dynamic>)['followers']);
    that's a very hectic way so we will make a func in userModel */
    return model.User.fromSnap(snap);
  }

  Future<String> SignUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          // ignore: unnecessary_null_comparison
          file != null) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(cred.user!.uid);

        String PhotoUrl = await StorageMethods()
            .UploadImageToStorage("ProfilePics", file, false);

        // add user to our database
        model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            phototUrl: PhotoUrl);
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "SUCCESS";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // logging in User
  Future<String> LoginUser(
      {required String email, required String password}) async {
    String res = "Some error Occur";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "SUCCESS";
      } else {
        res = "Please Enter all the Fileds";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
