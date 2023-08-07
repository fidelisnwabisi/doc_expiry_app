// import 'dart:async';
// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables, prefer_adjacent_string_concatenation, unnecessary_null_comparison, prefer_conditional_assignment, unnecessary_string_interpolations, unnecessary_brace_in_string_interps

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

  // Get the list of docs
  Future<List> getDocs() async {
    Database db = await this.db;
    var r =
        await db.rawQuery("SELECT * FROM $tblDocs ORDER BY $docExpiration ASC");
    return r;
  }

  // Get a Doc based on the id
  Future<List> getDoc(int id) async {
    Database db = await this.db;
    var r = await db
        .rawQuery("SELECT * from $tblDocs WHERE" + "$docId" + "=" + "${id}");
    return r;
  }

  // Get a Dc based on a String parload
  Future<List?> getDocFromStr(String payload) async {
    List<String> p = payload.split("|");
    if (p.length == 2) {
      Database db = await this.db;
      var r = await db.rawQuery("SELECT * from $tblDocs WHERE $docId = " +
          p[0] +
          " AND $docExpiration='" +
          p[1] +
          "'");
      return r;
    } else {
      return null;
    }
  }

  // Get the number of Docs
  Future<int?> getDocsCount() async {
    Database db = await this.db;
    var r = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT (*) FROM $tblDocs"));
    return r;
  }

  // Get the max document id available on the database
  Future<int?> getMaxId() async {
    Database db = await this.db;
    var r = Sqflite.firstIntValue(
        await db.rawQuery("SELECT MAX(id) FROM $tblDocs"));
    return r;
  }

  // Update a doc
  Future<int> updateDoc(Doc doc) async {
    var db = await this.db;
    var r = await db
        .update(tblDocs, doc.toMap(), where: "$docId = ?", whereArgs: [doc.id]);
    return r;
  }

  // Delete a doc
  Future<int> deletDoc(int id) async {
    var db = await this.db;
    int r = await db.rawDelete(
      "DELETE FROM $tblDocs WHERE $docId = $id",
    );
    return r;
  }

  // Delete all docs
  Future<int> deleteRows(String tbl) async {
    var db = await this.db;
    int r = await db.rawDelete("DELETE FROM $tbl");
    return r;
  }
}
