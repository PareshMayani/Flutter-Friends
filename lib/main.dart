import 'package:flutter/material.dart';
import 'package:flutter_friends/friends_list_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(

        primarySwatch: Colors.teal,
      ),
      home: new FriendsPage(),
    );
  }
}

