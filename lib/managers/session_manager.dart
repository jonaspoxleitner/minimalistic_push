import 'dart:async';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:sprinkle/Manager.dart';
import 'package:sprinkle/sprinkle.dart';
import 'package:sqflite/sqflite.dart';

import '../models/session.dart';

/// The manager for the completed sessions.
class SessionManager extends Manager {
  /// A list of all the sessions.
  final sessions = <Session>[].reactive;

  /// A list of the normalized sessions with the length of 5.
  final normalized = <double>[0.0, 0.0, 0.0, 0.0, 0.0].reactive;

  /// The constructor of the manager, which also initializes the lists.
  SessionManager() {
    _init();
  }

  /// The database of the sessions.
  Future<Database> get database async {
    return await openDatabase(
      join(await getDatabasesPath(), 'sessions_database.database'),
      onCreate: (database, version) {
        return database.execute(
          "CREATE TABLE sessions (id INTEGER PRIMARY KEY, count INTEGER)",
        );
      },
      version: 2,
    );
  }

  void _init() async {
    await _loadSessions();
    setNormalizedSessions();
  }

  /// Insert a new [Session] into the database and update the UI.
  void insertSession(Session session) async {
    if (session.id == null && sessions.value.isEmpty) {
      session.id = 1;
    } else if (session.id == null) {
      session.id = sessions.value.last.id + 1;
    }

    await database.then((db) => db.insert(
          'sessions',
          session.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ));

    await _loadSessions();
    setNormalizedSessions();
  }

  /// Load all the sessions from the database.
  void _loadSessions() async {
    var response = database.then((db) => db.query('sessions', orderBy: 'id'));

    await response.then((value) {
      sessions.value = List.generate(value.length, (i) {
        return Session(
          id: value[i]['id'],
          count: value[i]['count'],
        );
      });

      return response;
    });
  }

  /// Delete a session from the database by the [id] and update the UI.
  Future<void> deleteSession(int id) async {
    await database.then((db) => db.delete(
          'sessions',
          where: "id = ?",
          whereArgs: [id],
        ));

    await _loadSessions();
    setNormalizedSessions();
  }

  /// Clears the database for debug purposes.
  void clear() async {
    await database.then((db) => db.delete('sessions'));
    await _loadSessions();
    setNormalizedSessions();
  }

  /// Sets the normalized Sessions to the stream.
  void setNormalizedSessions() {
    normalized.value = _getNormalizedSessions(5);
  }

  /// Creates a list with a given [length] with normalized session values.
  List<double> _getNormalizedSessions(int length) {
    var normalizedPeaks = List.filled(length, 0.0);
    var peaks = List.filled(length, 0);

    for (var i = 1; i <= length; i++) {
      if (sessions.value.length - i >= 0) {
        peaks[length - i] = sessions.value[sessions.value.length - i].count;
      }
    }

    var minMax = _findMinMax(peaks);

    var min = minMax[0];
    var max = minMax[1];

    if (max == 0) {
      // this should show something cool
      return List.filled(length, 0.5);
    } else if (min == max) {
      // steady pace
      return List.filled(length, 0.7);
    }

    // normalize peaks
    for (var i = 0; i < length; i++) {
      normalizedPeaks[i] = ((peaks[i] - min) / (max - min));
    }

    return normalizedPeaks;
  }

  /// Publishes fake normalizes sessions for the onboarding experience.
  void publishOnboardingSessions() {
    normalized.value = [0.2, 0.4, 0.6, 0.8, 1.0];
  }

  /// Imports a data from a json String.
  bool importDataFromString(String json) {
    try {
      Map<String, dynamic> data = jsonDecode(json);

      if (!data.containsKey('sessions') || data['sessions'].length == 0) {
        return false;
      }

      clear();

      for (Map m in data['sessions']) {
        insertSession(Session(id: m['id'], count: m['count']));
      }

      return true;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      // calling function will handle error because it belongs to UI
      return false;
    }
  }

  /// Exports the sessions as a String.
  String exportDataToString() {
    var data = {'sessions': []};

    for (var s in sessions.value) {
      data['sessions'].add(s.toMap());
    }

    return jsonEncode(data);
  }

  List<int> _findMinMax(List<int> list) {
    var min = 0, max = 0;

    for (var l in list) {
      min = l < min ? l : min;
      max = l > max ? l : max;
    }

    return [min, max];
  }

  @override
  void dispose() {
    sessions.close();
    normalized.close();
  }
}
