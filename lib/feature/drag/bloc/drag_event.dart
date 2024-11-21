part of 'drag_bloc.dart';

sealed class DragEvent {}

final class EnterDragEvent extends DragEvent {}

final class ExitDragEvent extends DragEvent {}
