import 'dart:async';
import 'dart:convert';

import 'package:minimalisticpush/models/session.dart';

import 'package:sprinkle/Manager.dart';
import 'package:sprinkle/sprinkle.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// TODO: all instance fields should be final
class SessionManager extends Manager {
  Database database;

  final sessions = <Session>[].reactive;
  final normalized = <double>[0.0, 0.0, 0.0, 0.0, 0.0].reactive;

  SessionManager() {
    this.setDatabase();
  }

  // sets the database or creates it on first start of the app
  void setDatabase() async {
    this.database = await openDatabase(
      join(await getDatabasesPath(), 'sessions_database.database'),
      onCreate: (database, version) {
        return database.execute(
          "CREATE TABLE sessions (id INTEGER PRIMARY KEY, count INTEGER)",
        );
      },
      version: 2,
    );

    await this._loadSessions();
    this.setNormalizedSessions();
  }

  // inserts a new session into the database
  void insertSession(Session session) async {
    if (session.id == null) {
      if (sessions.value.isEmpty) {
        session.id = 1;
      } else {
        session.id = sessions.value.last.id + 1;
      }
    }

    await database.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await this._loadSessions();
    this.setNormalizedSessions();
  }

  // loads all sessions from the database ordered by the id
  Future<List<Map<String, dynamic>>> _loadSessions() async {
    var response = database.query('sessions', orderBy: 'id');

    response.then((value) {
      sessions.value = List.generate(value.length, (i) {
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
    return sessions.value;
  }

  // delete a session from the database by id
  Future<void> deleteSession(int id) async {
    await database.delete(
      'sessions',
      where: "id = ?",
      whereArgs: [id],
    );

    await this._loadSessions();
    this.setNormalizedSessions();
  }

  // debug
  // this method clears the whole session database
  void clear() async {
    await database.delete('sessions');
    await this._loadSessions();
    this.setNormalizedSessions();
  }

  // sets 5 normlized sessions into the background
  void setNormalizedSessions() {
    normalized.value = this.getNormalizedSessions(5);
  }

  // returns normalized sessions with a variable length
  List<double> getNormalizedSessions(int length) {
    List<double> normalizedPeaks = [];
    List<int> peaks = [];

    for (Session session in sessions.value) {
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
      for (int i = 0; i < peaks.length; i++) {
        normalizedPeaks.add(0.5);
      }
    } else if (min == max) {
      // steady pace
      for (int i = 0; i < peaks.length; i++) {
        normalizedPeaks.add(0.7);
      }
    } else {
      for (int peak in peaks) {
        normalizedPeaks.add((peak - min) / (max - min));
      }
    }

    return normalizedPeaks;
  }

  // // publishes fake normalized sessions to the stream
  void publishOnboardingSessions() {
    normalized.value = [0.2, 0.4, 0.6, 0.8, 1.0];
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

  // export data to string
  String exportDataToString() {
    Map data = {'sessions': []};

    for (Session s in sessions.value) {
      data['sessions'].add(s.toMap());
    }

    return jsonEncode(data);
  }

  @override
  void dispose() {
    sessions.close();
    normalized.close();
  }
}
