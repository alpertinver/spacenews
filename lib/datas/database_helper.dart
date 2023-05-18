import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spacenews/datas/database_helper.dart';

class DatabaseHelper {
  static const _databaseName = "IbanDb.db";
  static const _databaseVersion = 1;

  static const table = 'my_ibantable';
  static const columnId = '_id';
  static const columnIban = 'Iban';
  static const columnBankName = 'Bankname';
  static const columnDescription = 'Description';
  static const columnDisclaimerTF = 'false';

  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnIban TEXT NOT NULL,
            $columnBankName TEXT NOT NULL,
            $columnDescription TEXT NOT NULL
            $columnDisclaimerTF TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List> ColumnBankSorgu() async {
    var resultss = await _db.rawQuery("SELECT * FROM $table WHERE _id = 7");
    return resultss.toList();
  }

  Future<void> deleteall() async {
    _db.rawQuery("DELETE FROM $table");
  }

  Future<Map<String, dynamic>?> getRow(int id) async {
    List<Map<String, dynamic>> maps = await _db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return await maps.first;
    }
    return null;
  }

  Future<List<Map<String, Object?>>> disclaimerTFquery() async {
    var DisclaimerTF =
        await _db.rawQuery("SELECT columnDisclaimerTF FROM $table");
    return DisclaimerTF;
  }
}
