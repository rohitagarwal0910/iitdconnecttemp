import 'package:flutter/material.dart';
import 'package:iitd_connect/globals.dart';

import './event_class.dart';
import './events_list.dart';

class EventsPage extends StatefulWidget {
  final String _title;

  EventsPage(this._title);

  @override
  State<StatefulWidget> createState() {
    return EventsPageState();
  }
}

class EventsPageState extends State<EventsPage> {
  List<List<Event>> _events;
  String _title;
  Function reload;

  @override
  void initState() {
    super.initState();
    _title = widget._title;
    switch (_title) {
      case "TODAY":
        _events = todayEvents;
        break;
      case "TOMORROW":
        _events = tomorrowEvents;
        break;
      case "UPCOMING":
        _events = upcomingEvents;
        break;
      default:
    }
  }

  void reorderList() {
    setState(
      () {
        switch (_title) {
          case "TODAY":
            _events = todayEvents;
            break;
          case "TOMORROW":
            _events = tomorrowEvents;
            break;
          case "UPCOMING":
            _events = upcomingEvents;
            break;
          default:
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: PageStorageKey(_title),
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
          ),
          EventsList(
              _events[0],
              'STARRED EVENTS',
              // _title,
              // starEvent,
              reorderList),
          EventsList(
              _events[1],
              'FROM SUBSCRIBTIONS',
              // _title,
              // starEvent,
              reorderList),
          EventsList(
              _events[2],
              'OTHER EVENTS',
              // _title,
              // starEvent,
              reorderList),
          Container(
            height: 5,
          ),
        ],
        // SingleChildScrollView(
        //   key: PageStorageKey(_title),
        //   physics: AlwaysScrollableScrollPhysics(),
        //   child: Column(
        //     children: <Widget>[
        //       Text('STARRED EVENTS'),
        //       EventsList(_events[0], 'STARRED', starEvent),
        //       Text('FROM SUBSCRIBED CLUBS'),
        //       EventsList(_events[1], 'SUBBED', starEvent),
        //       Text('OTHER EVENTS'),
        //       EventsList(_events[2], 'OTHER', starEvent),
        //     ],
        //   ),
      ),
    );
  }
}
