
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oneteam/teampage.dart';
import 'model/projectinfo.dart';
import 'formteam.dart';
import 'model/user.dart';


class CreateProject extends StatefulWidget {

  //final User userInfo; // only userId is passed from main.dart and from users.dart, the rest are not
  //CreateProject({this.userInfo});

  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {

  final formkey = GlobalKey<FormState>();
  TextEditingController mProjectName = new TextEditingController();
  TextEditingController mObjective = new TextEditingController();
  //TextEditingController mPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    //print(widget.userInfo.userId);

    return new WillPopScope(
      onWillPop: () async => false,//to prevent back button clicking
      child: Scaffold(

        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Create Project',
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TeamPage()));
                    },
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      size: 26.0,
                    ),
                  )),
            ]

        ),


        body: Container(

          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField (
                  validator: (val){ return
                    val.isEmpty || val.length <3 ? "Project name is not valid" : null;},
                  controller: mProjectName,
                  decoration: InputDecoration(hintText: "Project Name"),
                ),
                TextField (
                  controller: mObjective,
                  decoration: InputDecoration(hintText: "Objective"),
                ),

                SizedBox (height: 15),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0,5,260,20),
                  child: FlatButton (
                    color: Colors.grey[800],

                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    child: Text("Team",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed:(){
                      final projectInfo = ProjectInfo(projectName: mProjectName.text, projectObjective: mObjective.text);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FormTeam(projectInfo: projectInfo)));
                    },
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}