import 'package:blog_app/home/homePostListBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blog_app/home/post_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Firestore fireStore = Firestore.instance;

  HomePostListBloc homePostListBloc;

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    print("Profile Page");
    homePostListBloc=HomePostListBloc();
    homePostListBloc.fetchFirstList();
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    print(controller.position.maxScrollExtent);
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      homePostListBloc.fetchNextUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        textTheme:Theme.of(context).textTheme.apply(
          fontFamily: 'Bebas Neue Regular',
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
            ),
            onPressed: (){
              print("Home Icon Click");
            },
          ),
        ],
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(

        stream: homePostListBloc.homePostStream,
        builder: (context, snapshot) {

          if (snapshot.data != null) {

            return ListView.builder(

              itemCount: snapshot.data.length,
              shrinkWrap: true,
              controller: controller,
              itemBuilder: (context, index) {

                return PostItem(
                  //img: post['img'],
                  name: snapshot.data[index]["username"],
                  //dp: post['dp'],
                  time: snapshot.data[index]["date"],
                  bio: snapshot.data[index]["bio"],
                );

              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}