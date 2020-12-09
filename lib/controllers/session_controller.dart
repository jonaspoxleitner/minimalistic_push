import 'dart:async';

import 'package:minimalisticpush/widgets/background.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/session.dart';

class SessionController {
  Database database;
  List<Session> sessionList;

  static SessionController _instance;
  static get instance {
    if (_instance == null) {
      _instance = SessionController._internal();
    }
    return _instance;
  }

  SessionController._internal();

  // sets the database or creates it on first start of the app
  Future<Database> setDatabase() async {
    this.database = await openDatabase(
      join(await getDatabasesPath(), 'sessions_database.database'),
      onCreate: (database, version) {
        return database.execute(
          "CREATE TABLE sessions (id INTEGER PRIMARY KEY, count INTEGER)",
        );
      },
      version: 2,
    );

    await this
        .loadSessions()
        .then((value) => {Background.instance.setSessions(this.sessionList)});

    return this.database;
  }

  // inserts a new session into the database
  void insertSession(Session session) async {
    if (this.sessionList.isEmpty) {
      session.id = 1;
    } else {
      session.id = this.sessionList.last.id + 1;
    }

    await database.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await this
        .loadSessions()
        .then((value) => {Background.instance.setSessions(this.sessionList)});
  }

  // loads all sessions from the database ordered by the id
  Future<List<Session>> loadSessions() async {
    await database.query('sessions', orderBy: 'id').then((value) {
      this.sessionList = List.generate(value.length, (i) {
        return Session(
          id: value[i]['id'],
          count: value[i]['count'],
        );
      });
    });

    return this.sessionList;
  }

  // returns the sessions in a list
  // does not call this.loadSessions() for performace reasons
  List<Session> getSessions() {
    return this.sessionList;
  }

  // delete a session from the database by id
  Future<void> deleteSession(int id) async {
    await database.delete(
      'sessions',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // debug
  // this method clears the whole session database
  void clear() async {
    await database.delete('sessions');
    await this
        .loadSessions()
        .then((value) => {Background.instance.setSessions(this.sessionList)});
  }
}
