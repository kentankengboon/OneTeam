import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/groupinfo.dart';


class GroupChat extends StatefulWidget {
  final GroupInfo groupInfo;
  GroupChat({this.groupInfo});

  @override
  _GroupChatState createState() => _GroupChatState();
}

// To add chatMembers, search below coding for comment with 'limit' and 'limited' wording
// Also the users side must set up to pass the additional member info over
// to do that, need to edit users.dart and groupInfo.dart side. same thing search for the 'limit' word

class _GroupChatState extends State<GroupChat> {
  String chatMemberId1;
  String chatMemberId2;
  String chatMemberId3;
  String chatMemberId4;
  //String chatMemberName1;
  //String chatMemberName2;
  //String chatMemberName3;
  String userIdCurrent;
  String userNameCurrent;
  String userImageUrlCurrent;
  String gpMsgLog;
  String newGpMsgLog;
  String oldGpMsgLog;
  String oldMsgList;
  String newGroupId;
  int memberCount;
  int maxGroup = 3;
  int gpToReplace;
  //int formNewGroup;
  //int replaceOldest;
  //int groupFound;
  int continueCurrent;
  int groupReplaceCheck;
  var chatMemberId = new List(5); //limited to 3 chatMembers 1,2,3 (0 not used)
  var chatMemberName = new List(5);
  var chatMemberImageUrl = new List(5);
  var chatMemberMsg = new List (5);
  var chatGroup = new List (3); // limited to 3 chatgroup 0,1,2
  var thisMemberId = new List(5);
  TextEditingController meSay = TextEditingController();
  //int lastTimeStamp;


