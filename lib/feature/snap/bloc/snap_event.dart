part of 'snap_bloc.dart';

abstract class SnapEvent {}

class CloseSnapEvent extends SnapEvent {}

class SnapSetSeparatorPositionEvent extends SnapEvent {
  final double position;

  SnapSetSeparatorPositionEvent({required this.position});
}

class SnapUpdateSeparatorPositionEvent extends SnapEvent {
  final double position;

  SnapUpdateSeparatorPositionEvent({required this.position});
}

class SnapScaleEvent extends SnapEvent {
  final double scale;

  SnapScaleEvent({required this.scale});
}

class SnapPickEvent extends SnapEvent {}

class SnapInitLoadingEvent extends SnapEvent {}

class SnapDropEvent extends SnapEvent {
  final File image;

  SnapDropEvent(this.image);
}

class SaveSnapEvent extends SnapEvent {}

class ProcessSnapEvent extends SnapEvent {}

class SnapErrorEvent extends SnapEvent {
  final String error;

  SnapErrorEvent(this.error);
}
