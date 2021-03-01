import 'dart:developer';
import 'dart:io';

//import 'package:famchat/overflowbutton.dart';
//import 'package:famchat/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:path/path.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:oneteam/users.dart';

import 'model/user.dart';
//import 'package:famchat/model/user.dart';
class ProfileSettings extends StatefulWidget {

  final User userInfo; // only userId is passed from main.dart and from users.dart, the rest are not
  ProfileSettings({this.userInfo});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {

  int flag;
  File _image;
  String userId;
  String userName;
  String userImageUrl;
  String existingImageUrl;
  final firestoreInstance = Firestore.instance;
  //final firebaseUser = FirebaseAuth.instance.currentUser();

  @override
  void initState() {
    super.initState();
    //FirebaseAuth.instance.currentUser().then((user) {userId = user.uid;});
  }

  @override
  Widget build(BuildContext context) {
    userId = widget.userInfo.userId;
    Future getUserName() async {
      var firebaseUser = await FirebaseAuth.instance.currentUser();
      firestoreInstance.collection("users").document(userId).get().then((value) {
        //print(value.data['name']);
        setState(() {
          userName = value.data['name'];
          existingImageUrl = value.data['image'];

        });
        //if (existingImageUrl == "") {existingImageUrl = "https://images.unsplash.com/photo-1487260211189-670c54da558d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80";}
        //if (existingImageUrl == "") {existingImageUrl = "";}
        //print ("image Url: " + existingImageUrl + "  x");
        //return value.data['name'];
      });
    }
    getUserName();

    Future getImage(ImageSource source) async {
      var image = await ImagePicker.pickImage(source: source);
      //File compressedImage = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (image != null) {
        File cropped = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            compressQuality: 100,
            maxWidth: 500,
            maxHeight: 500,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.blue,
              toolbarTitle: "Crop it",
            ));
        setState(() {
          _image = cropped;
          flag=1;
        });
      }
    }

    Future uploadImage(BuildContext context) async {
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(userId);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      var downloadUrl = await taskSnapshot.ref.getDownloadURL();

      Firestore.instance
          .collection("users")
          .document(userId)
          .updateData({'image': downloadUrl});
      setState(() {
        userImageUrl = downloadUrl;
        Navigator.push(context, MaterialPageRoute(builder: (context) => Users()));
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
      ),
      body: Builder(
        //to put the body content outside scaffold
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey,
                          child: ClipOval(
                              child: SizedBox(
                                  width: 180.0,
                                  height: 180.0,

                                  child: _image != null ? Image.file(_image, fit: BoxFit.fill) :
                                  (existingImageUrl != null && existingImageUrl != "" ? //dont know why must like that && then can avoid error
                                  Image.network(existingImageUrl) :
                                  Image.asset("assets/default_icon1.jpg"))
                              ))),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 100.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 30.0,
                          ),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          }, //can be either gallery or camera
                          //onPressed: (){getImage(ImageSource.camera);}, //if want can do another button for this
                        ))
                  ],
                ),
              ),
              SizedBox(height: 20.0),

              Text(
                (userName != null ? userName : ""),
                style: TextStyle(
                  fontSize: 20.0,
                  letterSpacing: 1,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10.0),
              FlatButton(
                onPressed: () {
                  flag !=1 ? Navigator.push(context, MaterialPageRoute(builder: (context) => Users()))
                      : uploadImage(context);
                },
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );




  }
}