import 'dart:async';
import 'package:flutter/material.dart';
import 'package:blog_app/accountForm/loginPage.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  initState() {
    super.initState();
    new Timer(const Duration(milliseconds: 1900), onClose);
  }

  Widget _logo(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child:Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _logo()
            ],
          ),
        ),
      ),
    );
  }

  void onClose() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}