import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneteam/project1.dart';
import 'package:oneteam/teampage.dart';
import 'model/projectinfo.dart';

class TeamProject extends StatefulWidget {
  @override
  _TeamProjectState createState() => _TeamProjectState();
}

class _TeamProjectState extends State<TeamProject> {

  String userIdCurrent;
  int connected;
  final FirebaseMessaging _messaging = FirebaseMessaging(); /////
  String tokenId;

  @override
  void initState() {
    super.initState();
    _messaging.getToken().then((token) {print (token);tokenId = token;}); // any user come into TeamProject, the tokenID will be logged to Firebase
    FirebaseAuth.instance.currentUser().then((user) {if (mounted) setState(() {
      if (user != null) {
        userIdCurrent = user.uid;

      } else {}
    });
    });
  }


  Future getUsers()async {
    QuerySnapshot qn =
    await Firestore.instance.collection(userIdCurrent).getDocuments();
    //print ("here A: " + qn.documents.length.toString());
    int docLength = qn.documents.length; ////
    if (docLength != null) {
      for (int x = 0; x < docLength; ++x) ////
          {String pName = qn.documents[x].data['project']; ////
      print("pName: " + pName);
      // go to all project and insert token to my name
      Firestore.instance.collection(pName).document(userIdCurrent).setData({
        "tokenId": tokenId
      }, merge: true);
      }
    }
    return qn.documents; // this return all the documents (an Array snapshot) in users collection
  }

  @override
  Widget build(BuildContext context) {
/*
    FirebaseAuth.instance.currentUser().then((user) async {
      userIdCurrent = user.uid;

      Firestore.instance.collection(userIdCurrent).snapshots().listen((data) async { // can I do the qn snapshot thing then do a list view like users?
        print("no of project: " + data.documents.length.toString());
        for (int i = 0; i<data.documents.length; i++){
          print(data.documents[i]['project']);}
      });

  });
*/


    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TeamPage()));
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: 26.0,
                  ),
                )),

          ],

          title: Text(
            'Team Projects',
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
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: FutureBuilder(
              future: getUsers(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ) {
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
                              String _projectName = snapshot.data[index].data['project'];
                              String _projectObjective = snapshot.data[index].data['objective'];
                              final projectInfo = ProjectInfo(projectName: _projectName, projectObjective: _projectObjective);
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => Experiment ());
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Project1 (projectInfo: projectInfo)));
                            },

                            child: Row(
                              children: <Widget>[
                                SizedBox(height: 60),
                                Flexible(
                                  //flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration (
                                      //border: Border.all(color: Colors.blue, width: 2),
                                      color: Colors.blue [50],
                                      borderRadius: BorderRadius.circular(30.0),

                                      //color: Colors.indigo,
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: Text(
                                        snapshot.data[index].data['project'],
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                          //fontWeight: FontWeight.bold
                                        ),

                                      ),
                                    ),
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
