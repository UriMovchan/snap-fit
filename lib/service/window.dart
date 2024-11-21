import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'package:snap_fit/service/storage.dart';

class Window with WindowListener {
  Future<void> init() async {
    await windowManager.ensureInitialized();

    final dynamic bounds = Storage.get('bounds');

    final double width = bounds?['width'] ?? 1024;
    final double height = bounds?['height'] ?? 750;
    final double? x = bounds?['x'];
    final double? y = bounds?['y'];

    if (x != null && y != null) windowManager.setPosition(Offset(x, y));

    windowManager.waitUntilReadyToShow(
        WindowOptions(
          size: Size(width, height),
          center: x == null || y == null,
          backgroundColor: Colors.transparent,
          skipTaskbar: false,
          titleBarStyle: TitleBarStyle.hidden,
        ), () async {
      await windowManager.show();
    });

    windowManager.addListener(this);
  }

  Future<void> setBounds() async {
    final Size size = await windowManager.getSize();
    final Offset position = await windowManager.getPosition();

    final dynamic newBounds = {
      'width': size.width,
      'height': size.height,
      'x': position.dx,
      'y': position.dy,
    };

    Storage.set('bounds', newBounds);
  }

  @override
  void onWindowResized() => setBounds();

  @override
  void onWindowMoved() => setBounds();
}
