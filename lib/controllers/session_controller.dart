import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/session.dart';

class SessionController {
  var database;
  List<Session> sessionList;
  var modified;

  static SessionController _instance;
  static get instance {
    if (_instance == null) {
      _instance = SessionController._internal();
    }

    return _instance;
  }

  SessionController._internal() {
    modified = false;
  }

  Future<Database> setDatabase() async {
    this.database = await openDatabase(
      join(await getDatabasesPath(), 'sessions_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE sessions (id INTEGER PRIMARY KEY, count INTEGER)",
        );
      },
      version: 2,
    );
    print('Database set');
    return this.database;
  }

  void insertSession(Session session) async {
    final Database db = await database;

    if (this.sessionList.isEmpty) {
      session.id = 1;
    } else {
      session.id = this.sessionList.last.id + 1;
    }

    await db.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    modified = true;
  }

  Future<List<Session>> loadSessions() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query('sessions', orderBy: 'id');

    this.sessionList = List.generate(maps.length, (i) {
      return Session(
        id: maps[i]['id'],
        count: maps[i]['count'],
      );
    });

    return this.sessionList;
  }

  List<Session> getSessions() {
    if (modified) {
      loadSessions();
      modified = false;
    }
    return this.sessionList;
  }

  Future<void> deleteSession(int id) async {
    final db = await database;

    await db.delete(
      'sessions',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  void clear() async {
    final db = await database;

    await db.delete('sessions');
  }
}
