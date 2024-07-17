import 'package:get/get.dart';

class Messages extends Translations {
  final Map<String, Map<String, String>>? languages;
  Messages({this.languages});

  @override
  Map<String, Map<String, String>> get keys {
    return languages!;
  }
}