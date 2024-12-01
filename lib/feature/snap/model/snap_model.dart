import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:image/image.dart' as img;

import 'package:path_provider/path_provider.dart';

class Snap {
  final File _file;
  ui.Image _uiImage;
  // img.Image _imgImage;

  Snap._({required File file, required ui.Image uiImage})
      : _file = file,
        _uiImage = uiImage;

  // Future<ui.Image> _decodeImage(Uint8List bytes) async
  static Future<Snap> decode(File file) async {
    final codec = await ui.instantiateImageCodec(File(file.path).readAsBytesSync());
    final frame = await codec.getNextFrame();

    return Snap._(file: file, uiImage: frame.image);
  }

  ui.Image get uiImage => _uiImage;

  File get file => _file;

  int get size => _file.statSync().size;

  double get width => _uiImage.width.toDouble();
  double get height => _uiImage.height.toDouble();

  Future<img.Image> _uiToImg() async {
    final byteData = await _uiImage.toByteData(format: ui.ImageByteFormat.png);

    return img.decodeImage(byteData!.buffer.asUint8List())!;
  }

  // Future<ui.Image> _imgToUi() async {
  //   final pngBytes = Uint8List.fromList(img.encodePng(_imgImage));
  //   final codec = await ui.instantiateImageCodec(pngBytes);
  //   final frame = await codec.getNextFrame();

  //   return frame.image;
  // }

  Future<void> crop({required int tolerance}) async {
    final edges = await _findEdges(tolerance);

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, _uiImage.width.toDouble(), _uiImage.height.toDouble()),
      ui.Paint()..color = const ui.Color(0xFFFFFFFF),
    );

    double dstSrcW = (_uiImage.width - edges['left']! - edges['right']!).toDouble();
    double dstSrcH = (_uiImage.height - edges['top']! - edges['bottom']!).toDouble();

    canvas.drawImageRect(
      uiImage,
      ui.Rect.fromLTWH(edges['left']!.toDouble(), edges['top']!.toDouble(), dstSrcW, dstSrcH), // Область для обрізки
      ui.Rect.fromLTWH(edges['left']!.toDouble(), edges['top']!.toDouble(), dstSrcW, dstSrcH), // Розмір виходу
      ui.Paint(),
    );

    _uiImage = await recorder.endRecording().toImage(_uiImage.width, _uiImage.height);
  }

  Future<void> resize({required int newWidth, required int newHeight, required int padding}) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    double scaleFactor = min((newWidth - padding * 2) / uiImage.width, (newHeight - padding * 2) / uiImage.height);

    double dstWidth = (uiImage.width * scaleFactor).roundToDouble();
    double dstHeight = (uiImage.height * scaleFactor).roundToDouble();

    double dstX = (newWidth - padding * 2) > dstWidth ? (newWidth - dstWidth) / 2 : padding.toDouble();
    double dstY = (newHeight - padding * 2) > dstHeight ? (newHeight - dstHeight) / 2 : padding.toDouble();

    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()),
      ui.Paint()..color = const ui.Color(0xFFFFFFFF),
    );

    canvas.drawImageRect(
      uiImage,
      ui.Rect.fromLTWH(0, 0, uiImage.width.toDouble(), uiImage.height.toDouble()), // Область для обрізки
      ui.Rect.fromLTWH(dstX, dstY, dstWidth, dstHeight), // Розмір виходу
      ui.Paint(),
    );

    _uiImage = await recorder.endRecording().toImage(newWidth, newHeight);
  }

  Future<void> cropResize(
      {required int newWidth, required int newHeight, required int padding, required int tolerance}) async {
    final edges = await _findEdges(tolerance);

    double srcW = (_uiImage.width - edges['left']! - edges['right']!).toDouble();
    double srcH = (_uiImage.height - edges['top']! - edges['bottom']!).toDouble();

    double scaleFactor = min((newWidth - padding * 2) / srcW, (newHeight - padding * 2) / srcH);

    double dstW = (srcW * scaleFactor).roundToDouble();
    double dstH = (srcH * scaleFactor).roundToDouble();

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()),
      ui.Paint()..color = const ui.Color(0xFFFFFFFF),
    );

    canvas.drawImageRect(
      uiImage,
      ui.Rect.fromLTWH(edges['left']!.toDouble(), edges['top']!.toDouble(), srcW, srcH), // Область для обрізки
      ui.Rect.fromLTWH((newWidth - dstW) / 2, newHeight - padding - dstH, dstW, dstH), // Розмір виходу
      ui.Paint(),
    );

    _uiImage = await recorder.endRecording().toImage(newWidth, newHeight);
  }

  Future<File> getProcessed({required String format, required int quality}) async {
    final tempPath = await _getTempPath();

    if (format == 'png') {
      return File('$tempPath.png')..writeAsBytesSync(img.encodePng(await _uiToImg(), level: (quality / 10).round()));
    } else if (format == 'webp') {
    } else if (format == 'avif') {}

    return File('$tempPath.jpg')
      ..writeAsBytesSync(img.encodeJpg(await _uiToImg(), quality: quality, chroma: img.JpegChroma.yuv420));
  }

  Future<String> _getTempPath() async {
    final tempDir = Directory('${(await getTemporaryDirectory()).path}/temp_processed');

    if (!(await tempDir.exists())) {}
    await tempDir.create();

    await for (var file in tempDir.list()) {
      await file.delete();
    }
    return '${tempDir.path}/${basenameWithoutExtension(_file.path)}';
  }

  Future<Map<String, int>> _findEdges(int tolerance) async {
    final ByteData data = await uiImage.toByteData(format: ui.ImageByteFormat.rawRgba) ?? ByteData(0);

    final int width = uiImage.width;
    final int height = uiImage.height;

    int getPixel(ByteData data, int x, int y, int width) {
      final int index = (y * width + x) * 4; // RGBA має 4 байти на піксель
      final int r = data.getUint8(index);
      final int g = data.getUint8(index + 1);
      final int b = data.getUint8(index + 2);
      final int a = data.getUint8(index + 3);

      return (r << 24) | (g << 16) | (b << 8) | a; // ARGB формат
    }

    bool exceedsTolerance(int pixel, int target) {
      final r1 = (pixel >> 24) & 0xFF;
      final g1 = (pixel >> 16) & 0xFF;
      final b1 = (pixel >> 8) & 0xFF;

      final r2 = (target >> 24) & 0xFF;
      final g2 = (target >> 16) & 0xFF;
      final b2 = (target >> 8) & 0xFF;

      return (r1 - r2).abs() > tolerance || (g1 - g2).abs() > tolerance || (b1 - b2).abs() > tolerance;
    }

    int findEdge(bool horizontal, bool reverse, int targetPixel) {
      final max1 = horizontal ? width : height;
      final max2 = horizontal ? height : width;

      for (int primary = reverse ? max1 - 1 : 0; reverse ? primary >= 0 : primary < max1; primary += reverse ? -1 : 1) {
        for (int secondary = 0; secondary < max2; secondary++) {
          final x = horizontal ? primary : secondary;
          final y = horizontal ? secondary : primary;
          final pixel = getPixel(data, x, y, width);
          if (exceedsTolerance(pixel, targetPixel)) {
            return reverse ? max1 - primary : primary;
          }
        }
      }

      return 0;
    }

    final int topLeft = getPixel(data, 0, 0, width);
    final int bottomRight = getPixel(data, width - 1, height - 1, width);

    return {
      "top": findEdge(false, false, topLeft),
      "left": findEdge(true, false, topLeft),
      "right": findEdge(true, true, bottomRight),
      "bottom": findEdge(false, true, bottomRight),
    };
  }
}
