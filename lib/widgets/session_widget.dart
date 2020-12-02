import 'package:flutter/material.dart';

import '../models/session.dart';

class SessionWidget extends StatelessWidget {
  const SessionWidget({
    Key key,
    @required this.session,
  }) : super(key: key);

  final Session session;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Session ' + session.id.toString(),
        ),
        Text(
          session.count.toString(),
        ),
      ],
    );
  }
}
