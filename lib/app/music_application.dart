import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../pages/home/music_home_page.dart';
import '../services/preferences_store.dart';
import 'music_theme.dart';

class MusicApplication extends StatefulWidget {
  const MusicApplication({super.key});

  @override
  State<MusicApplication> createState() => _MusicApplicationState();
}

class _MusicApplicationState extends State<MusicApplication> {
  late final PreferencesStore _preferences;
  String _displayName = '';
  bool _darkModeEnabled = true;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _preferences = PreferencesStore(Hive.box('settings'));
    _restorePreferences();
  }

  void _restorePreferences() {
    setState(() {
      _displayName = _preferences.username;
      _darkModeEnabled = _preferences.isDarkMode;
      _isReady = true;
    });
  }

  Future<void> _updateDisplayName(String value) async {
    await _preferences.saveUsername(value);
    setState(() => _displayName = value);
  }

  Future<void> _updateTheme(bool enabled) async {
    await _preferences.saveDarkMode(enabled);
    setState(() => _darkModeEnabled = enabled);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      themeMode: _darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      theme: MusicTheme.light,
      darkTheme: MusicTheme.dark,
      home: MusicHomePage(
        username: _displayName,
        isDarkMode: _darkModeEnabled,
        onSaveUsername: _updateDisplayName,
        onThemeChanged: _updateTheme,
      ),
    );
  }
}
