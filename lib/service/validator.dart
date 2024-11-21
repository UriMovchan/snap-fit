abstract class Validator<T> {
  static bool validate(List<Validator<dynamic>> inputs) {
    return inputs.every((input) => input.isValid);
  }

  const Validator({required value, this.isPure = true, dependency}) : _value = value;

  final bool isPure;

  final String _value;

  T get value {
    if (T == int) {
      return (int.tryParse(_value) ?? 0) as T;
    } else if (T.toString() == 'int?') {
      return int.tryParse(_value) as T;
    } else if (T == double) {
      return (double.tryParse(_value) ?? 0.0) as T;
    } else if (T.toString() == 'double?') {
      return double.tryParse(_value) as T;
    }

    return _value as T;
  }

  bool get isValid;

  bool get isNotValid => !isValid;

  String? get error;
}

abstract class SingleValidator<T> extends Validator<T> {
  static bool validate(List<Validator<dynamic>> inputs) {
    return inputs.every((input) => input.isValid);
  }

  const SingleValidator._({required super.value, super.isPure});

  const SingleValidator.pure(String value) : this._(value: value);
  const SingleValidator.dirty(String value) : this._(value: value, isPure: false);

  @override
  bool get isValid => singleValidator(_value) == null;

  @override
  String? get error => isPure ? null : singleValidator(_value);

  String? singleValidator(String value);
}

abstract class DependedValidator<T, V> extends Validator<T> {
  static bool validate(List<Validator<dynamic>> inputs) {
    return inputs.every((input) => input.isValid);
  }

  const DependedValidator._({required super.value, super.isPure, dependency}) : _dependency = dependency;

  const DependedValidator.pure(String value) : this._(value: value);
  const DependedValidator.dirty(String value, V dependency)
      : this._(value: value, isPure: false, dependency: dependency);

  final V _dependency;

  @override
  bool get isValid => dependedValidator(_value, _dependency) == null;

  @override
  String? get error => isPure ? null : dependedValidator(_value, _dependency);

  String? dependedValidator(String value, V dependency);
}
