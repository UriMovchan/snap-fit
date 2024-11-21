import 'dart:io';
import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_fit/feature/fit/bloc/fit_bloc.dart';
import 'package:snap_fit/feature/snap/model/snap_model.dart';

part 'snap_event.dart';
part 'snap_state.dart';

class SnapBloc extends Bloc<SnapEvent, SnapState> {
  final FitBloc fitBloc;

  late final StreamSubscription fitSubscription;

  SnapBloc({required this.fitBloc}) : super(SnapState()) {
    fitSubscription = fitBloc.stream.listen((fitState) {
      add(ProcessSnapEvent());
    });

    on<SnapSetSeparatorPositionEvent>((SnapSetSeparatorPositionEvent event, Emitter<SnapState> emit) {
      emit(state.copyWith(separatorPosition: event.position));
    });

    on<SnapUpdateSeparatorPositionEvent>((SnapUpdateSeparatorPositionEvent event, Emitter<SnapState> emit) {
      emit(state.copyWith(separatorPosition: (state.separatorPosition ?? 0) + event.position));
    });

    on<SnapScaleEvent>((SnapScaleEvent event, Emitter<SnapState> emit) {
      emit(state.copyWith(snapScale: event.scale));
    });

    on<SnapPickEvent>((SnapPickEvent event, Emitter<SnapState> emit) async {
      emit(state.copyWith(loading: true));

      try {
        final result = await FilePicker.platform.pickFiles(type: FileType.image);

        if (result != null) {
          add(SnapDropEvent(File(result.files.single.path!)));
        } else {
          add(SnapErrorEvent('Зображення не вибрано.'));
        }
      } catch (e) {
        add(SnapErrorEvent('Помилка: $e'));
      }
    });

    on<SnapDropEvent>((SnapDropEvent event, Emitter<SnapState> emit) {
      Snap snap = Snap(file: event.image);

      emit(state.copyWith(
          loading: true, originalSnap: event.image, processedSnap: null, width: snap.width, height: snap.height));

      add(ProcessSnapEvent());
    });

    on<SaveSnapEvent>((SaveSnapEvent event, Emitter<SnapState> emit) async {
      final String? pickerPath =
          await FilePicker.platform.saveFile(type: FileType.image, fileName: path.basename(state.originalSnap!.path));

      if (pickerPath != null) {
        File(pickerPath).writeAsBytesSync(File(state.processedSnap!.path).readAsBytesSync());
      }
    });

    on<SnapErrorEvent>((SnapErrorEvent event, Emitter<SnapState> emit) {
      emit(state.copyWith(originalSnap: null, processedSnap: null, error: event.error));
    });

    on<ProcessSnapEvent>((ProcessSnapEvent event, Emitter<SnapState> emit) async {
      emit(state.copyWith(loading: true, processedSnap: state.processedSnap));

      try {
        Snap snap = Snap(file: state.originalSnap!);

        FitState fit = fitBloc.state;

        if (fit.crop && fit.isValidCrop && fit.resize && fit.isValidResize) {
          snap.cropResize(
            newWidth: fit.width.value!,
            newHeight: fit.height.value!,
            padding: fit.padding.value,
            tolerance: fit.tolerance.value,
          );
        } else if (fit.crop && fit.isValidCrop) {
          snap.crop(tolerance: fit.tolerance.value);
        } else if (fit.resize && fit.isValidResize) {
          snap.resize(newWidth: fit.width.value!, newHeight: fit.height.value!, padding: fit.padding.value);
        }

        final File processedFile = await snap.getProcessed(format: fit.format, quality: fit.quality);

        emit(state.copyWith(processedSnap: processedFile, width: snap.width, height: snap.height));
      } catch (e) {
        emit(state.copyWith(error: 'Помилка обробки: $e'));
      }
    });
  }
}