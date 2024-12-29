import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

Future<double> getImageHeight(String url, double desiredWidth) async {
  final image = NetworkImage(url);
  final completer = Completer<ImageInfo>();
  final stream = image.resolve(ImageConfiguration());

  stream.addListener(
    ImageStreamListener((ImageInfo info, bool synchronousCall) {
      completer.complete(info);
    }),
  );

  final imageInfo = await completer.future;

  double imageWidth = imageInfo.image.width.toDouble();
  double imageHeight = imageInfo.image.height.toDouble();

  double aspectRatio = imageWidth / imageHeight;

  double calculatedHeight = desiredWidth / aspectRatio;

  return calculatedHeight;
}

void setHighRefreshRate() async {
  print("object");
  (Platform.isAndroid) ? await FlutterDisplayMode.setHighRefreshRate() : null;
}

