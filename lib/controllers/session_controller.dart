import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../models/session.dart';

class SessionController {
  Future<Database> database;

  static final SessionController _sessionController =
      SessionController._internal();

  factory SessionController() {
    return _sessionController;
  }

  SessionController._internal();

  void setDatabase(Future<Database> database) {
    this.database = database;
  }

  Future<void> insertSession(Session session) async {
    final Database db = await database;

    await db.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Session>> getSessions() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('sessions');

    return List.generate(maps.length, (i) {
      return Session(
        id: maps[i]['id'],
        count: maps[i]['count'],
      );
    });
  }

  Future<void> deleteSession(int id) async {
    final db = await database;

    await db.delete(
      'sessions',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
