import 'package:cloud_firestore/cloud_firestore.dart';

class HomePostData {
  Future<List<DocumentSnapshot>> fetchFirstList() async {

    return (await Firestore.instance
        .collection("posts")
        .orderBy("date",descending: true)
        .limit(5)
        .getDocuments())
        .documents;
  }

  Future<List<DocumentSnapshot>> fetchNextList(
      List<DocumentSnapshot> documentList) async {

    return (await Firestore.instance
        .collection("posts")
        .orderBy("date",descending: true)
        .startAfterDocument(documentList[documentList.length - 1])
        .limit(5)
        .getDocuments())
        .documents;
  }

}