import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/session.dart';

class SessionController {
  var database;
  List<Session> sessionList;

  static final SessionController _sessionController =
      SessionController._internal();

  factory SessionController() {
    return _sessionController;
  }

  SessionController._internal();

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

    var sessions = await loadSessions();

    if (sessions.isEmpty) {
      session.id = 1;
    } else {
      var last = sessions.last;
      session.id = last['id'] + 1;
    }

    await db.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map>> loadSessions() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query('sessions', orderBy: 'id');

    this.sessionList = List.generate(maps.length, (i) {
      return Session(
        id: maps[i]['id'],
        count: maps[i]['count'],
      );
    });
    return maps;
  }

  List<Session> getSessions() {
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
