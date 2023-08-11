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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
