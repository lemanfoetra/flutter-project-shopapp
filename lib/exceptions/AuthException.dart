class AuthException implements Exception {
  final String _message;

  AuthException(this._message);

  @override
  String toString() {
    return _message;
  }
}
