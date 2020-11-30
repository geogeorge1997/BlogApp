import 'dart:async';
import 'dart:io';
import 'package:blog_app/home/homePostData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class HomePostListBloc {
  HomePostData homePostData;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;

  BehaviorSubject<List<DocumentSnapshot>> homeController;

  BehaviorSubject<bool> showIndicatorController;

  HomePostListBloc() {
    homeController = BehaviorSubject<List<DocumentSnapshot>>();
    showIndicatorController = BehaviorSubject<bool>();
    homePostData = HomePostData();
  }

  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<DocumentSnapshot>> get homePostStream => homeController.stream;

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList() async {
    print("Inside Block ");
    try {
      documentList = await homePostData.fetchFirstList();
      print(documentList);
      homeController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          homeController.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      homeController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      homeController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextUsers() async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList =
      await homePostData.fetchNextList(documentList);
      documentList.addAll(newDocumentList);
      homeController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          homeController.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      homeController.sink.addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      homeController.sink.addError(e);
    }
  }

/*For updating the indicator below every list and paginate*/
  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    homeController.close();
    showIndicatorController.close();
  }
}