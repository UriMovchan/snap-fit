part of 'snap_bloc.dart';

final class SnapState {
  final Snap? originalSnap;
  final File? processedSnap;
  final double width;
  final double height;
  final double? separatorPosition;
  final double snapScale;
  final bool loading;
  final String? error;

  SnapState({
    this.originalSnap,
    this.processedSnap,
    this.width = 1000,
    this.height = 1000,
    this.separatorPosition,
    this.snapScale = 1,
    this.loading = false,
    this.error,
  });

  SnapState copyWith({
    Snap? originalSnap,
    File? processedSnap,
    double? width,
    double? height,
    double? separatorPosition,
    double? snapScale,
    bool? loading,
    String? error,
    bool originalSnapNull = false,
    bool processedSnapNull = false,
  }) {
    return SnapState(
      originalSnap: originalSnapNull ? null : originalSnap ?? this.originalSnap,
      processedSnap: processedSnapNull ? null : processedSnap ?? this.processedSnap,
      width: width ?? this.width,
      height: height ?? this.height,
      separatorPosition: separatorPosition ?? this.separatorPosition,
      snapScale: snapScale ?? this.snapScale,
      loading: loading ?? false,
      error: error,
    );
  }
}
