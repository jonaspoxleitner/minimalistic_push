import 'dart:async';
import 'dart:convert';

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

    await this.loadSessions().then((value) => this.setNormalizedSessions());

    return this.database;
  }

  // inserts a new session into the database
  void insertSession(Session session) async {
    if (session.id == null) {
      if (this.sessionList.isEmpty) {
        session.id = 1;
      } else {
        session.id = this.sessionList.last.id + 1;
      }
    }

    await database.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await this.loadSessions().then((value) => this.setNormalizedSessions());
  }

  // loads all sessions from the database ordered by the id
  Future<List<Map<String, dynamic>>> loadSessions() async {
    var response = database.query('sessions', orderBy: 'id');

    response.then((value) {
      this.sessionList = List.generate(value.length, (i) {
        return Session(
          id: value[i]['id'],
          count: value[i]['count'],
        );
      });

      return response;
    });

    return response;
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

    await this.loadSessions().then((value) => this.setNormalizedSessions());
  }

  // debug
  // this method clears the whole session database
  void clear() async {
    await database.delete('sessions');
    await this.loadSessions().then((value) => this.setNormalizedSessions());
  }

  // sets 5 normlized sessions into the background
  void setNormalizedSessions() {
    List<double> normalizedPeaks = this.getNormalizedSessions(5);
    Background.instance.setSessions(normalizedPeaks);
  }

  // returns normalized sessions with a variable length
  List<double> getNormalizedSessions(int length) {
    List<double> normalizedPeaks = [];
    List<int> peaks = [];

    for (Session session in this.sessionList) {
      peaks.add(session.count);
    }

    while (peaks.length < length) {
      peaks.insert(0, 0);
    }

    if (peaks.length > length) {
      peaks = peaks.sublist(peaks.length - length);
    }

    var min = peaks[0];
    var max = peaks[0];

    // find min and max
    for (int peak in peaks) {
      if (peak < min) {
        min = peak;
      }
      if (peak > max) {
        max = peak;
      }
    }

    // normalize list
    if (max == 0) {
      // this should show something cool
      for (int peak in peaks) {
        normalizedPeaks.add(0.5);
      }
    } else if (min == max) {
      // steady pace
      for (int peak in peaks) {
        normalizedPeaks.add(0.7);
      }
    } else {
      for (int peak in peaks) {
        normalizedPeaks.add((peak - min) / (max - min));
      }
    }

    return normalizedPeaks;
  }

  // import data from string
  // returns true if everything went fine
  bool importDataFromString(String json) {
    try {
      Map<String, dynamic> data = jsonDecode(json);

      if (!data.containsKey('sessions') || data['sessions'].length == 0) {
        return false;
      }

      this.clear();

      for (Map m in data['sessions']) {
        this.insertSession(Session(id: m['id'], count: m['count']));
      }

      return true;
    } catch (e) {
      // calling function will handle error because it belongs to UI
      return false;
    }
  }

  String exportDataToString() {
    Map data = {'sessions': []};

    for (Session s in this.sessionList) {
      data['sessions'].add(s.toMap());
    }

    return jsonEncode(data);
  }
}
