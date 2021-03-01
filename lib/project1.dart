//import 'dart:html';
//import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/projectinfo.dart';
import 'model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Project1 extends StatefulWidget {
  final ProjectInfo projectInfo;
  Project1({this.projectInfo});
  @override
  _Project1State createState() => _Project1State();
}

class _Project1State extends State<Project1> {
  String userIdCurrent;
  String userName;
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((user) {
      userIdCurrent = user.uid;
      Firestore.instance
          .collection("users")
          .document(userIdCurrent)
          .get()
          .then((value) {
        userName = value.data["name"];
        setState(() {});
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    String _projName = widget.projectInfo.projectName;
    String _projObjective = widget.projectInfo.projectObjective;

    // with the projectName, get all the tokens under this project and put it to pushtokens

    insertTokenId() async {
      /*
      QuerySnapshot qn =
      await Firestore.instance.collection(_projName).getDocuments();
      //print ("here A: " + qn.documents.length.toString());
      int docLength = qn.documents.length; ////
      if (docLength != null) {
        for (int x = 0; x < docLength; ++x) ////
            {
          String tokenId = qn.documents[x].data['tokenId']; ////
          print("tokenId: " + tokenId.toString());
          //print("doclength: " + docLength.toString());
          // go to all project and insert token to my name
          Firestore.instance.collection('notificationtokens').document(userIdCurrent).setData({
            "tokenId": tokenId
          }, merge: true);
        }
      }
      */

      String tokenId;
      Firestore.instance
          .collection(_projName)
          .document(userIdCurrent)
          .get()
          .then((value) {
        if (value.data != null) {
          if (value.data['tokenId'] != null) {
            tokenId = value.data['tokenId'];
          }
          Firestore.instance
              .collection(_projName + 'TokenIds')
              .document(userIdCurrent)
              .setData({"tokenId": tokenId}, merge: true);
        }
      });
    }

    insertTokenId();

    final projectInfo =
        ProjectInfo(projectName: _projName, projectObjective: _projObjective);
    final userInfo = User(userId: userIdCurrent, userName: userName);

    //print ("Main...." + userIdCurrent.toString());

    return PageView(
      controller: _controller,
      children: [
        Goals(projectInfo: projectInfo),
        Discuss(projectInfo: projectInfo, userInfo: userInfo),
        Notes(projectInfo: projectInfo),
        MyThoughts(projectInfo: projectInfo, userInfo: userInfo),
      ],
    );
  }
}

class Goals extends StatefulWidget {
  final ProjectInfo projectInfo;
  //final User userInfo;
  Goals({this.projectInfo});

  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  String projName;
  String projObjective;
  String pastMessages;
  TextEditingController meSay = TextEditingController();

  Future getMsg() async {
    //final firebaseUser = await FirebaseAuth.instance.currentUser();
    //print ("here 1: " + meUserId );
    //print ("here 1: " + youUserId.toString());
    Firestore.instance
        .collection(projName + "Messages")
        .document("projectGoals")
        .get()
        .then((value) {
      if (value.data != null) {
        if (value.data['pastMsgLog'] != null) {
          //print ("here 2");
          if (mounted)
            setState(() {
              //if (value.data['lastMsg'] != null) {youMsg = value.data['lastMsg'];}
              if (value.data['pastMsgLog'] != null) {
                pastMessages = value.data['pastMsgLog'];
              }
            });
        } else {
          pastMessages = "Goals:";
        }
      } else {
        pastMessages = "Goals:";
      }
    });
  }

  /*
  uploadMsg() {
    //print ("pastmessages: " + pastMessages.toString());
    //FirebaseAuth.instance.currentUser().then((user) {
    //if (user != null) {
    if (pastMessages != null) {
      //if (meSay.text == null) {meSay.text  = ".";}
      //int limitLength = min(100, meMsgLogging.length);
      //meMsgLogging = meMsgLogging.substring(0,limitLength);
      Map<String, String> userMap = {
        //"lastMsg": meSay.text,
        "pastMsgLog": pastMessages + '\n' + meSay.text,
        //"timeStamp": ""
      };
      Firestore.instance.collection(projName + "Messages").document("projectGoals").setData(userMap);
      meSay.clear();



      setState(() {});
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    projName = widget.projectInfo.projectName;
    projObjective = widget.projectInfo.projectObjective;

    Future getMsg() async {
      //final firebaseUser = await FirebaseAuth.instance.currentUser();
      //print ("here 1: " + meUserId );
      //print ("here 1: " + youUserId.toString());
      Firestore.instance
          .collection(projName + "Messages")
          .document("projectGoals")
          .get()
          .then((value) {
        if (value.data != null) {
          if (value.data['pastMsgLog'] != null) {
            //print ("here 2");
            if (mounted)
              setState(() {
                //if (value.data['lastMsg'] != null) {youMsg = value.data['lastMsg'];}
                if (value.data['pastMsgLog'] != null) {
                  pastMessages = value.data['pastMsgLog'];
                }
              });
          } else {
            pastMessages = "Sub goals:";
          }
        } else {
          pastMessages = "Sub goals:";
        }
      });
    }

    uploadMsg() {
      //print ("pastmessages: " + pastMessages.toString());
      //FirebaseAuth.instance.currentUser().then((user) {
      //if (user != null) {
      if (pastMessages != null) {
        //if (meSay.text == null) {meSay.text  = ".";}
        //int limitLength = min(100, meMsgLogging.length);
        //meMsgLogging = meMsgLogging.substring(0,limitLength);
        Map<String, String> userMap = {
          //"lastMsg": meSay.text,
          "pastMsgLog": pastMessages + '\n\n' + meSay.text,
          //"timeStamp": ""
        };
        Firestore.instance
            .collection(projName + "Messages")
            .document("projectGoals")
            .setData(userMap);
        meSay.clear();

        setState(() {});
      }
    }

    getMsg();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            // can do your Appbar icon button here
            padding: EdgeInsets.only(right: 20.0),
          ),
        ],
        title: Text(
          "Goals - " + projName,
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: projObjective != null
                  ? Text(projObjective,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ))
                  : null,
            ),
            SizedBox(height: 20),
            new Expanded(
              flex: 1,
              child: SingleChildScrollView(
                //reverse: true,
                scrollDirection: Axis.vertical, //.horizontal
                padding: const EdgeInsets.all(20.0),
                child: pastMessages != null
                    ? Text(
                        pastMessages,
                        //textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.normal,
                            fontSize: 20.0,
                            letterSpacing: 1,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )
                    : null,
              ),
            ),
            Row(children: <Widget>[
              Expanded(
                  flex: 10,
                  child: TextField(
                    controller: meSay,
                    style: TextStyle(
                        color: Colors.white, fontStyle: FontStyle.italic),
                    keyboardType: TextInputType.multiline,
                    maxLength: null,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "type your message here",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                        border: UnderlineInputBorder(
                            borderSide: new BorderSide(
                          color: Colors.white,
                        ))),
                  )),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      meSay.text != "" ? uploadMsg() : null;
                    },
                    child: Icon(
                      Icons.reply,
                      color: Colors.blue,
                      size: 20.0,
                    ),
                  )),
            ]),
          ]),
    );
  }
}

class Discuss extends StatefulWidget {
  final ProjectInfo projectInfo;
  final User userInfo;
  Discuss({this.projectInfo, this.userInfo});
  @override
  _DiscussState createState() => _DiscussState();
}

class _DiscussState extends State<Discuss> {
  String projName;
  int pickCount;
  var projMemberId = new List(10);
  var projMemberImage = new List(10);
  int memberCount;
  String userIdCurrent;
  //String userIdCurrentx;
  //String userNamex;
  String userName;
  TextEditingController meSay = TextEditingController();
  String pastMessages;
  String pastNotes;
  int timeNoteOld;
  String dDate;
  DateFormat dateFormat = DateFormat('dd-MMM-yyyy');

  @override
  void initState() {
    super.initState();

    //if (Platform.isIOS) {}
    //FirebaseAuth.instance.currentUser().then((user) {userIdCurrent = user.uid;
    //  Firestore.instance.collection("users").document(userIdCurrent).get().then((value) {userName = value.data["name"];
    //  });
    //});
  }

  @override
  Widget build(BuildContext context) {
    projName = widget.projectInfo.projectName;
    userIdCurrent = widget.userInfo.userId;
    userName = widget.userInfo.userName;
    //print ("USERID W1: " + userIdCurrent.toString());
    //print ("USERName W1: " + userName.toString());

    getMemberId() async {
      await Firestore.instance.collection(projName).getDocuments().then((val) {
        if (this.mounted) {
          setState(() {
            memberCount = val.documents.length;
            for (int x = 0; x < val.documents.length; x++) {
              projMemberId[x] = val.documents[x]['userId'];
              //print (projMemberId[x]);
            }
          });
        }
      });
    }

    if (projMemberId[0] != null) {
      Firestore.instance
          .collection("users")
          .document(projMemberId[0])
          .get()
          .then((value) {
        projMemberImage[0] = value.data["image"];
      });
      //print(projMemberImage[0]);
    }
    if (projMemberId[1] != null) {
      Firestore.instance
          .collection("users")
          .document(projMemberId[1])
          .get()
          .then((value) {
        projMemberImage[1] = value.data["image"];
      });
      //print(projMemberImage[1]);
    }
    if (projMemberId[2] != null) {
      Firestore.instance
          .collection("users")
          .document(projMemberId[2])
          .get()
          .then((value) {
        projMemberImage[2] = value.data["image"];
      });
      //print(projMemberImage[2]);
    }
    if (projMemberId[3] != null) {
      Firestore.instance
          .collection("users")
          .document(projMemberId[3])
          .get()
          .then((value) {
        projMemberImage[3] = value.data["image"];
      });
      //print(projMemberImage[3]);
    }
    if (projMemberId[4] != null) {
      Firestore.instance
          .collection("users")
          .document(projMemberId[4])
          .get()
          .then((value) {
        projMemberImage[4] = value.data["image"];
      });
      //print(projMemberImage[4]);
    }

    Future getMsg() async {
      //final firebaseUser = await FirebaseAuth.instance.currentUser();
      //print ("here 1: " + meUserId );
      //print ("here 1: " + youUserId.toString());
      Firestore.instance
          .collection(projName + "Messages")
          .document("groupMessages")
          .get()
          .then((value) {
        if (value.data != null) {
          if (value.data['pastMsgLog'] != null) {
            //print ("here 2");
            if (mounted)
              setState(() {
                //if (value.data['lastMsg'] != null) {youMsg = value.data['lastMsg'];}
                if (value.data['pastMsgLog'] != null) {
                  pastMessages = value.data['pastMsgLog'];
                }
              });
          } else {
            pastMessages = "msg starts:";
          }
        } else {
          pastMessages = "msg starts:";
        }
      });
    }

    Future getNotes() async {
      //final firebaseUser = await FirebaseAuth.instance.currentUser();
      //print ("here 1: " + meUserId );
      //print ("here 1: " + youUserId.toString());
      Firestore.instance
          .collection(projName + "Messages")
          .document("groupNotes")
          .get()
          .then((value) {
        if (value.data != null) {
          if (value.data['pastNotesLog'] != null) {
            //print ("here 2");
            if (mounted)
              setState(() {
                //if (value.data['lastMsg'] != null) {youMsg = value.data['lastMsg'];}
                if (value.data['pastNotesLog'] != null) {
                  pastNotes = value.data['pastNotesLog'];
                }
                if (value.data['timeStampOld'] != null) {
                  timeNoteOld = value.data['timeStampOld'];
                }
              });
          } else {
            pastNotes = "Notes starts:";
          }
        } else {
          pastNotes = "Notes starts:";
        }
      });
    }

    stampMsgTime() {
      if (pastMessages != null) {
        //pastMessages should not be null as it was force to have value at above
        Map<String, String> userMap = {
          "pastMsgLog": pastMessages +
              '\n\n' +
              DateTime.now()
                  .add(Duration(hours: 8))
                  .toString()
                  .substring(0, 16) //I just add 8 hours to make it SG time
        };
        Firestore.instance
            .collection(projName + "Messages")
            .document("groupMessages")
            .setData(userMap);
      }
      setState(() {});
    }

    uploadMsg() {
      //print ("pastmessages: " + pastMessages.toString());
      //FirebaseAuth.instance.currentUser().then((user) {
      //if (user != null) {
      if (pastMessages != null) {
        //if (meSay.text == null) {meSay.text  = ".";}
        //int limitLength = min(100, meMsgLogging.length);
        //meMsgLogging = meMsgLogging.substring(0,limitLength);
        Map<String, String> userMap = {
          //"lastMsg": meSay.text,
          "pastMsgLog": pastMessages + '\n\n' + userName + ": " + meSay.text,
          //"timeStamp": ""
        };
        Firestore.instance
            .collection(projName + "Messages")
            .document("groupMessages")
            .setData(userMap);
        meSay.clear();

        // here write a new doc to notifyTrigger and inside has proj Name

        Firestore.instance.collection('notifyTrigger').document().setData(
            {"project": projName, "message": "check into OneTeam"},
            merge: true);
        setState(() {});
      }
    }

    uploadNotes() {
      //print ("pastmessages: " + pastMessages.toString());
      //FirebaseAuth.instance.currentUser().then((user) {
      //if (user != null) {
      if (pastNotes != null) {
        //if (meSay.text == null) {meSay.text  = ".";}
        //int limitLength = min(100, meMsgLogging.length);
        //meMsgLogging = meMsgLogging.substring(0,limitLength);
        if (timeNoteOld != null) {
          //print (DateTime.now().millisecondsSinceEpoch);
          // print (timeNoteOld);
          //print (DateTime.now().millisecondsSinceEpoch.compareTo(timeNoteOld));
          int x = DateTime.now().millisecondsSinceEpoch - timeNoteOld;
          // print (x);
          if (x > 86400000) {
            //86400000 ms equals 1 day. the millisecondsSinceEpoch thing is actually in seconds
            // put new time to datafield old time
            Firestore.instance
                .collection(projName + "Messages")
                .document("groupNotes")
                .updateData(
                    {"timeStampOld": DateTime.now().millisecondsSinceEpoch});
            // insert time stamp to the pastMotes
            String timeWrite = DateTime.now()
                .add(Duration(hours: 8))
                .toString()
                .substring(0, 16);
            Map<String, String> userMap = {
              "pastNotesLog": pastNotes + '\n\n' + timeWrite + '\n' + meSay.text
            };
            Firestore.instance
                .collection(projName + "Messages")
                .document("groupNotes")
                .setData(userMap, merge: true);
          } else {
            Map<String, String> userMap = {
              "pastNotesLog": pastNotes + '\n\n' + meSay.text
            };
            Firestore.instance
                .collection(projName + "Messages")
                .document("groupNotes")
                .setData(userMap, merge: true);
          }
        } else {
          String timeWrite = DateTime.now()
              .add(Duration(hours: 8))
              .toString()
              .substring(0, 16);
          Map<String, String> userMap = {
            "pastNotesLog": pastNotes + '\n\n' + timeWrite + '\n' + meSay.text
          };
          Firestore.instance
              .collection(projName + "Messages")
              .document("groupNotes")
              .setData(userMap, merge: true);
          Firestore.instance
              .collection(projName + "Messages")
              .document("groupNotes")
              .setData({"timeStampOld": DateTime.now().millisecondsSinceEpoch},
                  merge: true);
        }

        Map<String, String> actionMap = {
          "action": meSay.text,
          "dueDate": dDate,
        };
        Firestore.instance
            .collection(projName + "Action")
            .document()
            .setData(actionMap);
        uploadMsg();
        meSay.clear();
        //}
        //});
      }
    }

    getMsg();
    getNotes();
    getMemberId();
    //getMemberImage();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  stampMsgTime();
                },
                child: Icon(
                  Icons.access_time,
                  size: 26.0,
                ),
              )),
        ],
        title: Text(
          "Discuss - " + projName,
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        new Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
        ),
        new Expanded(
          flex: 1,
          child: new SingleChildScrollView(
            reverse: true,
            scrollDirection: Axis.vertical, //.horizontal
            padding: const EdgeInsets.all(20.0),
            child: pastMessages != null
                ? Text(
                    "" + pastMessages,
                    style: TextStyle(
                        fontFamily: 'Calibri',
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        letterSpacing: 1,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  )
                : null,
          ),
        ),
        SizedBox(height: 25.0),
        Row(children: <Widget>[
          SizedBox(width: 5.0),
          Expanded(
            flex: 1,
            child: CircleAvatar(
                radius: 30,
                child: ClipOval(
                  child: projMemberImage[0] != null && projMemberImage[0] != ""
                      ? Image.network(projMemberImage[0])
                      : Image.asset("assets/default_icon1.jpg"),
                )),
          ),
          SizedBox(width: 15.0),
          Expanded(
            flex: 1,
            child: CircleAvatar(
                radius: 30,
                child: ClipOval(
                  child: projMemberImage[1] != null && projMemberImage[1] != ""
                      ? Image.network(projMemberImage[1])
                      : Image.asset("assets/default_icon1.jpg"),
                )),
          ),
          SizedBox(width: 15.0),
          Expanded(
            flex: 1,
            child: CircleAvatar(
                radius: 30,
                child: ClipOval(
                  child: projMemberImage[2] != null && projMemberImage[2] != ""
                      ? Image.network(projMemberImage[2])
                      : Image.asset("assets/default_icon1.jpg"),
                )),
          ),
          SizedBox(width: 15.0),
          Expanded(
            flex: 1,
            child: CircleAvatar(
                radius: 30,
                child: ClipOval(
                  child: projMemberImage[3] != null && projMemberImage[3] != ""
                      ? Image.network(projMemberImage[3])
                      : Image.asset("assets/default_icon1.jpg"),
                )),
          ),
          SizedBox(width: 15.0),
          Expanded(
            flex: 1,
            child: CircleAvatar(
                radius: 30,
                child: ClipOval(
                  child: projMemberImage[4] != null && projMemberImage[4] != ""
                      ? Image.network(projMemberImage[4])
                      : Image.asset("assets/default_icon1.jpg"),
                )),
          ),
          SizedBox(width: 5.0),
        ]),
        SizedBox(height: 10.0),
        Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2019),
                          lastDate: DateTime(2023))
                      .then((date) {
                    setState(() {
                      date != null ? dDate = dateFormat.format(date) : null;
                      //dDate != null? print ("Date is: " + dDate):print ("nothing");
                      meSay.text != "" ? uploadNotes() : null;
                    });
                  });
                },
                child: Icon(
                  Icons.playlist_add_check,
                  color: Colors.blue,
                  size: 22.0,
                ),
              )),
          Expanded(
              flex: 10,
              child: TextField(
                controller: meSay,
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                keyboardType: TextInputType.multiline,
                maxLength: null,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: "type your message here",
                    hintStyle: TextStyle(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                    border: UnderlineInputBorder(
                        borderSide: new BorderSide(
                      color: Colors.white,
                    ))),
              )),
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  meSay.text != "" ? uploadMsg() : null;
                },
                child: Icon(
                  Icons.reply,
                  color: Colors.blue,
                  size: 20.0,
                ),
              )),
        ]),
      ]),
    );
  }
}

class Notes extends StatefulWidget {
  final ProjectInfo projectInfo;
  Notes({this.projectInfo});
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  String projName;
  int pickCount;
  var projMemberId = new List(10);
  var projMemberImage = new List(10);
  int memberCount;
  String pastNotes;
  //String timeWrite;

  @override
  Widget build(BuildContext context) {
    projName = widget.projectInfo.projectName;

    Future getNotes() async {
      //final firebaseUser = await FirebaseAuth.instance.currentUser();
      //print ("here 1: " + meUserId );
      //print ("here 1: " + youUserId.toString());
      Firestore.instance
          .collection(projName + "Messages")
          .document("groupNotes")
          .get()
          .then((value) {
        if (value.data != null) {
          //print ("here 2");
          if (mounted)
            setState(() {
              //if (value.data['lastMsg'] != null) {youMsg = value.data['lastMsg'];}
              if (value.data['pastNotesLog'] != null) {
                pastNotes = value.data['pastNotesLog'];

                /*
                if (value.data['timeStampOld'] != null) {
                  if (value.data['timeStampNew'].difference(value.data['timeStampOld']).inDays > 1) {
                    timeWrite = value.data['timeStampNew'].toString();
                  } else {
                    timeWrite = null;
                  }
                }
// write to data base old time the new time
              */

              }
            });
        } else {
          pastNotes = "Notes starts:";
        }
      });
    }

    getNotes();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
          )
        ],
        title: Text(
          "Notes & Actions - " + projName,
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //new Padding(
            //  padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
            //),
            SizedBox(height: 20),
            new Expanded(
              flex: 1,
              child: new SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.vertical, //.horizontal
                padding: const EdgeInsets.all(20.0),
                child: pastNotes != null
                    ? Text(
                        "" + pastNotes,
                        style: TextStyle(
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
                            letterSpacing: 1,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )
                    : null,
              ),
            ),

            SizedBox(height: 20.0),
          ]),
    );
  }
}

