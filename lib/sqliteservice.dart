import 'dart:io';

import 'package:gym_chartsheet/models/days.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqlService {
  SqlService._();

  static final SqlService sql = SqlService._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "GymChart.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE DAYS ("
          "day_id INTEGER PRIMARY KEY,"
          "day_name TEXT,"
          "isdaycompleted BIT"
          ")");

      await db.execute("CREATE TABLE EXERCISES ("
          "exercise_id INTEGER PRIMARY KEY,"
          "exercise_name TEXT,"
          "day_id INTEGER,"
          "isExerciseCompleted BIT"
          "FOREIGN KEY (day_id) REFERENCES DAYS (day_id) ON UPDATE CASCADE ON DELETE CASCADE"
          ")");
    });
  }

  addNewDays(Days day) async {
    final db = await database;

    var table = await db.rawQuery("SELECT MAX(day_id)+1 as day_id from DAYS");

    int dayId = table.first['day_id'];

    var raw = await db.rawInsert(
        "INSERT Into DAYS (day_id,day_name,isdaycompleted)" " VALUES (?,?,?)",
        [dayId, day.dayName, day.isDayCompleted]);

    return raw;
  }

  getDay(int id) async {
    final db = await database;

    var res = await db.query('DAYS', where: 'day_id=?', whereArgs: [id]);

    return res.isNotEmpty ? Days.fromJson(res.first) : Null;
  }

  getAllDays() async {
    final db = await database;

    var res = await db.query('DAYS');

    List<Days> days =
        res.isNotEmpty ? res.map((f) => Days.fromJson(f)).toList() : [];

    return days;
  }

  updateDays(Days day) async {
    final db = await database;

    var res = await db
        .update('DAYS', day.toMap(), where: 'day_id=?', whereArgs: [day.dayId]);

    return res;
  }

  deleteDay(int id) async {
    final db = await database;

    db.delete('DAYS', where: 'day_id=?', whereArgs: [id]);
  }

  deleteAllDays() async {
    final db = await database;

    db.rawDelete('Delete * from DAYS');
  }
}
