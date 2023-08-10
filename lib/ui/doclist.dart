import 'dart:async';
import 'package:flutter/material.dart';

import '../model/model.dart';
import '../util/dbhelper.dart';

// Menu item
const menuReset = "Reset Local Data";

List<String> menuOptions = const <String>[menuReset];

class DocList extends StatefulWidget {
  const DocList({super.key});

  @override
  State<DocList> createState() => _DocListState();
}

class _DocListState extends State<DocList> {
  @override
  Widget build(BuildContext context) {
    DbHelper dbh = DbHelper();
    List<Doc> docs;
    int count = 0;
    DateTime cDate;

    @override
    void initState() {
      super.initState();
    }

    return const Placeholder();
  }
}
