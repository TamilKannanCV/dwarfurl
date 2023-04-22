import 'dart:math';

abstract class RandomString {
  static const String _letters =
      "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789";
  static String generate(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        ((index) => _letters.codeUnitAt(Random().nextInt(_letters.length))),
      ),
    );
  }
}
