import 'package:flutter_bloc/flutter_bloc.dart';

part 'drag_event.dart';
part 'drag_state.dart';

class DragBloc extends Bloc<DragEvent, DragState> {
  DragBloc() : super(InitialDragState()) {
    on<EnterDragEvent>((EnterDragEvent event, Emitter<DragState> emit) {
      emit(EnteredDragState());
    });

    on<ExitDragEvent>((ExitDragEvent event, Emitter<DragState> emit) {
      emit(ExitedDragState());
    });
  }
}
