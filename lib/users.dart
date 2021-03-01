import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:oneteam/settings.dart';
import 'package:oneteam/youmechat.dart';
import 'package:toast/toast.dart';

import 'groupchat.dart';
import 'main.dart';
import 'model/groupinfo.dart';
import 'model/user.dart';
import 'model/youinfo.dart';
//import 'package:path/path.dart';

class Users extends StatefulWidget {
  //final GroupInfo groupInfo;
  //Users({this.groupInfo});

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {

  void goToHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
  }

  void goToGroupChat() {
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GroupChat()));
  }


  int connected = 0;
  String youImageUrl;
  String youUserId;
  String youName;
  int maxMember = 4; //if limit at 3 as max chat member, then to increase, need to change this plus adding passing of data to GroupInfo constructor
  //add at "dataGroup = GroupInfo(..." here, then after that add at Constructor Class groupinfo.dart
  int pickCount;
  var chatMemberId = new List(5);
  var projMemberId = new List(5); // same set max chatmemberId array size as 4. Somehow must set Array at 4 to process max of 3
  //var chatMemberName = new List(4);

  //int pCount = 0;
  //int m=0;
  int totalUserSize;
  String tooMany;
  String userIdCurrent;
  String userEmailCurrent;
  List<bool> mCheck = new List<bool>();


  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) async {
      userIdCurrent = user.uid;
      await Firestore.instance.collection("users").document(userIdCurrent).get().then((val) async {
        userEmailCurrent = val.data["email"];
        //print (userEmailCurrent);
        getUsers();
      });
      //await updateImage();
    });

    userSize();
    setState(() {});
  }


  userSize() async {
    Firestore.instance.collection("users").getDocuments().then((val) {
      totalUserSize = val.documents.length;
      setState(() {
        for (int i = 0; i <= totalUserSize; i++) {
          mCheck.add(false);}
      });
      //print("Totalsize " + totalUserSize.toString()); print (userIdCurrent);
    });
  }

  Future getUsers()async {
    QuerySnapshot qn =
    await Firestore.instance.collection("users").getDocuments();
    //print ("here A: " + qn.documents.length.toString());
    //docLength = qn.documents.length.toString();
    return qn.documents; // this return all the documents (an Array snapshot) in users collection
  }

  groupPick() async {
    tooMany = "no";
    //print (userEmailCurrent.toString());
    await Firestore.instance.collection("users").getDocuments().then((val) {
      //await Firestore.instance.collection(userIdCurrent).document("myFriend").collection("friendList").getDocuments().then((val) {
      setState(() {
        pickCount = 0;
        //print ("length: " + val.documents.length.toString());
        for (int x = 0; x <= val.documents.length; x++) {
          if (mCheck[x] == true && val.documents[x]['userId'] != userIdCurrent) { // So incremental pickCount here below does not include userIdCurrent himself
            //print("User:   " + val.documents[x]['userId']);
            //print ("Max member: " + maxMember.toString());
            if (pickCount < maxMember) {
              int pCount = ++pickCount;
              projMemberId[pCount] = val.documents[x]['userId'];
              chatMemberId[pCount] = val.documents[x]['userId'];
              //chatMemberName[pCount] = val.documents[x]['name'];
              //print("chatmember[]: " + pickCount.toString() + " " + chatMemberId[pickCount]);
            } else {
              tooMany = "yes";
              //Toast.show("Too Many " + pickCount.toString(), context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            }
          }
        }
      });
    });
    //print("tooMany before go:  " + tooMany);
  }


  int toShow;
  toShowImage(AsyncSnapshot snapshot, index) {
    if (snapshot.data[index].data['image'] != "" && snapshot.data[index].data['image'] != null) {
      toShow = 1;
    } else {
      toShow = 0;
    }
    return toShow;
  }


  //String youImageUrl;
  YouImageUrl(AsyncSnapshot snapshot, index) {
    return snapshot.data[index].data['image'];
  }

  //String youUserId;
  YouUserId(AsyncSnapshot snapshot, index) {
    return snapshot.data[index].data['userId'];
  }

  YouName(AsyncSnapshot snapshot, index) {
    return snapshot.data[index].data['name'];
  }


  //List <bool> mCheck = new List<bool>();

  //_UserPageState objUserPage = _UserPageState();
  @override
  Widget build(BuildContext context) {

/*
    if (docLength == "jjj") {
      getUsers();
      return Container (
      );
    }else
*/
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    goToHome();
                  },
                  child: Icon(
                    Icons.home,
                    size: 26.0,
                  ),

                )),



            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    //print("here.....");
                    if (pickCount != null) {
                      if (pickCount < 2) {
                        Toast.show("No Group formed ", context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM);
                      }
                      else {
                        if (tooMany == 'yes') {
                          Toast.show("Maximum members allowed is " +
                              maxMember.toString(), context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        } else {
                          final dataGroup = GroupInfo( // limited to 4 chatMember here, if want more, must add herer
                            chatMemberId1: chatMemberId[1],
                            chatMemberId2: chatMemberId[2],
                            chatMemberId3: chatMemberId[3],
                            chatMemberId4: chatMemberId[4],
                            //chatMemberName1: chatMemberName[1],
                            //chatMemberName2: chatMemberName[2],
                            //chatMemberName3: chatMemberName[3],
                            userIdCurrent: userIdCurrent,
                            memberCount: pickCount,
                            //tooMany: tooMany,
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => GroupChat(groupInfo: dataGroup)));

                        }
                      }
                    }
                  },
                  child: Icon(
                    Icons.chat,
                    size: 26.0,
                  ),
                )),


          ],
          title: Text(
            'Users',
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
        ),


        body: //UserPage(),
        //Container(),

        Container(
          child: FutureBuilder(
              future: getUsers(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && connected ==0) {
                  return Center(
                    child: Text("Loading..."),
                  );
                } else {
                  connected = 1;
                  //print("here B: " + snapshot.data.length.toString());
                  //if (snapshot.data.length != 0 ){ }
                  //}


                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        return ListTile(

                          title: GestureDetector(
                            onTap: () {

                              youUserId = YouUserId(snapshot, index);
                              youImageUrl = YouImageUrl(snapshot, index);

                              final data = YouInfo(
                                youImageUrl: youImageUrl,
                                youUserId: youUserId,
                                youName: youName, // suspected this not defined, just that we didnt use it at chat space
                              );

                              final userInfo = User(
                                userId: userIdCurrent,
                              );

                              youUserId != userIdCurrent
                                  ? Navigator.push(context, MaterialPageRoute(builder: (context) => YouMeChat(data: data)))
                                  : Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) =>
                                      ProfileSettings(
                                          userInfo: userInfo) // here only pass userIdCurrent over to ProfileSettings, name and image determine at Setting page
                                  )
                              );

                            },

                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.grey[200],
                                        child: ClipOval(
                                            child: SizedBox(
                                              width: 80.0,
                                              height: 80.0,
                                              child: toShowImage(
                                                  snapshot, index) != 1
                                                  ? Image.asset(
                                                  "assets/default_icon1.jpg")
                                                  : Image.network(
                                                  snapshot //try see if can use this similar YouImageUrl(snapshot, index); method to go users there to dig image and name data
                                                      .data[index]
                                                      .data['image']),
                                            ))),
                                  ),
                                ),
                                SizedBox(height: 90),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: Text(
                                      snapshot.data[index].data['name'],
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CheckboxListTile(
                                    //checkColor: Colors.blue,
                                    //secondary: Icon(Icons.beach_access),
                                    //controlAffinity: ListTileControlAffinity.platform,
                                      value: mCheck[index],
                                      onChanged: (bool val) {
                                        setState(() {
                                          //mCheck[index] = val;
                                          if (YouUserId(snapshot, index) !=
                                              userIdCurrent) {
                                            mCheck[index] = !mCheck[index];
                                          }
                                          //mCheck[index] == true ? ++ pCount:"",
                                        });
                                        groupPick();
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),


                        );
                      });


                } ///////else
              }),
        )

    );

  }
}
