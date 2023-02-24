import 'package:flutter/material.dart';
import 'package:instaclone/screens/add_post_screen.dart';

const WebScreenSize = 600;

const homeScreenItems = [
  Center(
    child: Text('Feed'),
  ),
  Center(
    child: Text('search'),
  ),
  AddPostScreen(),
  Center(
    child: Text('NOTIF'),
  ),
  Center(
    child: Text('profile'),
  ),
];
