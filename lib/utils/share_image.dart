import 'dart:io';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:minimalisticpush/localizations.dart';
import 'package:minimalisticpush/widgets/share_image.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

void callShareImage(BuildContext context, List<double> peaks) async {
  Size imageSize = Size(900, 450);

  String path = await _createTempImageFileFromWidget(
    widget: ShareImage(
      primaryColor: Theme.of(context).primaryColor,
      accentColor: Theme.of(context).accentColor,
      size: imageSize,
      peaks: peaks,
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

  final UI.Image image = await repaintBoundary.toImage();
  final ByteData byteData =
      await image.toByteData(format: UI.ImageByteFormat.png);

  final tempDir = await getTemporaryDirectory();
  final file = await new File('${tempDir.path}/curve.png').create();
  file.writeAsBytesSync(byteData.buffer.asUint8List());

  return file.path;
}
