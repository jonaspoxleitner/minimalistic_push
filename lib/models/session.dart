/// The session object.
class Session {
  /// The id of the session.
  int? id;

  /// The number of push-ups of the session.
  final int? count;

  /// The constructor of the session object.
  Session({this.id, this.count});

  /// Returns the representation of a session as a map.
  Map<String, dynamic> toMap() => {
        'id': id,
        'count': count,
      };
}
