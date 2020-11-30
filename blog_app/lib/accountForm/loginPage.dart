import 'package:blog_app/accountForm/loadingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/accountForm/registerPage.dart';
import 'package:flutter/widgets.dart';
import 'package:blog_app/accountForm/forgotPasswordPage.dart';

class LoginPage extends StatefulWidget {

  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String email;
  String password;

  bool isButtonClicked=false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    try {
      FirebaseUser user = await auth.signInWithEmailAndPassword(email: email, password: password);
      if (!user.isEmailVerified) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingPage(
              user: user,
            ),
          ),
        );
        isButtonClicked=false;
      }
      else {
        _alertUserNotVerified(context);
      }

    } catch (e) {
      print("Error - "+e.message);
      _alertNetworkProblem(context);
      //_alertIncorrectEmailorPassword(context);
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

  Widget _passwordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock,color: Colors.blueGrey,),
              hintText: "Password",
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

  Widget _logInButton() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.white,
        elevation: 6.0,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: (){
            if(!isButtonClicked){
              loginUser();
              isButtonClicked=true;
            }
          },
          minWidth: MediaQuery.of(context).size.width,
          child: Text(
            'Log In',
            style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _forgotPasswordLabel(){
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
        //showAlertDialog(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.centerRight,
        child: Text('Forgot Password ?',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500,decoration: TextDecoration.underline)),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
      },
      child: Container(
        //color: Colors.red,
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,decoration: TextDecoration.underline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _emailField(),
        _passwordField()
      ],
    );
  }

  _alertIncorrectEmailorPassword(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      color: Colors.blueGrey,
      child: Text("Try Again",
        style: TextStyle(
            fontSize: 21,fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Login Error !",
          style: TextStyle(
              fontSize: 21,fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center),
      content: Text("Incorrect email or password. Please check again",
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

  _alertNetworkProblem(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      color: Colors.blueGrey,
      child: Text("Try Again",
        style: TextStyle(
            fontSize: 21,fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Network Error !",
          style: TextStyle(
              fontSize: 21,fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center),
      content: Text("Network Problem. Please check connection again",
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

  _alertUserNotVerified(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      color: Colors.blueGrey,
      child: Text("Try Again",
        style: TextStyle(
            fontSize: 21,fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("User Not Verified !",
          style: TextStyle(
              fontSize: 21,fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center),
      content: Text("Network Problem. Please check connection again",
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
                      SizedBox(height: 50),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      _logInButton(),
                      _forgotPasswordLabel(),
                      SizedBox(height: height * .073),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

}