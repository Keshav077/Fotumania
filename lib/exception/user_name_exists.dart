class UserNameExistsException implements Exception {
  String message;
  UserNameExistsException(this.message);
}

class UserNotFound implements Exception {
  String message;
  UserNotFound(this.message);
}
