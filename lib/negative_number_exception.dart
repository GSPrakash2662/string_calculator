class NegativeNumberException implements Exception {
  final String message;
  NegativeNumberException(this.message);

  @override
  String toString() => message;
}