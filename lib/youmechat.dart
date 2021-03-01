//import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/youinfo.dart';

class YouMeChat extends StatefulWidget {
  final YouInfo data;
  YouMeChat({this.data});
  @override
  _YouMeChatState createState() => _YouMeChatState();
}

class _YouMeChatState extends State<YouMeChat> {
  String meUserId;
  String youMsg = "Wait a min...";
  //String youMsgLogging = ".";
  String msgSent;
  String youImage;
  String youUserId;
  String youName;
  TextEditingController meSay = TextEditingController();
  String youMeMsgLog = ".";
  String msgPath1;
  String msgPath2;
  String userName;
  int compareDone =0; //////
  //int lastTimeStamp; //////
  String oldMsgList;
  //String newMsgList;

  @override
  void initState() {

    //youUserId = widget.data.youUserId;
    super.initState();

      setState(() {
        FirebaseAuth.instance.currentUser().then((user) {
          meUserId = user.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    youImage = widget.data.youImageUrl;
    youUserId = widget.data.youUserId;
    youName = widget.data.youName;


    // identify where in database the youMeMsgLog is recorded
if (compareDone == 0) {
  print(youUserId);
  print(meUserId);
  if (youUserId.toString().compareTo(meUserId.toString()) > 0) {
    msgPath1 = meUserId;
    msgPath2 = youUserId;
  }
  else {
    msgPath1 = youUserId;
    msgPath2 = meUserId;
  }

if (msgPath1 != null && msgPath2 != null){compareDone = 1;}
  print("A: msgPath1: " + msgPath1.toString());
  print("B: msgPath2: " + msgPath2.toString());
}


    Future getMsg() async {
      await Firestore.instance
          .collection("users")
          .document(meUserId)
          .get()
          .then((value) {
        if (value.data != null) {
          if (mounted) {
            // neeeeeeed?
            setState(() {
              if (value.data['name'] != null) {
                userName = value.data['name'];
              }
            });
          }
        }
      });

      await Firestore.instance
          .collection("OneOneMsg")
          .document(meUserId)
          .collection("msgFrom")
          .document(youUserId)
          .get()
          .then((value) async {
        if (value.data != null) {
          if (mounted)
            setState(() {
              if (value.data['lastMsg'] != null) {
                youMsg = value.data['lastMsg'];
              }
            });
        }
      });

      await Firestore.instance
          .collection("OneOneMsg")
          .document("MsgLog")
          .collection(msgPath1)
          .document(msgPath2)
          .get()
          .then((value) {
            //print ("here1: "+ value.data.toString());
        if (value.data != null) {
          //print ("here2: " + value.data['pastMsgLog'].toString());
          if (value.data['pastMsgLog'] != null) {
            List msgLogList = value.data['pastMsgLog'];
            int len = msgLogList.length;
            //print ("len: " + len.toString());
            //print (msgLogList .sublist(0,1).single);
            //print (msgLogList .sublist(1,2).single);
            //print (msgLogList .sublist(2,3).single);
            //print (msgLogList .sublist(3,4).single);
            oldMsgList = "";
            for (int x=0; x<len; ++x) {
              youMeMsgLog =  msgLogList.sublist(x,x+1).single + "\n" + oldMsgList;
              oldMsgList = youMeMsgLog ;
            }
            //print ("log: " + youMeMsgLog);
            //youMeMsgLog = value.data['pastMsgLog'];
            //print ("captured 2?: " + youMeMsgLog);
          }
        }
      });
    }

    getMsg();

    writeToDatabase () async {
      await FirebaseAuth.instance.currentUser().then((user) async {
        //print ("when load: " + youMeMsgLog);
        if (user != null) {
          if (youMeMsgLog == null) {
            youMeMsgLog = ".";
          }

          Map<String, String> userMap = {
            "lastMsg": meSay.text,
            //"pastMsgLog": meSay.text + " | " +  meMsgLogging, //change to youMeMsgLog
            "timeStamp": ""
          };

          /* //shut and see how
          if (mounted) setState(() {
          Firestore.instance
              .collection("OneOneMsg")
              .document(youUserId)
              .collection("msgFrom")
              .document(meUserId)
              .setData(userMap);
        });
        */

          await Firestore.instance
              .collection("OneOneMsg")
              .document(youUserId)
              .collection("msgFrom")
              .document(meUserId)
              .setData(userMap);

          /*
          await Firestore.instance.collection("OneOneMsg")
              .document("MsgLog")
              .collection(msgPath1)
              .document(msgPath2)
              .updateData({"timeStamp": DateTime.now().millisecondsSinceEpoch});
          */



          /////  added ////////
          await Firestore.instance
              .collection("OneOneMsg")
              .document("MsgLog")
              .collection(msgPath1)
              .document(msgPath2).get().then((value){
            if (value.data != null) {
              Firestore.instance
                .collection("OneOneMsg")
                .document("MsgLog")
                .collection(msgPath1)
                .document(msgPath2)
                .updateData({"pastMsgLog" : FieldValue.arrayUnion([userName + ": " + meSay.text])});
              Firestore.instance.collection("OneOneMsg")
                  .document("MsgLog")
                  .collection(msgPath1)
                  .document(msgPath2)
                  .updateData({"timeStamp": DateTime.now().millisecondsSinceEpoch});
            }
            else {
              Firestore.instance
                .collection("OneOneMsg")
                .document("MsgLog")
                .collection(msgPath1)
                .document(msgPath2)
                .setData({"pastMsgLog" : FieldValue.arrayUnion([userName + ": " + meSay.text])});

              Firestore.instance.collection("OneOneMsg")
                  .document("MsgLog")
                  .collection(msgPath1)
                  .document(msgPath2)
                  .setData({"timeStamp": DateTime.now().millisecondsSinceEpoch});
            }
          });
          //////////////////////



          /* ///// shut  ///////
          await Firestore.instance
              .collection("OneOneMsg")
              .document("MsgLog")
              .collection(msgPath1)
              .document(msgPath2)
              .updateData({
            "pastMsgLog" : FieldValue.arrayUnion([userName + ": " + meSay.text])
          });
          */ ///////////////////

          meSay.clear();
        }
      });
    }

    Future uploadMsg() async {
      await getMsg();

/*
      // check last upload timestamp and see if want delay then insert new time stamp
      await Firestore.instance
          .collection("OneOneMsg")
          .document("MsgLog")
          .collection(msgPath1)
      //.document(msgPath1)
      //.collection("msgFrom")
          .document(msgPath2)
          .get()
          .then((value) {
        if (value.data != null) {
          if (value.data['timeStamp'] != null) {
            lastTimeStamp = value.data['timeStamp'];
          }
        }
      });
*/

          writeToDatabase ();
    }



//print ("before Scaffold: " + youMeMsgLog);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Chat',
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
        ),
        body: Builder(
            builder: (context) => Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.grey,
                                    child: ClipOval(
                                        child: SizedBox(
                                            width: 160.0,
                                            height: 160.0,
                                            child: (youImage != "")
                                                ? Image.network(youImage)
                                                : Image.asset(
                                                "assets/default_icon1.jpg"))))),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Text(
                                youMsg,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: Row(
                          children: <Widget>[
                            //SizedBox (height: 10),
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                controller: meSay,
                                keyboardType: TextInputType.multiline,
                                maxLength: null,
                                maxLines: null,
                                decoration: InputDecoration(
                                    hintText: "...",
                                    border: UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Colors.grey,
                                        ))),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: FlatButton(
                                onPressed: () {
                                  meSay.text != "" ? uploadMsg():null;
                                },
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(20.0)),
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text(
                                  "Go",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //SizedBox (height:10),
                    Expanded(
                        flex: 5,
                        child: new SingleChildScrollView(
                          reverse: false,
                          scrollDirection: Axis.vertical, //.horizontal
                          //padding: const EdgeInsets.all(5.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Text(
                                youMeMsgLog, //change to youMeMsgLog
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                //maxLines: 3,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        )),
                  ],
                ))));
  }
}
