import 'package:hive/hive.dart';

class PreferencesStore {
  const PreferencesStore(this._settings);

  final Box<dynamic> _settings;

  String get username => _settings.get('username', defaultValue: '');

  bool get isDarkMode => _settings.get('isDarkMode', defaultValue: true);

  Future<void> saveUsername(String value) => _settings.put('username', value);

  Future<void> saveDarkMode(bool enabled) =>
      _settings.put('isDarkMode', enabled);
}
