class RegexData {
  static var digitAndPointRegex = RegExp(r'^[0-9.]+$');
  static var hsnCodeRegex = RegExp(r'^[0-9.]+$');
  static var digitRegex = RegExp(r'^[0-9]+$');
  static var nameRegex = RegExp(r'^[a-zA-Z0-9 ]+$');
  static var addressRegex = RegExp(r'^[a-zA-Z0-9 ,]+$');
  static var mobileNumberRegex = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  static var emailIdRegex =
      RegExp(r'^[a-zA-Z0-9_!#$%&*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$');
  static var passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
// r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&-+=()])(?=\\S+$).{8,20}$');
}
