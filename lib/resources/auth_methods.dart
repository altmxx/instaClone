import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/model/user.dart' as model;
import 'package:instaclone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    log((snap.data() as Map<String, dynamic>).toString());
    return model.User.fromMap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some Error Occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //Register User
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        log(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToFirebaseStorage('profilePics', file, false);

        //add user to firestore database

        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          username: username,
          bio: bio,
          following: [],
          followers: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toMap(),
            );

        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The Email is badly formatted';
      }
      if (err.code == 'email-already-in-use') {
        res = 'Email is already in use';
      }
      if (err.code == 'weak-password') {
        res = 'The password should be atleast 6 characters';
      }
    } catch (e) {
      res = e.toString();
    }
    log(res);
    return res;
  }

  //Loging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success';
      } else {
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'User does not exist';
      }
      if (e.code == 'wrong-password') {
        res = 'Incorrect enmail or password';
      }
    } catch (e) {
      res = e.toString();
    }
    log(res);
    return res;
  }
}
