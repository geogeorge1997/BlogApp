import 'package:blog_app/widget/image/picUploadPage.dart';
import 'package:blog_app/profile/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({Key key, this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {

  final Firestore fireStore = Firestore.instance;

  String username='';
  bool usernameError=false;
  String name='';
  String bio='';
  String profilePicURL='https://firebasestorage.googleapis.com/v0/b/blogapp-126d6.appspot.com/o/ProfilePicture%2Flogo%2Flogo.png?alt=media&token=22163166-66d9-4926-acb4-b44729035755';
  bool error=false;

  Future<void> _usernameCheck() async {
    if(username.length>=3){
      //username letter check
      var value=await fireStore.collection('username').document(username).get();
      print(value.data);
      if(value.data==null){
        setState(() {usernameError=false;});
      }
      else{
        setState(() {usernameError=true;});
      }
    }
    else{
      setState(() {usernameError=true;});
    }
  }

  Future<void> _saveChanges()async{
    if(usernameError || name.length<3){
      setState(() {
        error=true;
      });
    }
    else{
      setState(() {
        error=false;
      });
      if(!usernameError && name.length>=3){
        _createAccountData();
      }
    }
  }

  Future<void> _createAccountData()async{
    await fireStore.collection('users').document(widget.user.uid).setData({
      'profilePicURL':profilePicURL,
      'username':username,
      'name':name,
      'uid':widget.user.uid,
      'bio':bio,
      'email':widget.user.email,
      'date': DateTime.now().toIso8601String().toString(),
    });
    await fireStore.collection('username').document(username).setData(
        {'userid':widget.user.uid}
    );
    await _gotoProfilePage();
  }

  Future<void> _gotoProfilePage()async{
    print("Loading Profile from CreateProfilePage");
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          user: widget.user,
          usersData: {'profilePicURL':profilePicURL,
            'username':username,
            'name':name,
            'uid':widget.user.uid,
            'bio':bio,
            'email':widget.user.email,
            'date': DateTime.now().toIso8601String().toString(),},
        ),
      ),
    );
  }

  Widget _accountProfilePicture(){
    try{
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                    profilePicURL
                ),
                radius: 50,
              ),
            ],
          ),
        ],
      );
    }
    catch(e){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/images/logo.png'
                ),
                radius: 50,
              ),
            ],
          ),
        ],
      );
    }
  }

  Future<void> _changeProfilePic()async{
    var profilePicURLq=await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePictureUpload(
          user: widget.user,
        ),
      ),
    );
    print(profilePicURL);
    setState(() {
      profilePicURL=profilePicURLq;
    });
  }

  Widget _changeProfilePictureLabel(){
    return InkWell(
      onTap: () {
        _changeProfilePic();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Text('Change Profile Picture',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _errorFoundField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10,),
          error?
          TextField(
            decoration: InputDecoration(
              hintText: 'Error Found',
              hintStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 3),
              ),
            ),
          ):SizedBox(height: 0,),
        ],
      ),
    );
  }

  Widget _userNameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10,),
          Text('Username'),
          TextField(
            onChanged: (value) {
              username=value;
              _usernameCheck();
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.alternate_email,color: Colors.blueGrey,),
              suffixIcon: usernameError?
              Icon(Icons.cancel,color: Colors.red,):
              Icon(Icons.check,color: Colors.green,),
              hintText: 'Username',
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

  Widget _nameField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10,),
          TextField(
            onChanged: (value) => name = value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person,color: Colors.blueGrey,),
              hintText: 'Name',
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
              hintText: 'Bio',
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
            _saveChanges();
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
        backgroundColor: Colors.blueGrey,
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
              _accountProfilePicture(),
              _changeProfilePictureLabel(),
              _errorFoundField(),
              _userNameField(),
              _nameField(),
              _bioField(),
              _saveChangesButton()
            ],
          ),
        ),
      ),
    );
  }

}