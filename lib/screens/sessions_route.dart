import 'dart:io';
import 'dart:ui' as UI;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:minimalisticpush/controllers/session_controller.dart';
import 'package:minimalisticpush/localizations.dart';
import 'package:minimalisticpush/models/session.dart';
import 'package:minimalisticpush/screens/error_screen.dart';
import 'package:minimalisticpush/screens/loading_screen.dart';
import 'package:minimalisticpush/styles/styles.dart';
import 'package:minimalisticpush/widgets/location_text.dart';
import 'package:minimalisticpush/widgets/share_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({
    Key key,
  }) : super(key: key);

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  LocationText(
                    text: MyLocalizations.of(context)
                        .getLocale('sessions')['title'],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(16.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          Icons.reply,
                          color: Colors.white,
                        ),
                        onPressed: () => _callShareImage(context),
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
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                ],
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: SessionController.instance.loadSessions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var sessions = SessionController.instance.getSessions();

                      if (sessions.length == 0) {
                        return Center(
                          child: Text(
                            MyLocalizations.of(context)
                                .getLocale('sessions')['empty'],
                            style: TextStyles.body,
                          ),
                        );
                      } else {
                        List<Widget> sessionWidgets = [];

                        var counter = 1;
                        for (Session session in sessions) {
                          sessionWidgets.add(
                            SessionWidget(
                              session: session,
                              parentState: this,
                              idToShow: counter,
                            ),
                          );
                          counter++;
                        }

                        return ListView(
                          children: sessionWidgets,
                        );
                      }
                    } else if (snapshot.hasError) {
                      return ErrorScreen();
                    } else {
                      return LoadingScreen();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _callShareImage(BuildContext context) async {
    Size imageSize = Size(900, 450);

    String path = await _createTempImageFileFromWidget(
      widget: ShareImage(
        primaryColor: Theme.of(context).primaryColor,
        accentColor: Theme.of(context).accentColor,
        size: imageSize,
      ),
      size: imageSize,
    );

    Share.shareFiles(
      [path],
      mimeTypes: ['image/png'],
      subject: MyLocalizations.of(context).getLocale('share')['subject'],
      text: MyLocalizations.of(context).getLocale('share')['text'],
    );
  }

  // Code by Christian Mürtz, GitHub: christian-muertz with slight modifications by me
  Future<String> _createTempImageFileFromWidget(
      {Widget widget, Size size}) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    assert(widget != null);
    assert(size != null);

    final RenderView renderView = RenderView(
      window: null,
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        size: size,
        devicePixelRatio: 1.0,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner();

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: widget,
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final UI.Image image =
        await repaintBoundary.toImage(pixelRatio: size.width / size.width);
    final ByteData byteData =
        await image.toByteData(format: UI.ImageByteFormat.png);

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/curve.png').create();
    file.writeAsBytesSync(byteData.buffer.asUint8List());

    return file.path;
  }
}

class SessionWidget extends StatelessWidget {
  final Session session;
  final State parentState;
  final int idToShow;

  const SessionWidget({
    @required this.session,
    @required this.parentState,
    @required this.idToShow,
  });

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
