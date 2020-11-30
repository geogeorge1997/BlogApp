import 'package:blog_app/search/searchAccountListBloc.dart';
import 'package:blog_app/search/searchAccount/searchAccountProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchAccountPage extends StatefulWidget {
  SearchAccountPage({ Key key }) : super(key: key);

  @override
  _SearchAccountPageState createState() => new _SearchAccountPageState();
}

class _SearchAccountPageState extends State<SearchAccountPage> {

  Widget appBarTitle = new Text("Search",
    style: new TextStyle(color: Colors.black),);
  Icon actionIcon = new Icon(Icons.search, color: Colors.black,);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController searchQuery = new TextEditingController();
  List<String> list;
  bool isSearching;
  String searchText = "";

  SearchAccountListBloc searchAccountListBloc;

  ScrollController controller = ScrollController();

  _SearchAccountPageState() {
    searchQuery.addListener(() {
      if (searchQuery.text.isEmpty) {
        setState(() {
          isSearching = false;
          searchText = "";
        });
      }
      else {
        setState(() {
          isSearching = true;
          searchText = searchQuery.text;
          print(searchText);
          searchAccountListBloc.fetchFirstList(searchText);
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchAccountListBloc = SearchAccountListBloc();
    print("Before First");
    searchAccountListBloc.fetchFirstList('');
    controller.addListener(_scrollListener);
    isSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: buildBar(context),
      /*
      AppBar(
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
      
      */
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: searchAccountListBloc.searchAccountStream,
        builder: (context, snapshot) {
          if (snapshot.data != null) {

            return ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              controller: controller,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: (){
                        print("Hello User");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchAccountProfilePage(
                              user: snapshot.data[index]['uid'],
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            snapshot.data[index]['profilePicURL']
                        ),
                      ),
                      title: Text(snapshot.data[index]["name"]),
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
      ),
    );
  }

  Widget buildBar(BuildContext context) {

    return new AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(icon: actionIcon, onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close, color: Colors.black,);
                this.appBarTitle = new TextField(
                  controller: searchQuery,
                  style: new TextStyle(
                    color: Colors.black,
                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.black),
                      hintText: "Search",
                      hintStyle: new TextStyle(color: Colors.black)
                  ),
                );
                _handleSearchStart();
              }
              else {
                _handleSearchEnd();
              }
            });
          },),
        ]
    );
  }

  void _handleSearchStart() {
    setState(() {
      isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.black,);
      this.appBarTitle =
      new Text("Search Sample", style: new TextStyle(color: Colors.black),);
      isSearching = false;
      searchQuery.clear();
    });
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      searchAccountListBloc.fetchNextUsers(searchText);
    }
  }

}