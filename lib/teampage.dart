//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneteam/register.dart';
import 'package:oneteam/services/auth.dart';
import 'package:oneteam/services/overflowbutton.dart';
import 'package:oneteam/teamproject.dart';
import 'package:oneteam/users.dart';
import 'model/user.dart';
import 'settings.dart';
import 'createproject.dart';

class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

AuthMethods authmethods = new AuthMethods();

class _TeamPageState extends State<TeamPage> {

  String uidToCheck;
  String userName;
  String userEmail;
  //List tryPrint;
  //String oldList;

  @override
  void initState() {
    //super.initState();
    FirebaseAuth.instance.currentUser().then((user) {setState(() {
      if (user != null) {
        uidToCheck = user.uid;

        Firestore.instance.collection("users").document(uidToCheck).get().then((value) {
          //print(value.data['name']);
          if (mounted)
            setState(() {
              userName = value.data['name'];
              userEmail = value.data['email'];
              //existingImageUrl = value.data['image'];
            });
          //return value.data['name'];
        });
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PageViewDemo()));

      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register()));
      }
    });
    });
  }

  void overflowSelected(String choice) {

    if (choice == OverflowBtn.usersClick) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Users()));
    }

    if (choice == OverflowBtn.settingsClick) {
      final userData = User(
        userId: uidToCheck,
        userEmail: userEmail,
        userName: userName,
      );

      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettings(userInfo: userData)));
    }

    if (choice == OverflowBtn.logoutClick) {
      authmethods.signout();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register()));
    }
  }

  @override
  Widget build(BuildContext context) {


/*
//////////////////////////////////////
  // below illustrate how to write incremental msg to data into single field base and then print it out in a list

    Firestore.instance.collection("users").document("9CFqd3B7t8cSVDq7HMX7utS0Sb62").updateData({
      "status" : FieldValue.arrayUnion(["testing 4"])
    });

    Firestore.instance
        .collection("users")
        .document("9CFqd3B7t8cSVDq7HMX7utS0Sb62")
        .get()
        .then((value) {
      if (value.data != null) {
          //print (value.data);

          if (value.data['status'] != null) {
            String status = value.data['status'].toString();
            //print (status);
            //tryPrint = status;

            List statusList = value.data['status'];
            int slength = statusList.length;
            print (slength);
            print (statusList.sublist(0,1).single);
            print (statusList.sublist(1,2).single);
            print (statusList.sublist(2,3).single);
            print (statusList.sublist(3,4).single);
            tryPrint = statusList;
            oldList = "";
            for (int x=0; x<slength; ++x) {
            String newList = oldList + "\n" + statusList.sublist(x,x+1).single;
            oldList = newList;
            }
            print (oldList);
            }
      }
    });

///////////////////////////////////////////
*/

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //backgroundColor: Colors.grey [800],
            automaticallyImplyLeading: false,
            title: Text(
              "TeamPage",
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
            actions: <Widget>[

              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TeamProject()));
                    },
                    child: Icon(
                      Icons.content_paste,
                      size: 26.0,
                    ),
                  )),

              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProject()));
                    },
                    child: Icon(
                      Icons.add_to_photos,
                      size: 26.0,
                    ),
                  )),

              PopupMenuButton<String>(
                onSelected: overflowSelected,
                itemBuilder: (BuildContext context) {
                  return OverflowBtn.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ]
        ),

        body:
        //SingleChildScrollView(
        Column (
          children: <Widget>[

            //Expanded (flex:1, child: oldList !=null? Text (oldList): Text ("wait...")),

            Expanded (
                flex: 1,
                child: Container (
                  color: Colors.white,
                  child: ClipRRect(
                      child: Image.asset("assets/oneteam.jpg")),
                )),

            Expanded (
                flex: 1,
                child: Container (
                  color: Colors.grey [900],
                  child: ClipRRect(
                      child: Image.asset("assets/dontmanageJack.jpg")),
                )),
          ],)
      // )
    );
  }

}