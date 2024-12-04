import 'package:shared_preferences/shared_preferences.dart';

class _Keys {
  static const mentalHealthScore = "mental_health_score";
}

final SharedPreferencesManager sharedPreferencesManager =
    SharedPreferencesManager();

class SharedPreferencesManager {
  SharedPreferencesManager._privateConstructor();

  static final SharedPreferencesManager _instance =
      SharedPreferencesManager._privateConstructor();

  factory SharedPreferencesManager() {
    return _instance;
  }

  static late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> createInstance() async {
    await initialize();
  }

  /// ////////////////////////////////   Getter Setters Function here //////////// /////////////////////////

  /// mental health score getter and setter
  String get getMentalHealthScore =>
      _prefs.getString(_Keys.mentalHealthScore) ?? '0%';

  set setMentalHealthScore(String value) =>
      _prefs.setString(_Keys.mentalHealthScore, value);


}
