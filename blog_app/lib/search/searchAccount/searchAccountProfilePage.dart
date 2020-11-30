import 'dart:math';
import 'package:blog_app/home/homePage.dart';
import 'package:blog_app/search/searchAccountPage.dart';
import 'package:blog_app/profile/profilePostListBloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchAccountProfilePage extends StatefulWidget {
  SearchAccountProfilePage({Key key, this.user}) : super(key: key);

  final String user;

  @override
  _SearchAccountProfilePageState createState() => _SearchAccountProfilePageState();
}

class _SearchAccountProfilePageState extends State<SearchAccountProfilePage> {

  final Firestore fireStore = Firestore.instance;
  static Random random = Random();

  ProfilePostListBloc profilePostListBloc;

  ScrollController controller = ScrollController();

  String username='';
  String name='';
  String email='';
  String bio='';
  String profilePicURL='https://firebasestorage.googleapis.com/v0/b/mychatdemo-f3693.appspot.com/o/ProfilePicture%2Flogo%2Flogo.png?alt=media&token=7a2d4163-91a3-4939-ab80-c0815e86bb36';
  bool imageLoaded=false;

  @override
  void initState() {
    super.initState();
    _searchUserData();
    print("Search User Profile Page");
    profilePostListBloc=ProfilePostListBloc();
    profilePostListBloc.fetchFirstList(widget.user);
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      profilePostListBloc.fetchNextUsers(widget.user);
    }
  }

  Future<void> _searchUserData()async{
    var result=await fireStore.collection('users').document(widget.user).get();
    print(result);
    setState(() {
      username=result.data['username'];
      print(username);
      name=result.data['name'];
      email=result.data['email'];
      bio=result.data['bio'];
      profilePicURL=result.data['profilePicURL'];
      imageLoaded=true;
    });
    print(profilePicURL);
  }

  Widget _profileInfo(){
    if(imageLoaded){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                    profilePicURL
                ),
                radius: 50,
              ),
              SizedBox(height: 3),
              Text(
                username,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 3),
          Text(
            email,
            style: TextStyle(
            ),
          ),
          SizedBox(height: 3),
          Text(
            bio,
            style: TextStyle(
            ),
          ),
        ],
      );
    }
    else{
      return Center(
        child: CircularProgressIndicator(),
      );
    }
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
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.all(1.0),
                child: Card(
                  child:  ListTile(
                    onTap: (){
                      print("Tap - "+snapshot.data[index]["postId"]);
                    },
                    onLongPress: (){
                      print("LongPress - "+snapshot.data[index]["postId"]);
                    },
                    title: Text(snapshot.data[index]["postId"],textAlign: TextAlign.center,),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Search Profile"),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              _profileInfo(),
              SizedBox(height: 40),
              _followBar(),
              SizedBox(height: 20),
              _postList(),
            ],
          ),
        ),
      ),
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