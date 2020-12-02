class Session {
  int id;
  final int count;

  Session({this.id, this.count});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'count': count,
    };
  }
}
