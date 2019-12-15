import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iitd_connect/globals.dart';
import 'package:iitd_connect/user_class.dart';
import 'dart:async';
import 'dart:convert';

import './my_events_list.dart';
import './add_event_screen.dart';
import '../events/event_class.dart';
import 'admins_screen/admin_screen.dart';

class ManageTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ManageTabState();
  }
}

class _ManageTabState extends State<ManageTab> {
  // List<Event> events;
  UClub club = currentUser.adminof[0];
  // UClub club;
  int state = 1;

  void _refresh() => setState(() {});

  Future<List<Event>> getClubEvents(String id) async {
    print("getting club events");
    print(id);
    final response = await http.get("$url/api/events/?body=$id",
        headers: {"authorization": "Bearer $token"});
    print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      List<Event> tevents = List<Event>();
      if (parsedJson["message"] != "Events Found") {
        return tevents;
      } else {
        for (int i = 0; i < parsedJson["data"]["events"].length; i++) {
          Event ev = Event.fromJson(parsedJson["data"]["events"][i]);
          if (ev.endsAt.isAfter(DateTime.now())) tevents.add(ev);
        }
        tevents.sort((a, b) {
          return a.startsAt.compareTo(b.startsAt);
        });
        return tevents;
      }
    } else {
      throw Exception('Failed to load events');
    }
  }

  List<DropdownMenuItem<UClub>> clubList = [];

  void makeList() {
    clubList = [];
    for (int i = 0; i < currentUser.adminof.length; i++) {
      clubList.add(
        DropdownMenuItem(
          value: currentUser.adminof[i],
          child: AutoSizeText(
            currentUser.adminof[i].clubName,
            style: TextStyle(
              color: Colors.white,
            ),
            maxLines: 1,
          ),
        ),
      );
    }
  }

  Widget viewAdminButton() {
    if (currentUser.isSuperAdmin) {
      return FlatButton(
        color: Colors.indigo[400],
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminScreen()));
        },
        child: Text(
          'VIEW ADMINS',
          style: TextStyle(color: Colors.white),
        ),
      );
    } else
      return Container(
        height: 0,
        width: 0,
      );
  }

  @override
  Widget build(BuildContext context) {
    makeList();
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      key: PageStorageKey('manageTab'),
      children: <Widget>[
        viewAdminButton(),
        // (currentUser.isSuperAdmin)
        //     ? FlatButton(
        //         color: Colors.indigo[400],
        //         onPressed: () {
        //           Navigator.push(context,
        //               MaterialPageRoute(builder: (context) => AdminScreen()));
        //         },
        //         child: Text(
        //           'VIEW ADMINS',
        //           style: TextStyle(color: Colors.white),
        //         ),
        //       )
        //     : null,
        FlatButton(
          color: Colors.indigo[400],
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEvent()),
            ).then((value) {
              setState(() {});
            });
          },
          child: Text(
            'ADD NEW EVENT',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'YOUR CLUB EVENTS',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    letterSpacing: 4),
              ),
              Container(
                height: 3,
                width: 60,
                margin: EdgeInsets.only(top: 10),
                color: Colors.blue,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: DropdownButtonFormField<UClub>(
            value: club,
            items: clubList,
            decoration: InputDecoration(
              labelText: "Select Club",
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              filled: true,
              fillColor: Color(0x0AAAAAAA),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white30)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.white)),
            ),
            onChanged: (value) async {
              if (club != value) {
                club = value;
                // setState(
                //   () {
                //     state = 0;
                //   },
                // );
                // await getClubEvents(club.id);
                setState(
                  () {
                    // state = 1;
                  },
                );
              }
            },
          ),
        ),
        FutureBuilder(
          future: getClubEvents(club.id),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              return MyEventsList(snapshot.data, _refresh);
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Some Error Occured",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              );
            }

            return Container(
                margin: EdgeInsets.all(20),
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )));
          },
        ),
      ],
    );
  }
}
