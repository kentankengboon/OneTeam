import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:oneteam/project1.dart';
import 'package:oneteam/register.dart';
import 'package:oneteam/teampage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io';  /////////////

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FirebaseMessaging _fcm = FirebaseMessaging(); //////////////_1


  String uidToCheck;
  // String projectNotify;/////////////////////_2

  @override
  void initState() {
    super.initState();

/*//////////////////////_2
    _fcm.configure(
      onResume: (message) async {
        setState(() {
          projectNotify = message ["data"]["title"];
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Project1()));
        });

      }
    );
*////////////////////////_2

    if(Platform.isIOS) { //////////////_1
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        if (user != null) {
          uidToCheck = user.uid;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TeamPage()));
        } else {
          //print (user.uid);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register()));
        }
      });
    });

    //_messaging.getToken().then((token) {print (token);});
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}