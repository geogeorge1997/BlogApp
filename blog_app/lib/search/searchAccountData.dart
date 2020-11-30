import 'package:cloud_firestore/cloud_firestore.dart';

class SearchAccountData {
  Future<List<DocumentSnapshot>> fetchFirstList(String name) async {

    return (await Firestore.instance
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: name)
        .orderBy('name')
        .limit(10)
        .getDocuments()).documents;
  }

  Future<List<DocumentSnapshot>> fetchNextList(
      List<DocumentSnapshot> documentList,String name) async {

    return (await Firestore.instance
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: name)
        .orderBy("name")
        .startAfterDocument(documentList[documentList.length - 1])
        .limit(10)
        .getDocuments())
        .documents;
  }
}