import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl,
        });

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
}
