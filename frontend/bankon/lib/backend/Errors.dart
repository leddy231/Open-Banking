class Errors {
  static String show(String errorCode) {
    switch (errorCode) {
      case 'ERROR_INVALID_EMAIL':
        return "The email address is badly formatted.";

      case 'PlatformException':
        return "Password and Email fields must be filled in";

      case 'ERROR_WRONG_PASSWORD':
        return "E-mail address or password is incorrect.";

      default:
        return "An error has occurred";
    }
  }
}
