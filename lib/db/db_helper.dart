import "dart:io";

import "package:sqflite/sqflite.dart";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";


class DBHelper {
  static final _dbName = "Bag.db";
  static final _dbVersion = 1;

  static final table = "Item";

  static final columnID = "id";
  static final columnTitle = "title";
  static final columnContent = "content";
  static final columnCreatedAt = "created_at";
  static final columnUpdatedAt = "updated_at";

  DBHelper._();
  static final DBHelper dbInstance = DBHelper._();

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await _initDB();

    return _database;
  }

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnID INTEGER PRIMARY KEY,
        $columnTitle TEXT,
        $columnContent TEXT,
        $columnCreatedAt DATETIME,
        $columnUpdatedAt DATETME
      )
    '''
    );
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await dbInstance.database;
    print("inserting row: $row");

    return await db.insert(table, row);
  }

  Future<int> rowCount() async {
    Database db = await dbInstance.database;

    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $table"));
  }

  Future<List<Map<String, dynamic>>> all() async {
    Database db = await dbInstance.database;
    return await db.query(table);
  }

}
