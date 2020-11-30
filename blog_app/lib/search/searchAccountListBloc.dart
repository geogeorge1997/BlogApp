import 'dart:async';
import 'dart:io';
import 'package:blog_app/search/searchAccountData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class SearchAccountListBloc {
  SearchAccountData searchAccountData;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;

  BehaviorSubject<List<DocumentSnapshot>> searchController;

  BehaviorSubject<bool> showIndicatorController;

  SearchAccountListBloc() {
    searchController = BehaviorSubject<List<DocumentSnapshot>>();
    showIndicatorController = BehaviorSubject<bool>();
    searchAccountData = SearchAccountData();
  }

  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<DocumentSnapshot>> get searchAccountStream => searchController.stream;

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList(String name) async {
    print("Inside Block"+name);
    try {
      documentList = await searchAccountData.fetchFirstList(name);
      print(documentList);
      searchController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          searchController.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      searchController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      searchController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextUsers(String name) async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList =
      await searchAccountData.fetchNextList(documentList,name);
      documentList.addAll(newDocumentList);
      searchController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          searchController.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      searchController.sink.addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      searchController.sink.addError(e);
    }
  }

/*For updating the indicator below every list and paginate*/
  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    searchController.close();
    //userController
    showIndicatorController.close();
  }
}