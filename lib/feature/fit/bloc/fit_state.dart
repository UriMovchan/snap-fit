part of 'fit_bloc.dart';

final class FitState {
  final String? error;
  final bool resize;
  final FitWidth width;
  final FitHeight height;
  final FitPadding padding;
  final bool isValidResize;

  final bool crop;
  final FitTolerance tolerance;
  final bool isValidCrop;

  final String format;
  final int quality;

  final bool isFitting;

  FitState({
    this.error,
    this.resize = true,
    this.width = const FitWidth.dirty('1000'),
    this.height = const FitHeight.dirty('1000'),
    this.padding = const FitPadding.dirty('70', {'width': FitWidth.dirty('1000'), 'height': FitHeight.dirty('1000')}),
    bool? isValidResize,
    this.crop = true,
    this.tolerance = const FitTolerance.dirty('12'),
    bool? isValidCrop,
    this.format = 'jpg',
    this.quality = 79,
    this.isFitting = false,
  })  : isValidResize = isValidResize ?? Validator.validate([width, height, padding]),
        isValidCrop = isValidCrop ?? Validator.validate([tolerance]);

  FitState copyWith({
    String? error,
    bool? resize,
    FitWidth? width,
    FitHeight? height,
    FitPadding? padding,
    bool? isValidResize,
    bool? crop,
    FitTolerance? tolerance,
    bool? isValidCrop,
    String? format,
    int? quality,
    bool? isFitting,
  }) {
    return FitState(
        error: error ?? this.error,
        resize: resize ?? this.resize,
        width: width ?? this.width,
        height: height ?? this.height,
        padding: padding ?? this.padding,
        isValidResize: isValidResize ?? this.isValidResize,
        crop: crop ?? this.crop,
        tolerance: tolerance ?? this.tolerance,
        isValidCrop: isValidCrop ?? this.isValidCrop,
        format: format ?? this.format,
        quality: quality ?? this.quality,
        isFitting: isFitting ?? false);
  }
}