  @override
  Widget build(BuildContext context) {


    chatMemberId1 = widget.groupInfo.chatMemberId1;
    chatMemberId2 = widget.groupInfo.chatMemberId2;
    chatMemberId3 = widget.groupInfo.chatMemberId3; // limited to 3 chatmember. need to further define more member if more than 3
    chatMemberId4 = widget.groupInfo.chatMemberId4;
    //chatMemberName1 = widget.groupInfo.chatMemberName1;
    //chatMemberName2 = widget.groupInfo.chatMemberName2;
    //chatMemberName3 = widget.groupInfo.chatMemberName3;

    userIdCurrent = widget.groupInfo.userIdCurrent;
    memberCount = widget.groupInfo.memberCount; //memberCount does not include userCurrent himself
    //if (chatMemberId1 != null) {print("chatMember1:  " + chatMemberId1);}
    //if (chatMemberId2 != null) {print("chatMember2:  " + chatMemberId2);}
    //if (chatMemberId3 != null) {print("chatMember3:  " + chatMemberId3);}
    //if (userIdCurrent != null) {print ("userIdCurrent: " + userIdCurrent);}
    //if (memberCount != null) {print ("memberCount: " + memberCount.toString());}

    //covert to Array
    chatMemberId [0] = userIdCurrent; //set 0 for userIdCurrent
    chatMemberId[1] = chatMemberId1;
    chatMemberId[2] = chatMemberId2;
    if (memberCount > 2) {chatMemberId[3] = chatMemberId3;} // limited to 3 chatmember. need to further define more member if more than 3
    if (memberCount > 3) {chatMemberId[4] = chatMemberId4;} // this will not be used actually if your Max memberCount only limited at 3. will need to keep adding if want more.
    //for (int x=1; x<=memberCount; x++){print ("array: " + x.toString() + " " +chatMemberId[x]);}


    // get the current user image and name from userID
    Future getUserCurrentInfo() async {
      //var firebaseUser = await FirebaseAuth.instance.currentUser();
      Firestore.instance.collection("users").document(userIdCurrent).get()
          .then((value) {
        //print(value.data['name']);
        //setState(() {
        userNameCurrent = value.data['name'];
        userImageUrlCurrent = value.data['image'];
        //});
        //return value.data['name'];
        //print ("me: " + userNameCurrent);
        //print ("meImage: " + userImageUrlCurrent);
      });
    }
    getUserCurrentInfo();


    // naming the chat group in Array form
    //for (int x=0; x<maxGroup; x++){ //ChatGroup carries 0,1 and 2
    //  chatGroup[x] = "ChatGroup" + x.toString();
      //print (chatGroup[x]);
    //}

    //identify the next database slot to write message, or the oldest group to replace
    groupChatId() async {
      var chkMember = new List(5);
      String oldGroupId;
      String first4Char;
      int x;
      int m;
      int foundMatch;
      int notMatch;
      List <String> idList = [];
      oldGroupId = ""; // must sort the Id in order
      for (x=0; x <= memberCount; ++x) {
        idList.add (chatMemberId[x]);
        idList.sort();
        //first4Char = chatMemberId[x].toString();
        //print ("groupId: " + groupId);
        ////// how to sort this chatMemberId[x] here ???????
        //newGroupId = oldGroupId + chatMemberId[x].toString();
        //oldGroupId = newGroupId;
      }

      print (idList);
      //print ("groupId: "  + newGroupId);
      int len = idList.length;
      for (int x=0; x<len; ++x) {
        print (idList.sublist(x, x + 1).single);
        newGroupId = oldGroupId + idList.sublist(x, x + 1).single;
        oldGroupId = newGroupId;
      }

      print (newGroupId);

/*
      Firestore.instance.collection("GroupMsg").document(newGroupId).get().then((value) {
        if (value.data != null) {

        for (m=0; m<=memberCount; ++m) {
          foundMatch=-0;
          for (x=0; x<=memberCount; ++x){
            if (value.data["member" + x.toString()]!=null) {
              chkMember[x] = (value.data["member" + x.toString()]);
              if (chatMemberId[m] = chkMember[x]){foundMatch = 1;}
            } else{notMatch=1;} // must go create new chat Log.  not correct match bcos No of member less then expected, though it shouldnt be since the newGroupId is matched already
          }
          if (foundMatch == 0){notMatch = 1;} // must go create new chat Log.  one of chatMemberId already not matched
        }


        } else{notMatch=1;} // must go create new chat Log. not correct match becos no data at all, so create new group chat Log

        if (notMatch==1) {
          // create new chat log here
        }else {
          //use existing chat log
        }

      });
*/




/*
      int x;
      for (x=0; x < memberCount; ++x){
        if (chatMemberId [x].compareTo(chatMemberId [x+1]) > 0) {
          msgPath1 = meUserId;
          msgPath2 = youUserId;
        }
      }
*/
/*
      int oldestChatFound;
      int oldestChatTime = DateTime.now().millisecondsSinceEpoch;
      int memberMatched;
      int noMatch;
      int replaceFoundGp;
      int newGpForm;
      int replaceOldGp;

      replaceFoundGp = null;
      newGpForm = null;
      replaceOldGp = null;

      for (int gpCount = 0; gpCount < maxGroup; gpCount++) { //chatGroup carry 0,1 and 2
        //print ("gpCount starts from: " + gpCount.toString());
        await Firestore.instance.collection("GroupMsg").document(chatGroup[gpCount])
            .get().then((value) {

          // do group matching here, if matching found, quit
          if (value.data != null) {
            //print ("non null gpCount " + gpCount.toString());
            int thisMemberCount = (value.data['memberCount']); //thisMemberCount does not include userCurrent. So the number is 1 less then actual total chat member number
            if (thisMemberCount == memberCount){ //do matching to see if this is the group you looking for
              thisMemberId[0] =  (value.data['member0']);
              thisMemberId[1] =  (value.data['member1']);
              thisMemberId[2] =  (value.data['member2']);
              if (thisMemberCount > 2) {thisMemberId[3] =  (value.data['member3']);} // depend on limit set by maxMember at users.dart. need to further add if maxMember is more
              if (thisMemberCount > 3) {thisMemberId[4] =  (value.data['member4']);} // maxMember limit not including userCurrent. So plus userCurrent, total chat memberCount will be plus one
              //print ("this: " + thisMemberCount.toString());
              //print ("memberCount passed on " + memberCount.toString());
              //print ("group: " + gpCount.toString());
              //print (thisMemberId[0] + " " + chatMemberId[0]);
              //print (thisMemberId[1] + " " + chatMemberId[1]);
              //print (thisMemberId[2] + " " + chatMemberId[2]);
              //print (thisMemberId[3] + " " + chatMemberId[3]);

              noMatch =0;
              for (int x = 0; x < memberCount + 1; x++){
                memberMatched =0;
                for (int y = 0; y < memberCount + 1; y++){
                  //print (chatMemberId[x] + " " + thisMemberId[y]);
                  if (chatMemberId[x] == thisMemberId[y]){memberMatched=1;}
                }
                if (memberMatched !=1){noMatch = 1;}
              }
              print ("Group: " + gpCount.toString()+ ".   noMatch: " + noMatch.toString());
              if (noMatch != 1){replaceFoundGp = gpCount;} //done no need do liao
            }
          }

          if (value.data != null) {
            int thisChatTime = (value.data['timeStamp']);
            //print("timestamp here: " + thisChatTime);
            if (thisChatTime.compareTo(oldestChatTime) < 0) {oldestChatTime = thisChatTime;replaceOldGp = gpCount;
            }
          } else {newGpForm = gpCount;}
          //print("timestamp here: " + gpToReplace.toString());
        });
      }

      //print ("replaceFoundGroup: " + replaceFoundGp.toString());
      if (replaceFoundGp != null){ gpToReplace = replaceFoundGp; continueCurrent=1;} //print("gp to replace: Match " + gpToReplace.toString());
      else {if (newGpForm !=null){gpToReplace = newGpForm;}  //print("gp to replace: New " + gpToReplace.toString());
      else {gpToReplace = replaceOldGp;} //print("gp to replace: Old " + gpToReplace.toString());
      }// && formNewGroup != 1){replaceOldest = 1;}
      print("gp to replace: " + gpToReplace.toString());
*/

    }
    groupChatId();

/*
    if (groupReplaceCheck != 1) {groupToReplace();groupReplaceCheck = 1;
      //print ("gpToReplace: " + gpToReplace.toString());
    } // not sure why, but without this conditioning, it keeps calling the method
*/

    // get all chatmember name and Image from their userID
    Future getChatMemberInfo() async {
      //print (chatMemberId[1]);
      for (int x = 1; x <= memberCount; x++) {
        Firestore.instance.collection("users").document(chatMemberId[x]).get()
            .then((value) {
          //print(value.data['name']);
          if (mounted)
            setState(() { // if dont set state, can print correct value here but somehow value cannot be passed to Scaffold widget below.
              chatMemberName[x] = value.data['name'];
              chatMemberImageUrl[x] = value.data['image'];
            });
          //return value.data['name'];
          //if (chatMemberName[1] != null) {print("1 " + chatMemberName[1]);}
          //if (chatMemberImageUrl[1] != null) {print("1 " + chatMemberImageUrl[1]);}
          //if (chatMemberName[2] != null) {print("2 " +chatMemberName[2]);}
          //if (chatMemberImageUrl[2] != null) {print("2 " +chatMemberImageUrl[2]);}
          //if (chatMemberName[3] != null) {print("3 " +chatMemberName[3]);}
          //if (chatMemberImageUrl[3] != null) {print("3 " +chatMemberImageUrl[3]);}
        });
      }
    }
    getChatMemberInfo();

    // getting the message sent by members from firestore
    Future getMsg() async {
      //final firebaseUser = await FirebaseAuth.instance.currentUser();
      //print ('gptoReplace (here): ' + gpToReplace.toString());
      //if (gpToReplace != null) {

        await Firestore.instance.collection("GroupMsg").document(newGroupId).get().then((value){
          if (value.data != null) {
            //continueCurrent = 1;
            if (mounted)
              setState(() {
                if (value.data[chatMemberId[1]] != null) {chatMemberMsg[1] = value.data[chatMemberId[1]];} // note: chatMemberId[0] is userIdCurrent yourselves
                if (value.data[chatMemberId[2]] != null) {chatMemberMsg[2] = value.data[chatMemberId[2]];}
                if (value.data[chatMemberId[3]] != null) {chatMemberMsg[3] = value.data[chatMemberId[3]];} // if the limit is at 3 and need more, must further add line here
                if (value.data[chatMemberId[4]] != null) {chatMemberMsg[4] = value.data[chatMemberId[4]];}

                //if (value.data['msgLog'] != null) {oldGpMsgLog = value.data['msgLog'];} else{oldGpMsgLog = ".";}
                //if (checkIfMeYouTreeExisted() == true) {youMsg = value.data['lastMsg'];} //get the msg sent to me
                //if (checkIfMeYouTreeExisted() == true) {youMsgLogging = value.data['pastMsgLog'];} // get the msg that was log with me previously



                if (value.data['msgLog'] != null) {
                  List msgLogList = value.data['msgLog'];
                  int len = msgLogList.length;
                  //print ("len: " + len.toString());
                  //print (msgLogList .sublist(0,1).single);
                  //print (msgLogList .sublist(1,2).single);
                  //print (msgLogList .sublist(2,3).single);
                  //print (msgLogList .sublist(3,4).single);
                  oldMsgList = "";
                  for (int x=0; x<len; ++x) {
                    oldGpMsgLog =  msgLogList.sublist(x,x+1).single + "\n" + oldMsgList;
                    oldMsgList = oldGpMsgLog ;
                  }
                  //print ("log: " + youMeMsgLog);
                  //youMeMsgLog = value.data['pastMsgLog'];
                  //print ("captured 2?: " + youMeMsgLog);
                }




              });
          }//else {continueCurrent = 0;}
        });

      //}

/*
      Firestore.instance.collection("OneOneMsg").document(youUserId).collection("msgFrom").document(meUserId)
          .get()
          .then((value) {
        if (value.data != null) {
          if (mounted)
            setState(() {
              //if (checkIfYouMeTreeExisted() == true) {meMsgLogging = value.data['pastMsgLog'];} // get the msg that was log with me previously
              if (value.data['pastMsgLog'] != null) {meMsgLogging = value.data['pastMsgLog'];}
            });
        }
      });
 */
    }
    getMsg();
    //if (continueCurrent == 1) {getMsg();}


    updateChat (){
      //Firestore.instance.collection("GroupMsg").document(chatGroup[gpToReplace])
      //    .updateData({"member0": userIdCurrent}); // here we just named user as 'member0'. member[0] in the array still not used. Let's reserved that.
      //Firestore.instance.collection("GroupMsg").document(chatGroup[gpToReplace])
      //    .updateData({"member1": chatMemberId[1]});
      //Firestore.instance.collection("GroupMsg").document(chatGroup[gpToReplace])
      //    .updateData({"member2": chatMemberId[2]});
      //if (memberCount > 2){Firestore.instance.collection("GroupMsg").document(chatGroup[gpToReplace])
      //    .updateData({"member3": chatMemberId[3]});} // limited to 3 chatmember. need to further define more member if more than 3
      //Firestore.instance.collection("GroupMsg").document(chatGroup[gpToReplace])
      //    .updateData({"pastMsgLog": userNameCurrent + ":" + meSay.text + " | " +  meMsgLogging});
      Firestore.instance.collection("GroupMsg").document(newGroupId)
          .updateData({userIdCurrent: meSay.text});

      //int limitLength = min (300, oldGpMsgLog.length);
      //oldGpMsgLog = oldGpMsgLog.substring(0,limitLength);


      //Firestore.instance.collection("GroupMsg").document(chatGroup[gpToReplace])
      //    .updateData({"msgLog": userNameCurrent + ": " +  meSay.text + "\n" + oldGpMsgLog });

      Firestore.instance.collection("GroupMsg").document(newGroupId)
          .updateData({"msgLog" : FieldValue.arrayUnion([userNameCurrent+ ": " + meSay.text])});

      Firestore.instance.collection("GroupMsg").document(newGroupId)
          .updateData({"timeStamp": DateTime.now().millisecondsSinceEpoch});
      meSay.clear();
    }


    setChat (){
      Firestore.instance.collection("GroupMsg").document(newGroupId)
          .setData({userIdCurrent: meSay.text});


      Firestore.instance.collection("GroupMsg").document(newGroupId)
          .updateData({"memberCount": memberCount});
      Firestore.instance.collection("GroupMsg").document(newGroupId)
          .updateData({"member0": userIdCurrent}); // here we just named user as 'member0'. member[0] in the array still not used. Let's reserved that.
      Firestore.instance.collection("GroupMsg").document(newGroupId)
          .updateData({"member1": chatMemberId[1]});
      Firestore.instance.collection("GroupMsg").document(newGroupId)
          .updateData({"member2": chatMemberId[2]});
      if (memberCount > 2){Firestore.instance.collection("GroupMsg").document(newGroupId)
          .updateData({"member3": chatMemberId[3]});} // if limited to 3 chatmember and need more, must further set up fireStore field for more members here
      if (memberCount > 3){Firestore.instance.collection("GroupMsg").document(newGroupId)
          .updateData({"member4": chatMemberId[4]});}


      //Firestore.instance.collection("GroupMsg").document(chatGroup[gpToReplace])
      //    .updateData({"pastMsgLog": userNameCurrent + ":" + meSay.text + " | " +  meMsgLogging});
      //Firestore.instance.collection("GroupMsg").document(chatGroup[gpToReplace])
      //.updateData({"msgLog": userNameCurrent + ": " +  meSay.text});


      Firestore.instance.collection("GroupMsg").document(newGroupId)
          .updateData({"msgLog" : FieldValue.arrayUnion([userNameCurrent+ ": " + meSay.text])});

      Firestore.instance.collection("GroupMsg").document(newGroupId)
          .updateData({"timeStamp": DateTime.now().millisecondsSinceEpoch});

      meSay.clear();
    }

    uploadMsg() async {
      Firestore.instance.collection("GroupMsg").document(newGroupId).get().then((value){
        if (value.data != null) {updateChat ();}
        else {setChat();}
      });

/*
      // check last upload timestamp and see if want delay then insert new time stamp
      await Firestore.instance
          .collection("GroupMsg").document(chatGroup[gpToReplace])
          .get()
          .then((value) {
        if (value.data != null) {
          if (value.data['timeStamp'] != null) {
            lastTimeStamp = value.data['timeStamp'];
          }
        }
      });
*/
      //print ("here....");
      //FirebaseAuth.instance.currentUser().then((user) {
      //if (user != null) {
      // if (gpMsgLog == null) {gpMsgLog = ".";}
      //if (meSay.text == null) {meSay.text  = ".";}
      //int limitLength = min (100, gpMsgLog.length);
      //gpMsgLog = gpMsgLog.substring(0,limitLength);
      //newGpMsgLog = userNameCurrent + ": " + meSay.text + " | ";
      //Map<String, String> userMap = {
      //  userIdCurrent: meSay.text,
      //"pastMsgLog": userNameCurrent + ":" + meSay.text + " | " +  meMsgLogging,
      //};
      //Firestore.instance.collection("GroupMsg").document(chatGroup[gpToReplace])
      //Firestore.instance.collection("GroupMsg").document("ChatGroup2")
      //.setData(userMap);

      //chatGroup[gpToReplace] = "ChatGroup0";
      // to do:  see if formNewGroup, replaceOldest or continueCurrent. if formNewGroup or replaceOldest then use set (if not used update), set will erase the existing data)
      // but must remember to set formNewGroup or replaceOldest to 0, else it will continue to set and erase when chat continue on
      //Firestore.instance.collection("GroupMsg").document(chatGroup[gpToReplace]).delete(); //delete first
//print ("cntinuousCurrrent: " + continueCurrent.toString());
      //if (continueCurrent !=1) {setChat(); continueCurrent=1;}
      //else {updateChat ();}
      //setChat();

      //}
      //});
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'GroupChat',
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
      ),
      body:
      //SingleChildScrollView(
      Builder(
          builder: (context) => Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child:
                              Text(chatMemberMsg[1] != null ? chatMemberMsg[1]
                                  :(chatMemberName[1] != null ? "I am " + chatMemberName[1] : "..."),
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 18,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey,
                                    child: ClipOval(child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child:
                                        (chatMemberImageUrl[1] != null && chatMemberImageUrl[1].toString() != "") ? Image.network(chatMemberImageUrl[1])
                                            :( (chatMemberImageUrl[1].toString() != "") ? Image.asset("assets/blank_1.jpg") : Image.asset("assets/default_icon1.jpg"))
                                    )))),
                          ),
                        ],
                      ),
                    ),


                    Expanded(
                      flex: 1,
                      child:  Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey,
                                    child: ClipOval(child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child:
                                        (chatMemberImageUrl[2] != null && chatMemberImageUrl[2].toString() != "") ? Image.network(chatMemberImageUrl[2])
                                            :( (chatMemberImageUrl[2].toString() != "") ? Image.asset("assets/blank_1.jpg"): Image.asset("assets/default_icon1.jpg"))
                                    )))),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child:
                              Text(chatMemberMsg[2] != null ? chatMemberMsg[2]
                                  :(chatMemberName[2] != null ? "I am " + chatMemberName[2] : "..."),
                                style: TextStyle(fontSize: 18,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ),


                    Expanded(
                      flex:1,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child:
                              Text(chatMemberMsg[3] != null ? chatMemberMsg[3]
                                  :(chatMemberName[3] != null ? "I am " + chatMemberName[3] : "..."),
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 18,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey,
                                    child: ClipOval(child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child:
                                        (chatMemberImageUrl[3] != null && chatMemberImageUrl[3].toString() != "") ? Image.network(chatMemberImageUrl[3])
                                            :( (chatMemberImageUrl[3].toString() != "") ? Image.asset("assets/blank_1.jpg") : Image.asset("assets/default_icon1.jpg"))
                                    )))),
                          ),
                        ],
                      ),

                    ),

                    Expanded( //if your chatMember limited at 3 and need more, must add more widget for more member here
                      flex:1,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey,
                                    child: ClipOval(child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child:
                                        (chatMemberImageUrl[4] != null && chatMemberImageUrl[4].toString() != "") ? Image.network(chatMemberImageUrl[4])
                                            :( (chatMemberImageUrl[4].toString() != "") ? Image.asset("assets/blank_1.jpg") : Image.asset("assets/default_icon1.jpg"))
                                    )))),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child:
                              Text(chatMemberMsg[4] != null ? chatMemberMsg[4]
                                  :(chatMemberName[4] != null ? "I am " + chatMemberName[4] : "..."),
                                style: TextStyle(fontSize: 18,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ),



                    Expanded(
                      flex:1,
                      child: Row(
                        children: <Widget>[
                          SizedBox (width: 15),
                          Expanded(
                            flex: 5,

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
                                uploadMsg();
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
                          SizedBox (width: 10),
                        ],
                      ),
                    ),

                    //Row(children: <Widget>[

                    Expanded(
                        flex:5,

                        child: SingleChildScrollView(
                          //reverse: true,
                          scrollDirection: Axis.vertical,//.horizontal

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15,10,10,0),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                oldGpMsgLog != null? oldGpMsgLog : "...",
                                //textAlign: TextAlign.left,
                                style:
                                //Alignment.topLeft,
                                TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),


                          ),
                        )
                    ),
                  ]
              )
          )),
    );
  }
}
