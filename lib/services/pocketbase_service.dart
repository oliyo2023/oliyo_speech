import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  static final PocketBaseService _instance = PocketBaseService._internal();
  final PocketBase pb = PocketBase('https://8.140.206.248/pocketbase');

  factory PocketBaseService() {
    return _instance;
  }

  PocketBaseService._internal();
}
