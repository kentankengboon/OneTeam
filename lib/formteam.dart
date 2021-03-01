import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneteam/teamproject.dart';
import 'package:toast/toast.dart';

import 'createproject.dart';
import 'model/projectinfo.dart';

class FormTeam extends StatefulWidget {

  final ProjectInfo projectInfo;
  FormTeam({this.projectInfo});

  @override
  _FormTeamState createState() => _FormTeamState();
}

class _FormTeamState extends State<FormTeam> {
  final ProjectInfo projectInfo;
  _FormTeamState({this.projectInfo});

  int connected = 0;
  int toShow;
  List<bool> mCheck = new List<bool>();
  String userIdCurrent;
  String userEmailCurrent;
  int maxMember = 4;
  String tooMany;
  int pickCount;
  var projMemberId = new List(5);
  //var projMemberName = new List(5);
  //var projMemberImage = new List(5);
  //var projMemberEmail = new List(5);
  int totalUserSize;
  String projectName2;



  @override
  void initState() {
    super.initState();



    //print ("at init1: " + p.projectInfo.projectName);
    //String ProjectObjective = FormTeam().projectInfo.projectObjective;

    FirebaseAuth.instance.currentUser().then((user) async {
      userIdCurrent = user.uid;
      await Firestore.instance.collection("users").document(userIdCurrent).get().then((val) async {
        userEmailCurrent = val.data["email"];
        //print (userEmailCurrent);
        getUsers();

      });
      //await updateImage(); <<< might need, shut first
    });

    userSize(); //<<< might need, shut first
    setState(() {
      //projectName2 = p.projectInfo.projectName;
      //print ("at init: " + projectName2);
    });
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
    QuerySnapshot qn =  await Firestore.instance.collection("users").getDocuments();
    //print ("here A: " + qn.documents.length.toString());
    //docLength = qn.documents.length.toString();
    return qn.documents; // this return all the documents (an Array snapshot) in users collection
  }





  YouUserId(AsyncSnapshot snapshot, index) {
    return snapshot.data[index].data['userId'];
  }

  toShowImage(AsyncSnapshot snapshot, index) {
    if (snapshot.data[index].data['image'] != "" && snapshot.data[index].data['image'] != null) {
      toShow = 1;
    } else {
      toShow = 0;
    }
    return toShow;
  }

  @override
  Widget build(BuildContext context) {


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
                //projMemberName[pCount] = val.documents[x]['name'];
                //projMemberImage[pCount] = val.documents[x]['image'];
                //projMemberEmail[pCount] = val.documents[x]['email'];
              } else {
                tooMany = "yes";
              }
            }
          }

          if (projMemberId[1] != null) {print ("project Member 1: " + projMemberId[1]);}
          if (projMemberId[2] != null) {print ("project Member 2: " + projMemberId[2]);}
          if (projMemberId[3] != null) {print ("project Member 3: " + projMemberId[3]);}
          if (projMemberId[4] != null) {print ("project Member 4: " + projMemberId[4]);}
          print ("wwwwwidget: " + widget.projectInfo.projectName);
          print (pickCount);

          if (tooMany  == "yes"){Toast.show("Maximum members allowed is " + maxMember.toString(), context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);}
          else{

            //Firestore.instance.collection("projects").document(widget.projectInfo.projectName)
            //    .setData({"project": widget.projectInfo.projectName});

            Firestore.instance.collection(widget.projectInfo.projectName).document(userIdCurrent)
                .setData({"userId": userIdCurrent});
            Firestore.instance.collection(userIdCurrent).document(widget.projectInfo.projectName)
                .setData({"project": widget.projectInfo.projectName});
            Firestore.instance.collection(userIdCurrent).document(widget.projectInfo.projectName)
                .updateData({"objective": widget.projectInfo.projectObjective});

            for (int i=1; i <= pickCount; i++){
              //print ("here: " + i.toString());
              Firestore.instance.collection(widget.projectInfo.projectName).document(projMemberId[i])
                  .setData({"userId": projMemberId[i]});
              Firestore.instance.collection(projMemberId[i]).document(widget.projectInfo.projectName)
                  .setData({"project": widget.projectInfo.projectName});

            }
            Navigator.push(context, MaterialPageRoute(builder: (context) => TeamProject()));

          } // do the data writing here

        });
      });
      //print("tooMany before go:  " + tooMany);
      //print ("project Member 1: " + projMemberId[1]);
      //print ("wwwwwidget: " + widget.projectInfo.projectName);
    }







    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(0,15,10,0),
                child: GestureDetector(
                  onTap: () {
                    groupPick();


                  },
                  child: Text("ok",style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),),
                )),

            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProject()));
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: 26.0,
                  ),
                )),



          ],
          title: Text(
            'pick members',
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
        ),


        body: //UserPage(),


        Container(
          child: FutureBuilder(
              future: getUsers(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    connected == 0) {
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

                          title: GestureDetector(onTap: () {},

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
                                        //groupPick();
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  );
                } ///////else
              }),
        )

    );
  }
}
