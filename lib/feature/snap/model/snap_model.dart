import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';
import 'package:image/image.dart';

import 'package:path_provider/path_provider.dart';

class Snap {
  final String _path;
  Image _image;

  Snap({required File file})
      : _path = file.path,
        _image = decodeImage(file.readAsBytesSync())!;

  double get width => _image.width.toDouble();
  double get height => _image.height.toDouble();

  void crop({required int tolerance}) {
    final edges = _findEdges(tolerance);

    Image newImage = fill(Image(width: _image.width, height: _image.height), color: ColorFloat32.rgb(255, 255, 255));

    _image = compositeImage(
      newImage,
      _image,
      dstX: edges['left'],
      dstY: edges['top'],
      dstW: _image.width - edges['left']! - edges['right']!,
      dstH: _image.height - edges['top']! - edges['bottom']!,
      srcX: edges['left'],
      srcY: edges['top'],
      srcW: _image.width - edges['left']! - edges['right']!,
      srcH: _image.height - edges['top']! - edges['bottom']!,
    );
  }

  void resize({required int newWidth, required int newHeight, required int padding}) {
    if (_image.width > _image.height) {
      _image = copyResize(_image, width: newWidth - padding * 2);
    } else {
      _image = copyResize(_image, height: newHeight - padding * 2);
    }

    _image = copyExpandCanvas(_image,
        newWidth: newWidth - padding * 2,
        newHeight: newHeight - padding * 2,
        backgroundColor: ColorFloat32.rgb(255, 255, 255),
        position: ExpandCanvasPosition.bottomCenter);

    _image = copyExpandCanvas(_image,
        padding: padding, backgroundColor: ColorFloat32.rgb(255, 255, 255), position: ExpandCanvasPosition.center);
  }

  void cropResize({required int newWidth, required int newHeight, required int padding, required int tolerance}) {
    Image newImage = fill(Image(width: newWidth, height: newHeight), color: ColorFloat32.rgb(255, 255, 255));

    final edges = _findEdges(tolerance);

    int srcW = _image.width - edges['left']! - edges['right']!;
    int srcH = _image.height - edges['top']! - edges['bottom']!;

    double scaleFactor = min((newWidth - padding * 2) / srcW, (newHeight - padding * 2) / srcH);

    int dstW = (srcW * scaleFactor).round();
    int dstH = (srcH * scaleFactor).round();

    _image = compositeImage(
      newImage,
      _image,
      dstX: (newWidth - dstW) ~/ 2,
      dstY: newHeight - padding - dstH,
      dstW: dstW,
      dstH: dstH,
      srcX: edges['left'],
      srcY: edges['top'],
      srcW: srcW,
      srcH: srcH,
    );
  }

  Future<File> getProcessed({required String format, required int quality}) async {
    final tempPath = await _getTempPath();

    if (format == 'png') {
      return File(tempPath)..writeAsBytesSync(encodePng(_image, level: 5));
    } else if (format == 'webp') {
    } else if (format == 'avif') {}

    return File(tempPath)..writeAsBytesSync(encodeJpg(_image, quality: quality, chroma: JpegChroma.yuv420));
  }

  Future<String> _getTempPath() async {
    final tempDir = Directory('${(await getTemporaryDirectory()).path}/temp_processed');

    if (!(await tempDir.exists())) {}
    await tempDir.create();

    await for (var file in tempDir.list()) {
      await file.delete();
    }
    return '${tempDir.path}/${basename(_path)}';
  }

  Map<String, int> _findEdges(int tolerance) {
    final targetColors = {
      'topLeft': _image.getPixel(0, 0),
      'bottomRight': _image.getPixel(_image.width - 1, _image.height - 1),
    };

    bool exceedsTolerance(Color pixel, Color target) {
      return (pixel.r - target.r).abs() > tolerance ||
          (pixel.g - target.g).abs() > tolerance ||
          (pixel.b - target.b).abs() > tolerance;
    }

    int findEdge(bool horizontal, bool reverse, String cornerKey) {
      final max1 = horizontal ? _image.width : _image.height;
      final max2 = horizontal ? _image.height : _image.width;

      for (int primary = reverse ? max1 - 1 : 0; reverse ? primary >= 0 : primary < max1; primary += reverse ? -1 : 1) {
        for (int secondary = 0; secondary < max2; secondary++) {
          final x = horizontal ? primary : secondary;
          final y = horizontal ? secondary : primary;
          if (exceedsTolerance(_image.getPixel(x, y), targetColors[cornerKey]!)) {
            return reverse ? max1 - primary : primary;
          }
        }
      }

      return 0;
    }

    return {
      "top": findEdge(false, false, 'topLeft'),
      "left": findEdge(true, false, 'topLeft'),
      "right": findEdge(true, true, 'bottomRight'),
      "bottom": findEdge(false, true, 'bottomRight'),
    };
  }
}
