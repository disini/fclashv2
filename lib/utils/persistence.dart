import 'package:shared_preferences/shared_preferences.dart';

class Persistence {
  Persistence._();
  late final SharedPreferences prefs;
  Future<void> init() async => prefs = await SharedPreferences.getInstance();
  static late final _instance = Persistence._();
}

final Persistence Per = Persistence._instance;
