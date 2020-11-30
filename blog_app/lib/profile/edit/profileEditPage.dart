import 'package:blog_app/userModels/writeData.dart';
import 'package:blog_app/widget/image/picUploadPage.dart';
import 'package:blog_app/profile/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfileEditPage extends StatefulWidget {
  ProfileEditPage({Key key, this.user,this.usersData}) : super(key: key);

  final Map usersData;
  final FirebaseUser user;

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {

  final Firestore fireStore = Firestore.instance;

  String username='',oldUsername;
  bool usernameError=false;
  String name='';
  String bio='';
  String oldName;
  String oldBio;
  String email;
  String password;
  var profilePicURL;
  bool error=false;

  String userId;

  @override
  void initState() {
    super.initState();
    oldUsername=widget.usersData['username'];
    oldName=widget.usersData['name'];
    oldBio=widget.usersData['bio'];
    profilePicURL=widget.usersData['profilePicURL'];
    username=widget.usersData['username'];
    name=widget.usersData['name'];
    bio=widget.usersData['bio'];
  }

  Future<void> _usernameCheck() async {
    if(username.length>=3){
      //username letter check
      var value=await fireStore.collection('username').document(username).get();
      print(value.data);
      if(value.data==null || username==oldUsername){
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

    WriteUserData instance=WriteUserData();

    try{
      if(usernameError || name.length<3){
        setState(() {
          error=true;
        });
      }
      else{
        setState(() {
          error=false;
        });
        if(!usernameError && oldUsername!=username){
          //_updateUsername();
          await instance.updateUsername(widget.user.uid, username, oldUsername);
        }
        if(name.length>=3 && name!=oldName){
          //_updateName();
          await instance.updateName(widget.user.uid, name);
        }
        if(bio!=oldBio){
          //_updateBio();
          await instance.updateBio(widget.user.uid, bio);
        }
      }
      await _gotoProfilePage();
    }
    catch(e){
      print("Error - "+e.message);
    }
  }

  /*

  Enter Code if wrong occurs

   */

  Future<void> _gotoProfilePage()async{
    print("Loading Profile Page from EditProfilePage");
    //Navigator.pop(context,);
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

  Future<void> _changeProfilePicture()async{
    var profilePictureURLq=await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePictureUpload(
          user: widget.user,
        ),
      ),
    );
    print(profilePicURL);
    setState(() {
      profilePicURL=profilePictureURLq;
    });

    WriteUserData instance=WriteUserData();
    await instance.updateProfilePicture(widget.user.uid, profilePicURL);
    //await _updateProfilePicture();
  }

  Widget _changeProfilePictureLabel(){
    return InkWell(
      onTap: () {
        _changeProfilePicture();
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
          SizedBox(
            height: 10,
          ),
          error?
          TextField(
            decoration: InputDecoration(
              hintText: 'Error Found',
              hintStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 3),
              ),
            ),
          ):SizedBox(
            height: 0,
          ),
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
          SizedBox(
            height: 10,
          ),
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
              hintText: username,
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
          SizedBox(
            height: 10,
          ),
          TextField(
            onChanged: (value) => name = value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person,color: Colors.blueGrey,),
              hintText: name,
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
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 2,
            onChanged: (value) => bio = value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.assignment,color: Colors.blueGrey,),
              hintText: bio,
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

  Widget _editConfirmButton() {
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
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Edit Profile"),
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
              _accountProfilePicture(),
              _changeProfilePictureLabel(),
              _errorFoundField(),
              _userNameField(),
              _nameField(),
              _bioField(),
              _editConfirmButton()
            ],
          ),
        ),
      ),
    );
  }
}

/*

Future<void> _updateProfilePicture()async{
    await fireStore.collection("users")
        .document(widget.user.uid)
        .updateData({'profilePicURL': profilePicURL,}).then((_) {
      print("Name Updated $profilePicURL");
    });
  }

Future<void> _updateUsername()async{
    await fireStore.collection("users")
        .document(widget.user.uid)
        .updateData({'username': username,}).then((_) {
      print("Username Updated $username");
    });

    await fireStore.collection('username').document(username).setData(
        {'user-id':widget.user.uid}
    );
    print('New Username Created in Users');
    await fireStore.collection('username').document(oldUsername).delete().then((_){
      print('Old username in Users Deleted $oldUsername');
    });
  }

  Future<void> _updateName()async{
    await fireStore.collection("users")
        .document(widget.user.uid)
        .updateData({'name': name,}).then((_) {
      print("Name Updated $name");
    });
  }

  Future<void> _updateBio()async{
    await fireStore.collection("users")
        .document(widget.user.uid)
        .updateData({'bio': bio,}).then((_) {
      print("Bio Updated $bio");
    });
  }

 */