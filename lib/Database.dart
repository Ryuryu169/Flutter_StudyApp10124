import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "BlueDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'Subjects';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnInName = 'inName';
  static final columnColor = 'color';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database ? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnInName TEXT NOT NULL,
            $columnColor TEXT NOT NULL
          )
          ''');
  }

  Future onCreate() async {
    await _database!.execute('''
          CREATE TABLE IF NOT EXISTS $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnInName TEXT NOT NULL,
            $columnColor TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }
  Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }
  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
  Future setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'MyDatabase.db');
    await deleteDatabase(path); // データベースの削除

    var database = await openDatabase(path,
      version: 1,
      onCreate: _onCreate,
    );
    return database;
  }
}

class DatabaseWord {
  static var subjectName = "Random";

  static final _databaseName = "BlueDatabase.db";
  static final _databaseVersion = 1;

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnMeaning = 'meaning';

  // make this a singleton class
  DatabaseWord._privateConstructor();
  static final DatabaseWord instance = DatabaseWord._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $subjectName (
       $columnId INTEGER PRIMARY KEY,
       $columnName TEXT NOT NULL,
       $columnMeaning TEXT NOT NULL
       )''');
  }

  Future onCreate(String name) async {
    subjectName = name;
    await _database!.execute('''
      CREATE TABLE IF NOT EXISTS $subjectName (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnMeaning TEXT NOT NULL
      )''');
  }

  Future setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'MyDatabase.db');
    await deleteDatabase(path); // データベースの削除

    var database = await openDatabase(path,
      version: 1,
      onCreate: _onCreate,
    );
    return database;
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(subjectName, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(subjectName);
  }

  Future<int?> queryRowCount(String name) async{
    subjectName = name;
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $subjectName'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    Database? db = await instance.database;
    return await db!.update(subjectName, row, where:'$columnId = ?', whereArgs:[id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(subjectName, where:'$columnId = ?',whereArgs: [id]);
  }

  Future<void> deleteSubject(String String) async {
    Database? db = await instance.database;
    await db!.execute('''
      DROP TABLE $String
    ''');
  }
}

class DatabaseSettings{
  static final _databaseName = "BlueDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'Settings';

  static final columnId = '_id';
  static final settingWord = 'Word';
  static final settingMusic = 'Music';
  static final settingSound = 'Sound';
  static final settingWordNum = 'WordNum';
  static final settingCustom = 'Custom';

  DatabaseSettings._privateConstructor();
  static final DatabaseSettings instance = DatabaseSettings._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
       $columnId INTEGER PRIMARY KEY,
       $settingSound INTEGER NOT NULL,
       $settingCustom INTEGER NOT NULL,
       $settingWordNum INTEGER NOT NULL
       )''');
  }

  Future onCreate() async {
    await _database!.execute('''
      CREATE TABLE IF NOT EXISTS Settings (
        $columnId INTEGER PRIMARY KEY,
        $settingSound INTEGER NOT NULL,
        $settingCustom INTEGER NOT NULL,
        $settingWordNum INTEGER NOT NULL
      )''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<Map<String, dynamic>> queryAllRows() async {
    Database? db = await instance.database;
    var i = await db!.query(table);
    return i[0];
  }
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = 0;
    return await db!.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int?> queryRowCount() async{
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM Settings'));
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
  Future setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'MyDatabase.db');
    await deleteDatabase(path); // データベースの削除

    var database = await openDatabase(path,
        version: 1, onCreate: _onCreate);

    return database;
  }
}

class DatabaseProfile{
  static final _databaseName = "BlueDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'Profile';
  static final columnId = '_id';
  static final profilePic = 'picture';
  static final profileName = 'name';
  static final profileFav = 'favorite';
  static final profileGoal = 'goal';

  DatabaseProfile._privateConstructor();
  static final DatabaseProfile instance = DatabaseProfile._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
       $columnId INTEGER PRIMARY KEY,
       $profileName TEXT NOT NULL,
       $profileFav TEXT NOT NULL,
       $profileGoal TEXT NOT NULL,
       $profilePic INT NOT NULL
       )''');
  }

  Future onCreate() async {
    await _database!.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        $columnId INTEGER PRIMARY KEY,
        $profileName TEXT NOT NULL,
        $profileFav TEXT NOT NULL,
        $profileGoal TEXT NOT NULL,
        $profilePic INT NOT NULL
      )''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<Map<String, dynamic>> queryAllRows() async {
    Database? db = await instance.database;
    var i = await db!.query(table);
    return i[0];
  }
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }
  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
  Future<int?> queryRowCount() async{
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM Settings'));
  }
  Future setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'MyDatabase.db');
    await deleteDatabase(path); // データベースの削除

    var database = await openDatabase(path,
        version: 1, onCreate: _onCreate);

    return database;
  }
}