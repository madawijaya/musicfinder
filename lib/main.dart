import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/music_application.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(const MusicApplication());
}

// Keeps the original public entry-point name available to existing callers.
class MyApp extends MusicApplication {
  const MyApp({super.key});
}
