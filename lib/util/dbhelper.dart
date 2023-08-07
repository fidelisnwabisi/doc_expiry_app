// import 'dart:async';
// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables, prefer_adjacent_string_concatenation, unnecessary_null_comparison, prefer_conditional_assignment

import 'dart:io';

import 'package:doc_expiry_app/model/model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  // Tables
  static String tblDocs = "docs";

  // Fields of the 'docs' table
  String docId = "id";
  String docTitle = "title";
  String docExpiration = "expiration";

  String fqYear = "fqYear";
  String fqHalfYear = "fqHalfYear";
  String fqQuarter = "fqQuarter";
  String fqMonth = "fqMonth";

  // Singleton
  static final DbHelper _dbHelper = DbHelper._internal();
// Factory constructor
  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }
  // Database entry point
  static late Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  // Initialize the database
  Future<Database> initializeDb() async {
    Directory d = await getApplicationDocumentsDirectory();
    String p = d.path + "/docexpire.db";
    var db = await openDatabase(p, version: 1, onCreate: _createDb);
    return db;
  }

  // Create database table
  void _createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tblDocs ($docId INTEGER PRIMARY KEY, $docTitle TEXT, " +
            "$docExpiration TEXT, " +
            "$fqYear INTEGER, $fqHalfYear INTEGER, $fqQuarter INTEGER, " +
            "$fqMonth INTEGER)");
  }

  // Insert a new document
  Future<int> insertDoc(Doc doc) async {
    var r;

    Database db = await this.db;
    try {
      r = await db.insert(tblDocs, doc.toMap());
    } catch (e) {
      debugPrint("insertDoc: " + e.toString());
    }
    return r;
  }
}
