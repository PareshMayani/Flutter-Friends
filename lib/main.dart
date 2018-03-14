import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

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

class FriendsPage extends StatefulWidget {
  FriendsPage({Key key}) : super(key: key);

  @override
  FriendsState createState() => new FriendsState();
}

class FriendsState extends State<FriendsPage> {

  bool _isProgressBarShown = true;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<FriendsModel> _listFriends;

  @override
  void initState() {
    super.initState();
    _fetchFriendsList();
  }

  @override
  Widget build(BuildContext context) {

    Widget widget;

    if(_isProgressBarShown) {
      widget = new Center(
          child: new Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: new CircularProgressIndicator()
          )
      );
    }else {
      //TODO: search how to stop ListView going infinite list
      widget =  new ListView.builder(
          padding: const EdgeInsets.all(0.0),

          itemBuilder: (context, i) {
            if (i.isOdd) return new Divider();
            return _buildRow(_listFriends[i]);
          }
      );
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Friends"),
        ),
        body: widget,
    );
  }

  Widget _buildRow(FriendsModel friendsModel) {

    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
      ),
      title: new Text(friendsModel.name,
        style: _biggerFont,
      ),
      subtitle: new Text(friendsModel.email),

      onTap: () {
        setState(() {
        });
      },
    );
  }

  _fetchFriendsList() async {

    _isProgressBarShown = true;
    var url = 'https://randomuser.me/api/?results=100&nat=us';
    var httpClient = new HttpClient();

    List<FriendsModel> listFriends = new List<FriendsModel>();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        Map data = JSON.decode(json);

        for (var res in data['results']) {
          var objName = res['name'];
          String name = objName['first'].toString() + " " +objName['last'].toString();

          var objImage = res['picture'];
          String profileUrl = objImage['large'].toString();
          FriendsModel friendsModel = new FriendsModel(name, res['email'], profileUrl);
          listFriends.add(friendsModel);
          print(friendsModel.profileImageUrl);
        }
      }
    } catch (exception) {
      print(exception.toString());
    }

    if (!mounted) return;

    setState(() {
      _listFriends = listFriends;
      _isProgressBarShown = false;
    });

  }
}


class FriendsModel {
  final String email;
  final String name;
  final String profileImageUrl;

  const FriendsModel(this.name, this.email, this.profileImageUrl);
}
