import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snap_fit/feature/fit/bloc/fit_bloc.dart';
import 'package:snap_fit/feature/fit/model/fit_model.dart';
import 'package:snap_fit/feature/snap/bloc/snap_bloc.dart';

class FitView extends StatelessWidget {
  const FitView({super.key});

  @override
  Widget build(BuildContext context) {
    File? originalSnap = context.select<SnapBloc, File?>((snapBloc) => snapBloc.state.originalSnap);

    return originalSnap == null
        ? Container()
        : Builder(
            builder: (context) {
              bool resize = context.select<FitBloc, bool>((fitBloc) => fitBloc.state.resize);
              bool crop = context.select<FitBloc, bool>((fitBloc) => fitBloc.state.crop);

              bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

              Color fitterBoxColor = isDarkMode ? Colors.black87 : Colors.grey.shade300;
              Color fitterTitleBoxColor = isDarkMode ? Colors.blueGrey.shade900 : Colors.blueGrey.shade200;

              return Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: fitterBoxColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                  ),
                  width: 300,
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                        decoration: BoxDecoration(
                          color: fitterTitleBoxColor,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10)),
                        ),
                        child: _FitResizeSwitch(),
                      ),
                      if (resize) ...[
                        const SizedBox(height: 11),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                          child: Column(
                            children: [
                              _FitWidthInput(),
                              const SizedBox(height: 11),
                              _FitHeightInput(),
                              const SizedBox(height: 11),
                              _FitPaddingInput(),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: resize ? 11 : 1.5),
                      Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                        decoration: BoxDecoration(color: fitterTitleBoxColor),
                        child: _FitCropSwitch(),
                      ),
                      if (crop) ...[
                        const SizedBox(height: 11),
                        _FitToleranceInput(),
                      ],
                      SizedBox(height: crop ? 11 : 1.5),
                      Container(
                        height: 45,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                        decoration: BoxDecoration(color: fitterTitleBoxColor),
                        child: const Row(children: [Text('Форматування')]),
                      ),
                      const SizedBox(height: 11),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                        child: Column(
                          children: [
                            _FitFormatSelect(),
                            const SizedBox(height: 11),
                            _FitQualitySlider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

class _FitResizeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<FitBloc, FitState, bool>(
      selector: (state) => state.resize,
      builder: (context, resize) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Масштабування'),
            Transform.scale(
              scale: 0.55,
              alignment: Alignment.centerRight,
              child: Switch.adaptive(
                key: const Key('fit_resize_switch'),
                value: resize,
                onChanged: (value) => context.read<FitBloc>().add(ChangeFitResizeEvent(value)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FitWidthInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<FitBloc, FitState, FitWidth>(
      selector: (state) => state.width,
      builder: (context, width) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ширина'),
            SizedBox(
              width: 175,
              child: TextFormField(
                key: const Key('fit_width_textField'),
                initialValue: width.value.toString(),
                keyboardType: TextInputType.number,
                onChanged: (width) => context.read<FitBloc>().add(ChangeFitWidthEvent(width)),
                decoration: InputDecoration(errorText: width.error),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FitHeightInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<FitBloc, FitState, FitHeight>(
      selector: (state) => state.height,
      builder: (context, height) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Висота'),
            SizedBox(
              width: 175,
              child: TextFormField(
                key: const Key('fit_height_textField'),
                initialValue: height.value.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) => context.read<FitBloc>().add(ChangeFitHeightEvent(value)),
                decoration: InputDecoration(errorText: height.error),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FitPaddingInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<FitBloc, FitState, FitPadding>(
      selector: (state) => state.padding,
      builder: (context, padding) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Відступ'),
            SizedBox(
              width: 175,
              child: TextFormField(
                key: const Key('fit_padding_textField'),
                initialValue: padding.value.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) => context.read<FitBloc>().add(ChangeFitPaddingEvent(value)),
                decoration:
                    InputDecoration(errorText: padding.error, errorMaxLines: 2, errorStyle: TextStyle(fontSize: 11)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FitCropSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<FitBloc, FitState, bool>(
      selector: (state) => state.crop,
      builder: (context, crop) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Видаляти фон'),
            Transform.scale(
              scale: 0.55,
              alignment: Alignment.centerRight,
              child: Switch.adaptive(
                key: const Key('fit_crop_switch'),
                value: crop,
                onChanged: (value) => context.read<FitBloc>().add(ChangeFitCropEvent(value)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FitToleranceInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<FitBloc, FitState, FitTolerance>(
      selector: (state) => state.tolerance,
      builder: (context, tolerance) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Допуск'),
              SizedBox(
                width: 175,
                child: TextFormField(
                  key: const Key('fit_tolerance_textField'),
                  initialValue: tolerance.value.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => context.read<FitBloc>().add(ChangeFitToleranceEvent(value)),
                  decoration: InputDecoration(errorText: tolerance.error),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FitFormatSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<FitBloc, FitState, String>(
      selector: (state) => state.format,
      builder: (context, format) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 268,
              child: DropdownButtonFormField(
                value: format,
                onChanged: (value) => context.read<FitBloc>().add(ChangeFitFormatEvent(value)),
                items: ['jpg', 'png', 'webp'].map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FitQualitySlider extends StatefulWidget {
  @override
  State<_FitQualitySlider> createState() => _FitQualitySliderState();
}

class _FitQualitySliderState extends State<_FitQualitySlider> {
  bool _isSliding = false;
  double? _currentSliderValue;

  @override
  Widget build(BuildContext context) {
    _currentSliderValue ??= context.select<FitBloc, double>((bloc) => bloc.state.quality.toDouble());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Якість'),
            if (!_isSliding) ...[Text(_currentSliderValue!.round().toString())],
          ],
        ),
        Slider(
          value: _currentSliderValue!,
          max: 100,
          divisions: 100,
          label: _currentSliderValue!.round().toString(),
          onChangeStart: (value) => setState(() => _isSliding = true),
          onChangeEnd: (value) => setState(() => _isSliding = false),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
              context.read<FitBloc>().add(ChangeFitQualityEvent(value.toInt()));
            });
          },
        ),
      ],
    );
  }
}
