// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart';
import 'package:tomflutter_catatan/models/task.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tableName = 'tasks';
  static const String _dbName = 'todo.db';

  static Future<void> initDb() async {
    if (_database != null) {
      return;
    }
    try {
      String path = await getDatabasesPath() + _dbName;

      _database = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          print('Creating table name ->  $_tableName');
          return db.execute(
            'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, note TEXT, date STRING, startTime STRING, endTime STRING, remind INTEGER, repeat STRING, color INTEGER, isCompleted INTEGER, createdAt STRING, updatedAt STRING)',
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task task) async {
    print('Inserting data to $_tableName');
    try {
      print(task.toJson());
      return await _database!.insert(_tableName, task.toJson());
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('Querying data from $_tableName ');
    try {
      return await _database!.query(_tableName);
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<int> delete(int id) async {
    print('Deleting data from $_tableName with id ===> $id');
    try {
      return await _database!.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static updateTask(int id) async {
    print('Updating data from $_tableName with id ===> $id');
    try {
      return await _database!.rawUpdate('''
    UPDATE $_tableName 
    SET isCompleted = ?
    WHERE id = ?
''', [1, id]);
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static Future<int> updateTaskInfo(Task task) async {
    print('Updating data from $_tableName with id ===> ${task.id}');
    try {
      return await _database!.rawUpdate(
        '''
    UPDATE $_tableName
    SET title = ?, note = ?, date = ?, startTime = ?, endTime = ?, remind = ?, repeat = ?, color = ?, isCompleted = ?, createdAt = ?, updatedAt = ? 
    WHERE id = ?
''',
        [
          task.title,
          task.note,
          task.date,
          task.startTime,
          task.endTime,
          task.remind,
          task.repeat,
          task.color,
          task.isCompleted,
          task.createdAt,
          task.updatedAt,
          task.id
        ],
      );
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
