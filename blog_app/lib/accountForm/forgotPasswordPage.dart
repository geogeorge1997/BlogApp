import 'package:firebase_auth/firebase_auth.dart';
import 'package:blog_app/accountForm/loginPage.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  String email;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    try{
      await auth.sendPasswordResetEmail(email: email);
      _alertPasswordReset(context);
    }
    catch(e){
      _alertEmailError(context);
      print("Error - "+e.message);
    }
  }

  Widget _logo(){
    return Container(
      height: 100,
      child: Image.asset("assets/images/logo.png"),
    );
  }

  Widget _emailField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email,color: Colors.blueGrey,),
              hintText: "Email",
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

  Widget _verifyButton() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.white,
        elevation: 6.0,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          //highlightColor: Colors.red,
          onPressed: (){
            resetPassword(email);
          },
          minWidth: MediaQuery.of(context).size.width,
          child: Text(
            'Send Verification to Email',
            style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _emailField(),
      ],
    );
  }

  _alertPasswordReset(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      color: Colors.blueGrey,
      child: Text("Go To Login",
        style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold, color: Colors.white),textAlign: TextAlign.center,),
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Email Verification is send !",
          style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
      content: Text("Please create a new password ...",
          style: TextStyle(fontSize: 16, color: Colors.black),textAlign: TextAlign.justify),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _alertEmailError(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      color: Colors.blueGrey,
      child: Text("Ok",
        style: TextStyle(
            fontSize: 21,fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error !",
          style: TextStyle(
              fontSize: 21,fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center),
      content: Text("Please enter valid email...",
          style: TextStyle(fontSize: 16, color: Colors.black),
          textAlign: TextAlign.justify),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .12),
                    _logo(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _verifyButton(),
                    SizedBox(height: height * .14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}