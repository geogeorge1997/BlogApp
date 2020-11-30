import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WriteUserData {

  //var usersData;
  final Firestore fireStore = Firestore.instance;

  //final FirebaseUser user;

  //WriteUserData({});

  Future<void> createUserData(String userId, String postId, String bio,
      String date, String uName) async {
    await fireStore.collection('users').document(userId).collection('posts')
        .document(postId).setData({
      //'photoURL':photoURL,
      'postId': postId,
      'date': date,
      'post':bio,
    });

    await fireStore.collection('posts').document(postId).setData({
      //'photoURL':photoURL,
      'bio': bio,
      'date': date,
      'username':uName
    });
  }

  Future<void> updateProfilePicture(String userId,String profilePicURL)async{
    await fireStore.collection("users")
        .document(userId)
        .updateData({'profilePicURL': profilePicURL,}).then((_) {
      print("Name Updated $profilePicURL");
    });
  }

  Future<void> updateUsername(String userId,String username,String oldUsername)async{
    await fireStore.collection("users")
        .document(userId)
        .updateData({'username': username,}).then((_) {
      print("Username Updated $username");
    });

    await fireStore.collection('username').document(username).setData(
        {'user-id':userId}
    );
    print('New Username Created in Users');
    await fireStore.collection('username').document(oldUsername).delete().then((_){
      print('Old username in Users Deleted $oldUsername');
    });
  }

  Future<void> updateName(String userId,String name)async{
    await fireStore.collection("users")
        .document(userId)
        .updateData({'name': name,}).then((_) {
      print("Name Updated $name");
    });
  }

  Future<void> updateBio(String userId,String bio)async{
    await fireStore.collection("users")
        .document(userId)
        .updateData({'bio': bio,}).then((_) {
      print("Bio Updated $bio");
    });
  }

}
