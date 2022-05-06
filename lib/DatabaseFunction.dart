import 'package:flutter/material.dart';
import 'Database.dart';

class DatabaseHelperFunction{
  final dbHelper = DatabaseHelper.instance;

  DatabaseHelperFunction._privateConstructor();
  static final DatabaseHelperFunction instance = DatabaseHelperFunction._privateConstructor();

  void insertSubject(String name, String inName, String color) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: '$name',
      DatabaseHelper.columnInName: '$inName',
      DatabaseHelper.columnColor: '$color'
    };
    final id = await dbHelper.insert(row);
    debugPrint('$id $name $inName $color');
  }

  void updateDatabase(int d, String name, String inName, String color) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: d,
      DatabaseHelper.columnName: '$name',
      DatabaseHelper.columnInName: '$inName',
      DatabaseHelper.columnColor: '$color'
    };
    debugPrint('Before $d $name $inName $color');
    final id = await dbHelper.update(row);
    debugPrint('After $id $name $inName $color');
  }

  void setDatabase() async {
    await dbHelper.setDatabase();
  }

  void testPrint() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  Future<int?> showRows() async {
    final test = await dbHelper.queryRowCount();
    return test;
  }

  Future<List<Map<String, dynamic>>> returnAll() async {
    final allRows = dbHelper.queryAllRows();
    return allRows;
  }
  void onCreate() async {
    await dbHelper.onCreate();
  }
}

class DatabaseWordFunction {
  final dbWord = DatabaseWord.instance;

  DatabaseWordFunction._privateConstructor();
  static final DatabaseWordFunction instance = DatabaseWordFunction._privateConstructor();

  void insertWord(String subjectName, String name, String meaning) async {
    Map<String, dynamic> row = {
      DatabaseWord.columnName: '$name',
      DatabaseWord.columnMeaning: '$meaning'
    };
    DatabaseWord.subjectName = '$subjectName';
    final id = await dbWord.insert(row);
    debugPrint('$id $name $meaning');
  }

  void updateWord(int d, String subjectName, String name, String meaning) async {
    Map<String, dynamic> row = {
      DatabaseWord.columnId: d,
      DatabaseWord.columnName: '$name',
      DatabaseWord.columnMeaning: '$meaning',
    };
    DatabaseWord.subjectName = '$subjectName';

    debugPrint('Before $subjectName $d $name $meaning');
    final id = await dbWord.update(row);
    debugPrint('After $subjectName $id $name $meaning');
  }

  void setDatabase() async {
    await dbWord.setDatabase();
  }

  void testPrint() async {
    final allRows = await dbWord.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void deleteWord(int index) async {
    await dbWord.delete(index);
    print('Succesfully deleted');
  }

  Future<int?> showRows(String subjectName) async {
    final test = await dbWord.queryRowCount(subjectName);
    return test;
  }

  Future<List<Map<String, dynamic>>> returnAll() async {
    final allRows = dbWord.queryAllRows();
    return allRows;
  }
  void onCreate(String name) async {
    await dbWord.onCreate(name);
  }
  Future<void> deleteSubject(String String) async => dbWord.deleteSubject(String);
}

class DatabaseSettingsFunction {
  final dbSettings = DatabaseSettings.instance;

  DatabaseSettingsFunction._privateConstructor();
  static final DatabaseSettingsFunction instance = DatabaseSettingsFunction._privateConstructor();

  void insertSetting(int sound, int custom, int number) async {
    Map<String, dynamic> row = {
      DatabaseSettings.columnId: 1,
      DatabaseSettings.settingSound: sound,
      DatabaseSettings.settingCustom: custom,
      DatabaseSettings.settingWordNum: number
    };
    final id = await dbSettings.insert(row);
    debugPrint('$id $sound $custom $number');
  }

  void updateSettinng(int music, int sound, int custom, int number) async {
    Map<String, dynamic> row = {
      DatabaseSettings.columnId: 1,
      DatabaseSettings.settingMusic: music,
      DatabaseSettings.settingSound: sound,
      DatabaseSettings.settingCustom: custom,
      DatabaseSettings.settingWordNum: number
    };

    debugPrint('1 $music $sound $custom $number');
    final id = await dbSettings.update(row);
    debugPrint('$id $music $sound $custom $number');
  }

  void setDatabase() async {
    await dbSettings.setDatabase();
  }

  void testPrint() async {
    final allRows = await dbSettings.queryAllRows();
    print('query all rows: $allRows');
  }

  void onCreate() async => await dbSettings.onCreate();

  Future<int?> queryRowCount() async {
    var rows = dbSettings.queryRowCount();
    return rows;
  }

  Future<Map<String, dynamic>> returnAll() async {
    final allRows = dbSettings.queryAllRows();
    return allRows;
  }
}

class DatabaseProfileFunction {
  final dbProfile = DatabaseProfile.instance;

  DatabaseProfileFunction._privateConstructor();
  static final DatabaseProfileFunction instance = DatabaseProfileFunction._privateConstructor();

  void insertProfile(String name, String favorite, String goal, int picture) async {
    Map<String, dynamic> row = {
      DatabaseProfile.columnId: 1,
      DatabaseProfile.profileName: '$name',
      DatabaseProfile.profileFav: '$favorite',
      DatabaseProfile.profileGoal: '$goal',
      DatabaseProfile.profilePic: '$picture'
    };
    final id = await dbProfile.insert(row);
    debugPrint('$id $name $favorite $goal path:$picture');
  }

  void updateProfile(String name, String favorite, String goal, int picture) async {
    Map<String, dynamic> row = {
      DatabaseProfile.columnId: 1,
      DatabaseProfile.profileName: '$name',
      DatabaseProfile.profileFav: '$favorite',
      DatabaseProfile.profileGoal: '$goal',
      DatabaseProfile.profilePic: '$picture'
    };

    debugPrint('1 $name $favorite $goal');
    final id = await dbProfile.update(row);
    debugPrint('$id $name $favorite $goal');
  }

  void setDatabase() async {
    await dbProfile.setDatabase();
  }

  void testPrint() async {
    final allRows = await dbProfile.queryAllRows();
    print('query all rows: $allRows');
  }

  Future<Map<String, dynamic>> returnAll() async {
    final allRows = dbProfile.queryAllRows();
    return allRows;
  }
  Future<int?> deleteProfile(int i) async => dbProfile.delete(i);
  Future<int?> queryRowCount() async => dbProfile.queryRowCount();
  void onCreate() async => await dbProfile.onCreate();
}