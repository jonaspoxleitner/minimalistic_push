import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import '../localizations.dart';
import '../widgets/share_image.dart';

/// This method calls and handles the Share API.
void callShareImage(BuildContext context, List<double> peaks) async {
  var imageSize = Size(900, 450);

  var path = await _createTempImageFileFromWidget(
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

// Code by Christian Mürtz, GitHub: christian-muertz with slight modifications
Future<String> _createTempImageFileFromWidget(
    {Widget widget, Size size}) async {
  final repaintBoundary = RenderRepaintBoundary();

  assert(widget != null);
  assert(size != null);

  final renderView = RenderView(
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

  final pipelineOwner = PipelineOwner();
  final buildOwner = BuildOwner();

  pipelineOwner.rootNode = renderView;
  renderView.prepareInitialFrame();

  final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
    container: repaintBoundary,
    child: widget,
  ).attachToRenderTree(buildOwner);

  buildOwner.buildScope(rootElement);

  buildOwner.buildScope(rootElement);
  buildOwner.finalizeTree();

  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();

  final image = await repaintBoundary.toImage();
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  final tempDir = await getTemporaryDirectory();
  final file = await File('${tempDir.path}/curve.png').create();
  file.writeAsBytesSync(byteData.buffer.asUint8List());

  return file.path;
}
