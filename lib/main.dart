import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:iitd_connect/globals.dart';
import 'package:iitd_connect/user_class.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'error_alert.dart';
import 'home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'userlogin/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    // WidgetsFlutterBinding.ensureInitialized();
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool signedIn;
  bool start;

  void onlogin() {
    print("logged in");
    setState(() {
      signedIn = true;
    });
  }

  void onlogout() {
    print("logged out");
    setState(() {
      signedIn = false;
    });
  }

  Future checklogin() async {
    print("Checking login");
    final storage = new FlutterSecureStorage();
    String tempEmail = await storage.read(key: "email");
    String tempPass = await storage.read(key: "password");
    print("Saved email: $tempEmail");
    if (tempEmail == null) {
      print("Not logged in");
      return;
    } else {
      final loginresponse = await http.post("$url/api/login",
          body: {"email": tempEmail, "password": tempPass});
      if (loginresponse.statusCode == 200) {
        var parsedJson = json.decode(loginresponse.body);
        token = parsedJson["data"]["token"];
      } else {
        showErrorAlert(context, "Session Expired", "Please Login Again");
      }
      print("already logged in");
      signedIn = true;
      final response = await http
          .get("$url/api/user/me", headers: {"authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        // print(response.body);
        var parsedJson = json.decode(response.body);
        currentUser = User.fromJson(parsedJson["data"]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print("startup");
    start = true;
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
      },
    );

    _firebaseMessaging.getToken().then((token) {
      print("fcm token: $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            hintColor: Colors.white54,
            scaffoldBackgroundColor: Colors.indigo[900],
            canvasColor: Colors.indigo[700],
            brightness: Brightness.dark,
            cardColor: Colors.indigo,
            accentColor: Colors.lightBlueAccent),
        title: '$title',
        home: (start == true)
            ? FutureBuilder(
                future: checklogin(),
                builder: (context, snapshot) {
                  start = false;
                  if (snapshot.connectionState == ConnectionState.done) {
                    Widget home;
                    if (signedIn == true)
                      home = HomeScreen(onlogout: onlogout);
                    else
                      home = LoginPage(onlogin: onlogin);
                    return home;
                  }
                  return Scaffold(
                    backgroundColor: Colors.indigo[600],
                    body: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.w200),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "by DevClub",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : (signedIn == true)
                ? HomeScreen(onlogout: onlogout)
                : LoginPage(onlogin: onlogin));
  }
}
