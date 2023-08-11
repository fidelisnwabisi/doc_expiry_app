import 'dart:async';
import 'package:flutter/material.dart';

import '../model/model.dart';
import '../util/dbhelper.dart';
import '../util/utils.dart';
import './docdetail.dart';

// Menu item
const menuReset = "Reset Local Data";
List<String> menuOptions = const <String>[menuReset];

class DocList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DocListState();
}

class DocListState extends State<DocList> {
  DbHelper dbh = DbHelper();
  late List<Doc> docs;
  int count = 0;
  late DateTime cDate;

  @override
  void initState() {
    super.initState();
  }

  Future getData() async {
    final dbFuture = dbh.initializeDb();
    dbFuture.then(
        // result here is the actual reference to the database object.
        (result) {
      final docsFuture = dbh.getDocs();
      docsFuture.then(
          // result here is the actual list of docs in the database.
          (result) {
        if (result.length >= 0) {
          List<Doc> docList = [];
          var count = result.length;
          for (int i = 0; i <= count - 1; i++) {
            docList.add(Doc.fromObject(result[i]));
          }
          setState(() {
            if (this.docs.length > 0) {
              this.docs.clear();
            }
            this.docs = docList;
            this.count = count;
          });
        }
      });
    });
  }

  void _checkDate() {
    const secs = const Duration(seconds: 10);

    new Timer.periodic(secs, (Timer t) {
      DateTime nw = DateTime.now();

      if (cDate.day != nw.day ||
          cDate.month != nw.month ||
          cDate.year != nw.year) {
        getData();
        cDate = DateTime.now();
      }
    });
  }

  void navigateToDetail(Doc doc) async {
    bool r = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => DocDetail(doc)));

    if (r == true) {
      getData();
    }
  }

  void _showResetDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Reset"),
            content: new Text("Do you want to delete all the local data"),
            actions: <Widget>[
              TextButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: new Text("OK"),
                onPressed: () {
                  Future f = _resetLocalData();
                  f.then((result) {
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  Future _resetLocalData() async {
    final dbFuture = dbh.initializeDb();
    dbFuture.then((result) {
      final dDocs = dbh.deleteRows(DbHelper.tblDocs);
      dDocs.then((result) {
        setState(() {
          this.docs.clear();
          this.count = 0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}


// The class 'List' doesn't have an unnamed constructor.
// Try using one of the named constructors defined in 'List'.