class MyThoughts extends StatefulWidget {
  final ProjectInfo projectInfo;
  final User userInfo;
  MyThoughts({this.projectInfo, this.userInfo});
  @override
  _MyThoughtsState createState() => _MyThoughtsState();
}

class _MyThoughtsState extends State<MyThoughts> {
  String projName;
  String userIdCurrent;
  int pickCount;
  var projMemberId = new List(10);
  var projMemberImage = new List(10);
  int memberCount;
  String pastMessages;
  TextEditingController meSay = TextEditingController();

  @override
  Widget build(BuildContext context) {
    projName = widget.projectInfo.projectName;
    userIdCurrent = widget.userInfo.userId;

//print ("USERID W3: " + userIdCurrent);

    stampMsgTime() {
      if (pastMessages != null) {
        //pastMessages should not be null as it was force to have value at above
        Map<String, String> userMap = {
          "myThoughts": pastMessages +
              '\n\n' +
              DateTime.now()
                  .add(Duration(hours: 8))
                  .toString()
                  .substring(0, 16) //I just add 8 hours to make it SG time
        };
        Firestore.instance
            .collection(userIdCurrent)
            .document(projName)
            .updateData(userMap);
      }
      setState(() {});
    }

    Future getMsg() async {
      //final firebaseUser = await FirebaseAuth.instance.currentUser();
      //print ("here 1: " + meUserId );
      //print ("here 1: " + youUserId.toString());
      Firestore.instance
          .collection(userIdCurrent)
          .document(projName)
          .get()
          .then((value) {
        if (value.data != null) {
          if (value.data['myThoughts'] != null) {
            //print ("here 2");
            if (mounted)
              setState(() {
                //if (value.data['lastMsg'] != null) {youMsg = value.data['lastMsg'];}
                if (value.data['myThoughts'] != null) {
                  pastMessages = value.data['myThoughts'];
                }
              });
          } else {
            pastMessages = "thoughts start:";
          }
        } else {
          pastMessages = "thoughts start:";
        }
      });
    }

    uploadMsg() {
      //print ("pastmessages: " + pastMessages.toString());
      //FirebaseAuth.instance.currentUser().then((user) {
      //if (user != null) {
      if (pastMessages != null) {
        //if (meSay.text == null) {meSay.text  = ".";}
        //int limitLength = min(100, meMsgLogging.length);
        //meMsgLogging = meMsgLogging.substring(0,limitLength);
        Map<String, String> userMap = {
          //"lastMsg": meSay.text,
          "myThoughts": pastMessages + '\n\n' + meSay.text,
          //"timeStamp": ""
        };
        Firestore.instance
            .collection(userIdCurrent)
            .document(projName)
            .updateData(userMap);
        meSay.clear();
        setState(
            () {}); // the setstate here somehow solve the issue of text not showing up on mobile screen when typed and upload
      } // without this, it only show up when reload the page. Don't know what the reason is
    }

    getMsg();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  stampMsgTime();
                },
                child: Icon(
                  Icons.access_time,
                  size: 26.0,
                ),
              )),
        ],
        title: Text(
          "My thoughts - " + projName,
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
            ),
            new Expanded(
              flex: 1,
              child: new SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.vertical, //.horizontal
                padding: const EdgeInsets.all(20.0),
                child: pastMessages != null
                    ? Text(
                        pastMessages,
                        style: TextStyle(
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
                            letterSpacing: 1,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )
                    : null,
              ),
            ),
            Row(children: <Widget>[
              Expanded(
                  flex: 10,
                  child: TextField(
                    controller: meSay,
                    style: TextStyle(
                        color: Colors.white, fontStyle: FontStyle.italic),
                    keyboardType: TextInputType.multiline,
                    maxLength: null,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "type your message here",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                        border: UnderlineInputBorder(
                            borderSide: new BorderSide(
                          color: Colors.white,
                        ))),
                  )),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      meSay.text != "" ? uploadMsg() : null;
                    },
                    child: Icon(
                      Icons.reply,
                      color: Colors.blue,
                      size: 20.0,
                    ),
                  )),
            ]),
          ]),
    );
  }
}
