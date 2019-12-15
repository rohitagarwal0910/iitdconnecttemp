import 'package:flutter/material.dart';
import 'package:iitd_connect/globals.dart';

import './club_class.dart';
import './club_card.dart';

class ClubsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClubsScreenState();
  }
}

class ClubsScreenState extends State<ClubsScreen> {
  refresh() {
    print("refreshing club list");
    // if (widget.l == 0)
    //   clubs = subbedClubs;
    // else if (widget.l == 1) clubs = otherClubs;
    // clubs.forEach((f) => print(f.clubName));
    subbedClubs.sort((a, b) {
      return a.clubName.toLowerCase().compareTo(b.clubName.toLowerCase());
    });
    otherClubs.sort((a, b) {
      return a.clubName.toLowerCase().compareTo(b.clubName.toLowerCase());
    });
    print("Subbed Clubs:");
    subbedClubs.forEach((f) => print(f.clubName));
    print("Other Clubs:");
    otherClubs.forEach((f) => print(f.clubName));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("ClubScreenState build called");
    return ListView(
      key: PageStorageKey('clubsTab'),
      physics: AlwaysScrollableScrollPhysics(),
      children: <Widget>[
        Container(
          height: 5,
        ),
        clubsList(
          'SUBSCRIBED CLUBS',
          subbedClubs,
        ),
        clubsList('OTHER CLUBS', otherClubs),
        Container(
          height: 5,
        ),
      ],
    );
  }

  List<ClubCard> makeClubCardList(List<Club> clubs) {
    print("makeClubCardList received:::");
    clubs.forEach((f) => print(f.clubName));
    List<ClubCard> toReturn = List<ClubCard>();
    for (int i = 0; i < clubs.length; i++) {
      toReturn.add(new ClubCard(clubs[i], refresh, ValueKey(clubs[i].id)));
      print("adding + ${clubs[i].clubName}");
    }
    print("To return:");
    toReturn.forEach((f) => print(f.club.clubName));
    return toReturn;
  }

  Widget clubsList(String listTitle, List<Club> clubs) {
    print("clublist method called with title : $listTitle");
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            listTitle,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                letterSpacing: 4),
          ),
          Container(
            height: 3,
            width: 60,
            margin: EdgeInsets.only(top: 10, bottom: 20),
            color: Colors.blue,
          ),
          (clubs.length == 0)
              ? Center(
                  // padding: EdgeInsets.all(20),
                  child: Text(
                    "No Clubs",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: makeClubCardList(clubs),
                    // clubs
                    //     .map((element) => ClubCard(element, refresh))
                    //     .toList(),
                  ),
                ),
        ],
      ),
    );
  }
}
