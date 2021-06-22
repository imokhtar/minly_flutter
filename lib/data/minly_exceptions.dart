class MinlyException implements Exception {
  final String? _message;

  MinlyException([
    this._message,
  ]);

  String toString() {
    return "$_message";
  }
}

class MinlyExceptions {
  static final internalServerError = MinlyException("Internal Server Error");
  static final badRequest = MinlyException("Bad Request");
  static final unknownError = MinlyException("Unknown Error");
}
