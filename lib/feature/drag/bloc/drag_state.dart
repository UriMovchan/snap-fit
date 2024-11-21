part of 'drag_bloc.dart';

sealed class DragState {}

final class InitialDragState extends DragState {}

final class EnteredDragState extends DragState {}

final class ExitedDragState extends DragState {}
