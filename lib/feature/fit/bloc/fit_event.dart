part of 'fit_bloc.dart';

sealed class FitEvent {}

final class ChangeFitResizeEvent extends FitEvent {
  final bool resize;

  ChangeFitResizeEvent(this.resize);
}

final class ChangeFitWidthEvent extends FitEvent {
  final String width;

  ChangeFitWidthEvent(this.width);
}

final class ChangeFitHeightEvent extends FitEvent {
  final String height;

  ChangeFitHeightEvent(this.height);
}

final class ChangeFitPaddingEvent extends FitEvent {
  final String padding;

  ChangeFitPaddingEvent(this.padding);
}

final class ChangeFitCropEvent extends FitEvent {
  final bool crop;

  ChangeFitCropEvent(this.crop);
}

final class ChangeFitToleranceEvent extends FitEvent {
  final String tolerance;

  ChangeFitToleranceEvent(this.tolerance);
}

final class ChangeFitFormatEvent extends FitEvent {
  final String? format;

  ChangeFitFormatEvent(this.format);
}

final class ChangeFitQualityEvent extends FitEvent {
  final int quality;

  ChangeFitQualityEvent(this.quality);
}
