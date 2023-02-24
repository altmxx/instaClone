import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../model/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Upload Post function

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = 'Some Error occured';
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToFirebaseStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImage: profileImage,
          likes: []);

      _firestore.collection('posts').doc(postId).set(
            post.toMap(),
          );
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
