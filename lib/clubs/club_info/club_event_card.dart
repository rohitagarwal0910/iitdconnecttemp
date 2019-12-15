import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../events/event_class.dart';
import '../../events/event_info/event_info_screen.dart';
import '../../events/event_card_contents/event_time.dart';
import '../../events/event_card_contents/event_venue.dart';
import '../../events/event_info/star_button.dart';

class ClubEventCard extends StatelessWidget {
  final Event _event;
  final Function reload;

  ClubEventCard(this._event, this.reload, Key key) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventInfo(_event.eventid, (){}, showButton: false,)),
        ).then((value) {
          reload();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[Expanded(child:
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: AutoSizeText(
                _event.eventName,
                style: TextStyle(fontSize: 23, color: Colors.white),
                minFontSize: 18,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),),IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.calendar_today),
                  color: Colors.white,
                  tooltip: 'Add to Calendar',
                ),
                StarButton(_event, (){}),],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: EventVenue(_event.venue),
                ),
                Expanded(
                  child: EventTime(_event.startsAt, _event.endsAt),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
