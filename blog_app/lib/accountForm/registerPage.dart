import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/accountForm/loginPage.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String email;
  String password;
  String confirmPassword;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> registerUser() async {

    try{
      FirebaseUser user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      try {
        await user.sendEmailVerification();
        _alertEmailVerification(context);
        //return user.uid;
      } catch (e) {
        print("Error - "+e.message);
      }
    }
    catch(e){
      _alertRegistrationError(context);
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
      //color: Colors.blue,//Debuging process
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
      //color: Colors.blue,//Debuging process
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

  Widget _confirmPasswordField() {
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
            onChanged: (value) => confirmPassword = value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock,color: Colors.blueGrey,),
              hintText: "Re-type  Password",
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

  Widget _registerButton() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.white,
        elevation: 6.0,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          //highlightColor: Colors.red,
          onPressed: (){
            if(password==confirmPassword) {
              registerUser();
            }
            else{
              _alertPasswordMatch(context);
            }
          },
          minWidth: MediaQuery.of(context).size.width,
          child: Text(
            'Sign Up',
            style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Log In',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline),
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
        _passwordField(),
        _confirmPasswordField()
      ],
    );
  }

  _alertRegistrationError(BuildContext context) {
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
      title: Text("Registration Error !",
          style: TextStyle(
              fontSize: 21,fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center),
      content: Text("Incorrect email or Account alreday Exists. Please Try Again",
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

  _alertEmailVerification(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      color: Colors.blueGrey,
      child: Text("Log In",
        style: TextStyle(
            fontSize: 21,fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,),
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Verify Email !",
          style: TextStyle(
              fontSize: 21,fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center),
      content: Text("A verification link is send to your email. Please verify your link with in 24 hours",
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

  _alertPasswordMatch(BuildContext context) {
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
      title: Text("Password Doesn't Match !",
          style: TextStyle(
              fontSize: 21,fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center),
      content: Text("Password doesn't match in both fields",
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
                    _registerButton(),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
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