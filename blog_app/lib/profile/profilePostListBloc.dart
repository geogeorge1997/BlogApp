import 'dart:async';
import 'dart:io';
import 'package:blog_app/profile/profilePostData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ProfilePostListBloc {
  ProfilePostData profilePostData;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;

  BehaviorSubject<List<DocumentSnapshot>> profileController;

  BehaviorSubject<bool> showIndicatorController;

  ProfilePostListBloc() {
    profileController = BehaviorSubject<List<DocumentSnapshot>>();
    showIndicatorController = BehaviorSubject<bool>();
    profilePostData = ProfilePostData();
  }

  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<DocumentSnapshot>> get profilePostStream => profileController.stream;

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList(String name) async {
    print("Inside Block "+name);
    try {
      documentList = await profilePostData.fetchFirstList(name);
      print(documentList);
      profileController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          profileController.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      profileController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      profileController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextUsers(String name) async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList =
      await profilePostData.fetchNextList(documentList,name);
      documentList.addAll(newDocumentList);
      profileController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          profileController.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      profileController.sink.addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      profileController.sink.addError(e);
    }
  }

/*For updating the indicator below every list and paginate*/
  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    profileController.close();
    showIndicatorController.close();
  }
}