import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePostData {
  Future<List<DocumentSnapshot>> fetchFirstList(String user) async {

    List<DocumentSnapshot> postBioDict=[];

    var result= (await Firestore.instance
        .collection("users")
        .document(user)
        .collection('posts')
        .orderBy('date',descending: true)
        .limit(3)
        .getDocuments()).documents;

    for(var data in result){
      var postBio=await Firestore.instance.collection('posts').document(data.data['postId']).get();
      postBioDict=postBioDict+[postBio];
      print(postBio.data);
    }

    return result;
  }

  Future<List<DocumentSnapshot>> fetchNextList(
      List<DocumentSnapshot> documentList,String user) async {

    List<DocumentSnapshot> postBioDict=[];

    var result= (await Firestore.instance
        .collection("users")
        .document(user)
        .collection('posts')
        .orderBy("date",descending: true)
        .startAfterDocument(documentList[documentList.length - 1])
        .limit(3)
        .getDocuments())
        .documents;

    for(var data in result){
      var postBio=await Firestore.instance.collection('posts').document(data.data['postId']).get();
      postBioDict=postBioDict+[postBio];
      print(postBio.data);
    }

    return result;
  }

}