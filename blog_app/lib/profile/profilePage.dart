import 'dart:math';
import 'package:blog_app/profile/edit/profileEditPage.dart';
import 'package:blog_app/home/homePage.dart';
import 'package:blog_app/search/searchAccountPage.dart';
import 'package:blog_app/profile/postCreation/profilePostCreationPage.dart';
import 'package:blog_app/profile/profilePostListBloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blog_app/userModels/user.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.user,this.usersData}) : super(key: key);

  final Map usersData;
  final FirebaseUser user;

  userFileData() => createState()._userFileData();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final Firestore fireStore = Firestore.instance;
  static Random random = Random();

  String bio='';

  ProfilePostListBloc profilePostListBloc;

  ScrollController controller = ScrollController();

  void _userFileData(){
    print("user File Data");
  }

  @override
  void initState() {
    super.initState();
    print("Profile Page");
    profilePostListBloc=ProfilePostListBloc();
    profilePostListBloc.fetchFirstList(widget.user.uid);
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    print(controller.position.maxScrollExtent);
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      profilePostListBloc.fetchNextUsers(widget.user.uid);

    }
  }

  Widget _profileInfo(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                  widget.usersData['profilePicURL']
              ),
              radius: 50,
            ),
            SizedBox(height: 3),
            Text(
              widget.usersData['username'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          widget.usersData['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 3),
        Text(
          widget.usersData['email'],
          style: TextStyle(
          ),
        ),
        SizedBox(height: 3),
        Text(
          widget.usersData['bio'],
          style: TextStyle(
          ),
        ),
      ],
    );
  }

  Widget _homeButton(){
    return Expanded(
      child: FlatButton(
        child: Icon(
          Icons.home,
          color: Colors.white,
        ),
        color: Colors.black,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
              ),
            ),
          );
          print("Home");
        },
      ),
    );
  }

  Widget _editButton(){
    return Expanded(
      child: FlatButton(
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        color: Colors.black,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileEditPage(
                user: widget.user,
                usersData: widget.usersData,
              ),
            ),
          );
          print("Edit");
        },
      ),
    );
  }

  Widget _searchButton(){
    return Expanded(
      child: FlatButton(
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
        color: Colors.black,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchAccountPage(
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _addPostButton(){
    return Expanded(
      child: FlatButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        color: Colors.black,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePostCreationPage(
                user: widget.user,
                usersData:widget.usersData
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _settingsButton(){
    return Expanded(
      child: FlatButton(
        child: Icon(
          Icons.settings,
          color: Colors.white,
        ),
        color: Colors.black,
        onPressed: (){
          print("Settings");
        },
      ),
    );
  }

  Widget _pageNavigationBar(){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _homeButton(),
        SizedBox(width: 5),
        _editButton(),
        SizedBox(width: 5),
        _searchButton(),
        SizedBox(width: 5,),
        _addPostButton(),
        SizedBox(width: 5),
        _settingsButton()
      ],
    );
  }

  Widget _followBar(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildCategory("Posts"),
          _buildCategory("Friends"),
          _buildCategory("Groups"),
        ],
      ),
    );
  }

  Widget _postList(){

    String bio='';

    return StreamBuilder<List<DocumentSnapshot>>(

      stream: profilePostListBloc.profilePostStream,
      builder: (context, snapshot) {
        print("Snap $snapshot");
        if (snapshot.data != null) {

          return GridView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            physics: NeverScrollableScrollPhysics(),
            primary: false,
            padding: EdgeInsets.all(5),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 200 / 200,
            ),
            //controller: controller,
            itemBuilder: (BuildContext context, int index) {

              bio=snapshot.data[index]["post"];

              return Padding(
                padding: EdgeInsets.all(1.0),
                child: Card(
                  child:  ListTile(
                    onLongPress: (){
                      print(snapshot.data[index]["postId"]);
                    },
                    title: Text(bio,textAlign: TextAlign.center),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

  }


  Future<void> _onRefreshIndicator()async{
    print("Refreshed");

    User instance=User(user: widget.user);
    await instance.userData();
    print(instance.usersData.data);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          user: widget.user,
          usersData: instance.usersData.data,
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
          title: Text("Profile"),
          textTheme:Theme.of(context).textTheme.apply(
            fontFamily: 'Bebas Neue Regular',
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefreshIndicator,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10),
            controller: controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                _profileInfo(),
                SizedBox(height: 20),
                _pageNavigationBar(),
                SizedBox(height: 40),
                _followBar(),
                SizedBox(height: 20),
                _postList(),
                //CircularProgressIndicator()
              ],
            ),
          ),
        )
    );
  }

  Widget _buildCategory(String title){
    return Column(
      children: <Widget>[
        Text(
          random.nextInt(10000).toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
          ),
        ),
      ],
    );
  }
}