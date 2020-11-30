import 'package:blog_app/profile/profilePage.dart';
import 'package:blog_app/userModels/writeData.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePostCreationPage extends StatefulWidget {
  ProfilePostCreationPage({Key key, this.user,this.usersData}) : super(key: key);

  final Map usersData;
  final FirebaseUser user;

  @override
  _ProfilePostCreationPageState createState() => _ProfilePostCreationPageState();
}

class _ProfilePostCreationPageState extends State<ProfilePostCreationPage> {

  final Firestore fireStore = Firestore.instance;

  String bio='';
  String photoURL='https://firebasestorage.googleapis.com/v0/b/mychatdemo-f3693.appspot.com/o/ProfilePicture%2Flogo%2Flogo.png?alt=media&token=7a2d4163-91a3-4939-ab80-c0815e86bb36';
  String uName;
  Future<void> _createUsersData()async{

    print(bio);
    uName=widget.usersData["username"];
    print(uName);

    if(bio!=''){
      String userId=widget.user.uid;
      String date=DateTime.now().toIso8601String().toString();
      String postId=userId+date;

      WriteUserData instance=WriteUserData();
      await instance.createUserData(userId,postId,bio,date,uName);
      await _gotoProfilePage();
    }
    else
      {
        print("Pop from Profile Post Creation Page");
        Navigator.pop(context);
      }
  }

  Future<void> _gotoProfilePage()async{
    print("Loading Profile from User Data Profile");
    Navigator.pop(context);
    ProfilePage().userFileData();

    //check whether below statement executes or not
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          user: widget.user,
          usersData: widget.usersData,
        ),
      ),
    );

  }


  Widget _bioField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10,),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 2,
            onChanged: (value) => bio = value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.assignment,color: Colors.blueGrey,),
              hintText: 'Add',
              hintStyle: TextStyle(fontWeight: FontWeight.bold),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey, width: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveChangesButton() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.white,
        elevation: 6.0,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          //highlightColor: Colors.red,
          onPressed: (){
            _createUsersData();
          },
          minWidth: MediaQuery.of(context).size.width,
          child: Text(
            'Save Changes',
            style: TextStyle(
                fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Add New Post"),
        textTheme:Theme.of(context).textTheme.apply(
          fontFamily: 'Bebas Neue Regular',
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              _bioField(),
              _saveChangesButton()
            ],
          ),
        ),
      ),
    );
  }

}