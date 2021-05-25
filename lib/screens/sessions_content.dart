import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../localizations.dart';
import '../managers/session_controller.dart';
import '../models/session.dart';
import '../styles/styles.dart';

/// The content for the session overlay route.
class SessionsContent extends StatelessWidget {
  /// The constructor.
  const SessionsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionController>(
      builder: (sessionController) {
        var list = sessionController.sessions.toList();

        if (list.isEmpty) {
          return _NoSessionWidget();
        } else {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: list.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: _buildHighscore(context),
                );
              } else {
                var id = list.length - index + 1;
                return _SessionWidget(
                  session: list[list.length - index],
                  idToShow: id,
                );
              }
            },
          );
        }
      },
    );
  }

  Widget _buildHighscore(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            Icons.emoji_events,
            color: Colors.white,
            size: 50.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            Get.find<SessionController>().highscore.toInt().toString(),
            style: TextStyles.heading,
          ),
        ),
      ],
    );
  }
}

class _NoSessionWidget extends StatelessWidget {
  const _NoSessionWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        MyLocalizations.of(context).values!['sessions']['empty'],
        style: TextStyles.body,
      ),
    );
  }
}

class _SessionWidget extends StatelessWidget {
  const _SessionWidget({
    Key? key,
    required this.session,
    required this.idToShow,
  }) : super(key: key);

  final Session session;
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
              Icons.remove_circle_outline,
              color: Colors.white,
            ),
            onPressed: () =>
                Get.find<SessionController>().deleteSession(session.id!),
          )
        ],
      ),
    );
  }
}
