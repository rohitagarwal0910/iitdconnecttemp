import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'dart:convert';

import './club_class.dart';
import 'package:iitd_connect/globals.dart';
import './club_info/club_info.dart';

class ClubCard extends StatefulWidget {
  final Club club;
  final Function _onAddPress;

  ClubCard(this.club, this._onAddPress, Key key) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClubCardState();
  }
}

class ClubCardState extends State<ClubCard> {
  Club _club;
  Function refresh;
  Function onPress;
  Color color;

  @override
  void initState() {
    super.initState();
    print("initState ${widget.club.clubName}");
    onPress = onButtonPress;
    _club = widget.club;
    refresh = widget._onAddPress;
    color = Colors.white;
  }

  Future onButtonPress() async {
    print("Subbing to Club ${_club.clubName}");
    color = Colors.grey;
    onPress = () {};
    setState(() {});
    final response = await http.post("$url/api/body/${_club.id}/subscribe",
        headers: {"authorization": "Bearer $token"});
    print(response.statusCode);
    if (response.statusCode == 200) {
      _club.isSubbed = !_club.isSubbed;
      if (_club.isSubbed) {
        otherClubs.remove(_club);
        subbedClubs.add(_club);
      } else {
        subbedClubs.remove(_club);
        otherClubs.add(_club);
      }
    }
    color = Colors.white;
    refresh();
  }

  // Future onSub() async {
  //   print("Subbing to club");
  //   color = Colors.grey;
  //   setState(() {});
  //   final response = await http.
  // }

  @override
  Widget build(BuildContext context) {
    print("Club Card received:::");
    print(_club.clubName);
    Icon _icon;
    String _toolTip;
    if (_club.isSubbed) {
      _icon = Icon(Icons.remove_circle);
      _toolTip = 'Unsubscribe';
    } else {
      _icon = Icon(Icons.add_circle_outline);
      _toolTip = 'Subscribe';
    }
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => ClubInfo(_club)));
        setState(() {});
        refresh();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo,
        ),
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        margin: EdgeInsets.symmetric(vertical: 0.2),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: AutoSizeText(
                  _club.clubName,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  maxLines: 1,
                ),
              ),
            ),
            IconButton(
              onPressed: onPress,
              icon: _icon,
              color: color,
              tooltip: _toolTip,
              padding: EdgeInsets.all(0),
            ),
          ],
        ),
      ),
    );
  }
}
