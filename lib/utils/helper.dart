import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

// Calculates image height based on its width and aspect ratio.
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

// Sets the screen to high refresh rate on Android.
void setHighRefreshRate() async {
  (Platform.isAndroid) ? await FlutterDisplayMode.setHighRefreshRate() : null;
}

