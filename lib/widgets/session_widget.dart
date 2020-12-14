import 'package:flutter/material.dart';
import 'package:minimalisticpush/controllers/session_controller.dart';

import 'package:minimalisticpush/styles/styles.dart';
import '../models/session.dart';

class SessionWidget extends StatelessWidget {
  const SessionWidget({
    Key key,
    @required this.session,
    @required this.parentState,
    @required this.idToShow,
  }) : super(key: key);

  final Session session;
  final State parentState;
  final int idToShow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 36.0,
              width: 36.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Text(idToShow.toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  )),
            ),
          ),
          Expanded(
            child: Text(
              session.count.toString(),
              softWrap: true,
              style: TextStyles.body,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(16.0),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              this.parentState.setState(() {
                SessionController.instance.deleteSession(this.session.id);
              });
            },
          )
        ],
      ),
    );
  }
}
