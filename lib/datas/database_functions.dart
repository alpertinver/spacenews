import 'dart:ffi';

import 'package:spacenews/main.dart';
import 'database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var allRowsProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

String ColumnIban = "";
String ColumnBankname = "";
String ColumnDescription = "";
String ColumnDisclaimerTF = "";

class dbfunctions {
  void myinsert(String ColumnIban, String ColumnBankname,
      String ColumnDescription, String ColumnDisclaimerTF) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnIban: ColumnIban,
      DatabaseHelper.columnBankName: ColumnBankname,
      DatabaseHelper.columnDescription: ColumnDescription,
      DatabaseHelper.columnDisclaimerTF: ColumnDisclaimerTF
    };
    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

  Future<List> myquery() async {
    final allRows = await dbHelper.queryAllRows();
    return allRows;
  }

  Future<void> mydeleteall() async {
    dbHelper.deleteall();
  }

  Future<int> myLength() async {
    int i = 0;

    final allRows = await dbHelper.queryAllRows();
    for (final row in allRows) {
      i = i + 1;
    }
    return i;
  }

  void myupdate(int id, String ColumnIban, String ColumnBankname,
      String ColumnDescription) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnIban: ColumnIban,
      DatabaseHelper.columnBankName: ColumnBankname,
      DatabaseHelper.columnDescription: ColumnDescription
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void mydelete(int idgiris) async {
    // Assuming that the number of rows is the id for the last row.
    // final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(idgiris);
    debugPrint('deleted $rowsDeleted row(s): row $idgiris');
  }

  void bbanksorgu() async {
    var at = await dbHelper.ColumnBankSorgu();
    debugPrint("at : ${at[0]}  ");
  }

  Future<String> rowsorgu() async {
    var at = await dbHelper.getRow(1);
    debugPrint(at!['Bankname']);
    return at['Bankname'].toString();
  }
}
