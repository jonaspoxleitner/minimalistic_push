import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimalistic_push/control/session_controller.dart';
import 'package:minimalistic_push/localizations.dart';
import 'package:minimalistic_push/models/session.dart';
import 'package:minimalistic_push/styles/styles.dart';
import 'package:minimalistic_push/widgets/navigation_bar.dart';

/// The content for the session overlay route.
class SessionsContent extends StatelessWidget {
  /// The constructor.
  const SessionsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<SessionController>(
        builder: (sessionController) {
          var list = sessionController.sessions.toList();

          if (list.isEmpty) {
            return const _NoSessionWidget();
          } else {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
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

  Widget _buildHighscore(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.emoji_events, color: Colors.white, size: 50.0),
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

class _NoSessionWidget extends StatelessWidget {
  const _NoSessionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          MyLocalizations.of(context).values!['sessions']['empty'],
          style: TextStyles.body,
        ),
      );
}

class _SessionWidget extends StatelessWidget {
  final Session session;
  final int idToShow;

  const _SessionWidget({
    Key? key,
    required this.session,
    required this.idToShow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 36.0,
                width: 36.0,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  idToShow.toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                session.count.toString(),
                softWrap: true,
                style: TextStyles.body,
              ),
            ),
            NavigationOption(
              icon: Icons.remove_circle_outline,
              onPressed: () => Get.find<SessionController>().deleteSession(session.id!),
            ),
          ],
        ),
      );
}

// /// The content for the session overlay route.
// class SessionsContent extends StatelessWidget {
//   /// The constructor.
//   const SessionsContent({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) => GetBuilder<SessionController>(
//         builder: (sessionController) {
//           var list = sessionController.sessions.toList();

//           if (list.isEmpty) {
//             return const _NoSessionWidget();
//           } else {
//             return SingleChildScrollView(
//               child: SafeArea(
//                 child: Column(
//                   children: [
//                     for (var i = 0; i < list.length + 2; i++)
//                       if (i == 0)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 70.0),
//                           child: _buildHighscore(context),
//                         )
//                       else if (i == 1) ...[
//                         Container(color: Colors.red, height: 240.0),
//                         const SizedBox(height: 8.0),
//                       ] else ...[
//                         _SessionWidget(
//                           session: list[list.length + 1 - i],
//                           idToShow: list.length - i + 2,
//                         ),
//                         if (i < list.length + 1)
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 16.0),
//                             child: Divider(height: 1.0, color: Colors.white, thickness: 1.0),
//                           ),
//                       ]
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       );

//   Widget _buildHighscore(BuildContext context) => Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Icon(
//               Icons.emoji_events,
//               color: Colors.white,
//               size: 50.0,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               Get.find<SessionController>().highscore.toInt().toString(),
//               style: TextStyles.heading,
//             ),
//           ),
//         ],
//       );
// }

// class _NoSessionWidget extends StatelessWidget {
//   const _NoSessionWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text(
//             MyLocalizations.of(context).values!['sessions']['empty'],
//             style: TextStyles.body,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
// }

// class _SessionWidget extends StatelessWidget {
//   final Session session;
//   final int idToShow;

//   const _SessionWidget({
//     Key? key,
//     required this.session,
//     required this.idToShow,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Text(
//                 '#$idToShow',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.normal,
//                   fontSize: 16.0,
//                 ),
//                 textScaleFactor: 1.0,
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Text(
//                     '${session.count}',
//                     softWrap: true,
//                     style: TextStyles.body.copyWith(color: Theme.of(context).primaryColor),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ),
//             Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 splashColor: Colors.white.withOpacity(0.1),
//                 highlightColor: Colors.white.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(1000.0),
//                 onTap: () => Get.find<SessionController>().deleteSession(session.id!),
//                 child: const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Icon(Icons.remove_circle_outline, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
// }
