import 'package:snap_fit/service/validator.dart';

class FitWidth extends SingleValidator<int?> {
  const FitWidth.pure() : super.pure('');
  const FitWidth.dirty([super.value = '']) : super.dirty();

  @override
  String? singleValidator(String value) {
    if (value.isEmpty) return 'Задай бажану ширину';

    int? parsedValue = int.tryParse(value);

    if (parsedValue == null) return 'Має бути числом';

    if (parsedValue < 1) return 'Треба більше 0';

    return null;
  }
}

class FitHeight extends SingleValidator<int?> {
  const FitHeight.pure() : super.pure('');
  const FitHeight.dirty([super.value = '']) : super.dirty();

  @override
  String? singleValidator(String value) {
    if (value.isEmpty) return 'Задай бажану висоту';

    int? parsedValue = int.tryParse(value);

    if (parsedValue == null) return 'Має бути числом';

    if (parsedValue < 1) return 'Треба більше 0';

    return null;
  }
}

class FitPadding extends DependedValidator<int, dynamic> {
  const FitPadding.pure() : super.pure('');
  const FitPadding.dirty([super.value = '', super.dependency]) : super.dirty();

  @override
  String? dependedValidator(String value, dynamic dependency) {
    FitWidth width = dependency?['width'];
    FitHeight height = dependency?['height'];

    if (value.isEmpty) return 'Задай бажаний відступ';

    int? parsedValue = int.tryParse(value);

    if (parsedValue == null) return 'Має бути числом';

    if (parsedValue < 0) return 'Меньше 0 не можна';

    if (width.isValid && (width.value! < (parsedValue * 2))) {
      return 'Відступ * 2 не може бути більший за ширину';
    }

    if (height.isValid && (height.value! < (parsedValue * 2))) {
      return 'Відступ * 2 не може бути більший за висоту';
    }

    return null;
  }
}

class FitTolerance extends SingleValidator<int> {
  const FitTolerance.pure() : super.pure('');
  const FitTolerance.dirty([super.value = '']) : super.dirty();

  @override
  String? singleValidator(String value) {
    if (value.isEmpty) return 'Задай бажаний допуск';

    int? parsedValue = int.tryParse(value);

    if (parsedValue == null) return 'Має бути числом';

    if (parsedValue < 0) return 'Меньше 0 не можна';

    return null;
  }
}
