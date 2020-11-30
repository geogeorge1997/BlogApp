import 'package:flutter/material.dart';

class PostItem extends StatefulWidget {
  //final String dp;
  final String name;
  final String time;
  final String bio;
  //final String img;

  PostItem({
    Key key,
    //@required this.dp,
    @required this.name,
    @required this.time,
    @required this.bio
    //@required this.img
  }) : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: InkWell(
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            children: <Widget>[

              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    //"${widget.dp}",
                    'assets/images/logo.png',
                  ),
                  backgroundColor: Colors.white,
                ),

                contentPadding: EdgeInsets.fromLTRB(15,1, 15,1),
                title: Text(
                  "${widget.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  "${widget.time.substring(0,10)}",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 11,
                  ),
                ),
              ),

              /*Image.asset(
                'assets/images/logo.png',
                height: 100,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),*/

              Container(
                decoration: new BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                alignment: Alignment.center,
                height: 250,
                width: MediaQuery.of(context).size.width-30,
                child: Text(
                  "${widget.bio}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.white
                  ),
                ),
              ),
              SizedBox(height: 10,)
            ],
          ),
        ),

        onTap: (){
          print("Click post home");
        },
      ),
    );
  }
}