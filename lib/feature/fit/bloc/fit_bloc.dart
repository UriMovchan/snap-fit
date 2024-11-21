import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_fit/feature/fit/model/fit_model.dart';
import 'package:snap_fit/service/validator.dart';

part 'fit_event.dart';
part 'fit_state.dart';

class FitBloc extends Bloc<FitEvent, FitState> {
  FitBloc() : super(FitState()) {
    on<ChangeFitResizeEvent>((event, emit) {
      emit(state.copyWith(
        resize: event.resize,
        isValidResize: Validator.validate([state.width, state.height, state.padding]),
      ));
    }, transformer: debounce());

    on<ChangeFitWidthEvent>((event, emit) {
      final width = FitWidth.dirty(event.width);
      final padding = FitPadding.dirty(state.padding.value.toString(), {'width': width, 'height': state.height});

      emit(state.copyWith(
        width: width,
        padding: padding,
        isValidResize: Validator.validate([width, state.height, padding]),
      ));
    }, transformer: debounce());

    on<ChangeFitHeightEvent>((event, emit) {
      final height = FitHeight.dirty(event.height);
      final padding = FitPadding.dirty(state.padding.value.toString(), {'width': state.width, 'height': height});

      emit(state.copyWith(
        height: height,
        padding: padding,
        isValidResize: Validator.validate([state.width, height, padding]),
      ));
    }, transformer: debounce());

    on<ChangeFitPaddingEvent>((event, emit) {
      final padding = FitPadding.dirty(event.padding, {'width': state.width, 'height': state.height});

      emit(state.copyWith(
        padding: padding,
        isValidResize: Validator.validate([state.width, state.height, padding]),
      ));
    }, transformer: debounce());

    on<ChangeFitCropEvent>((event, emit) {
      emit(state.copyWith(
        crop: event.crop,
        isValidCrop: Validator.validate([state.tolerance]),
      ));
    }, transformer: debounce());

    on<ChangeFitToleranceEvent>((event, emit) {
      final tolerance = FitTolerance.dirty(event.tolerance);

      emit(state.copyWith(
        tolerance: tolerance,
        isValidCrop: Validator.validate([state.tolerance]),
      ));
    }, transformer: debounce());

    on<ChangeFitFormatEvent>((event, emit) {
      emit(state.copyWith(format: event.format));
    }, transformer: debounce());

    on<ChangeFitQualityEvent>((event, emit) {
      emit(state.copyWith(quality: event.quality));
    }, transformer: debounce());
  }

  EventTransformer<Event> debounce<Event>({Duration duration = const Duration(milliseconds: 300)}) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }
}
