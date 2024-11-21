part of 'snap_bloc.dart';

final class SnapState {
  final File? originalSnap;
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
    File? originalSnap,
    File? processedSnap,
    double? width,
    double? height,
    double? separatorPosition,
    double? snapScale,
    bool? loading,
    String? error,
  }) {
    return SnapState(
      originalSnap: originalSnap ?? this.originalSnap,
      processedSnap: processedSnap ?? this.processedSnap,
      width: width ?? this.width,
      height: height ?? this.height,
      separatorPosition: separatorPosition ?? this.separatorPosition,
      snapScale: snapScale ?? this.snapScale,
      loading: loading ?? false,
      error: error,
    );
  }
}
