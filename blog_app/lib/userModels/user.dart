import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {

  var usersData;
  final Firestore fireStore = Firestore.instance;
  final FirebaseUser user;

  User({ this.user });

  Future<void> userData()async{
    usersData=await fireStore.collection('users').document(user.uid).get();
  }

}
