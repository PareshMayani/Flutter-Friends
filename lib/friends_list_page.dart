import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_friends/model/FriendsModel.dart';
import 'package:http/http.dart' as http;

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

    if (_isProgressBarShown) {
      widget = new Center(
          child: new Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: new CircularProgressIndicator()));
    } else {
      widget = new ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: _listFriends.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                _buildRow(_listFriends[i]),
                if (i.isOdd) Divider(),
              ],
            );
          });
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
      title: new Text(
        friendsModel.name,
        style: _biggerFont,
      ),
      subtitle: new Text(friendsModel.email),
      onTap: () {
        setState(() {});
      },
    );
  }

  _fetchFriendsList() async {
    _isProgressBarShown = true;
    var url = 'https://randomuser.me/api/?results=100&nat=us';
    List<FriendsModel> listFriends = new List<FriendsModel>();
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (var res in data['results']) {
          var objName = res['name'];
          String name =
              objName['first'].toString() + " " + objName['last'].toString();

          var objImage = res['picture'];
          String profileUrl = objImage['large'].toString();
          FriendsModel friendsModel =
              new FriendsModel(name, res['email'], profileUrl);
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



