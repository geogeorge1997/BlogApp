import 'package:blog_app/accountForm/createAccountPage.dart';
import 'package:blog_app/profile/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  final Firestore fireStore = Firestore.instance;

  bool error=false;

  void processInput() async{

    try{
      var result=await fireStore.collection('users').document(widget.user.uid).get();
      if(result.data==null){
        print("User Data is Empty from Loading");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CreateAccountPage(
              user: widget.user,
            ),
          ),
        );
      }
      else{
        try{
          print("User Data is Available from Loading to Profile");
          //User instance=User(user: widget.user);
          //await instance.userData();
          //print(instance.usersData.data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                user: widget.user,
                usersData: result.data,
              ),
            ),
          );
        }
        catch(e){
          print("Error - "+e.message);
        }
      }
    }
    catch(e){
      print("Error - "+e.message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    processInput();

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
          ),
        )
    );
  }
}
