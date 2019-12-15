import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:iitd_connect/globals.dart';

import './events/events_tab.dart';
import './clubs/clubs_tab.dart';
import './manage/manage_tab.dart';
import 'userlogin/profile_icon.dart';

class HomeScreen extends StatefulWidget {
  final Function onlogout;

  HomeScreen({this.onlogout});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController _controller;
  int _selectedTab = 1;
  List<Widget> _tabs;
  List<BottomNavigationBarItem> _navBarItems;

  Widget appBar;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    appBar = GradientAppBar(
      elevation: 10,
      title: Text('$title'),
      backgroundColorStart: Colors.indigo,
      backgroundColorEnd: Colors.cyan,
      actions: <Widget>[ProfileIcon(widget.onlogout)],
      bottom: TabBar(
        indicatorColor: Colors.white70,
        controller: _controller,
        tabs: [
          Tab(text: 'TODAY'),
          Tab(text: 'TOMORROW'),
          Tab(text: 'UPCOMING'),
        ],
      ),
    );
    _tabs = [ClubsTab(), EventsTab(_controller)];
    _navBarItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.list),
        title: Text('Clubs'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.event),
        title: Text('Events'),
      ),
    ];
    if (currentUser.isAdmin) {
      _tabs.add(ManageTab());
      _navBarItems.add(BottomNavigationBarItem(
        icon: Icon(Icons.edit),
        title: Text('Manage'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar,
      body: _tabs[_selectedTab],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
        ),
        child: BottomNavigationBar(
          elevation: 1,
          backgroundColor: Colors.indigo[400].withOpacity(1),
          selectedItemColor: Colors.lightBlueAccent[100],
          unselectedItemColor: Colors.white.withOpacity(0.6),
          currentIndex: _selectedTab,
          onTap: (int index) {
            setState(() {
              _selectedTab = index;
              if (index == 1)
                appBar = GradientAppBar(
                  title: Text('$title'),
                  backgroundColorStart: Colors.indigo,
                  backgroundColorEnd: Colors.cyan,
                  elevation: 10,
                  actions: <Widget>[ProfileIcon(widget.onlogout)],
                  bottom: TabBar(
                    indicatorColor: Colors.white70,
                    controller: _controller,
                    tabs: [
                      Tab(text: 'TODAY'),
                      Tab(text: 'TOMORROW'),
                      Tab(text: 'UPCOMING'),
                    ],
                  ),
                );
              else
                appBar = GradientAppBar(
                  title: Text('$title'),
                  elevation: 10,
                  backgroundColorStart: Colors.indigo,
                  backgroundColorEnd: Colors.cyan,
                  actions: <Widget>[ProfileIcon(widget.onlogout)],
                );
            });
          },
          items: _navBarItems,
        ),
      ),
    );
  }
}
