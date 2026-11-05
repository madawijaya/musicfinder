import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pertemuan11/pages/home/music_home_page.dart';

void main() {
  testWidgets('music home page renders search controls', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MusicHomePage(
          username: '',
          isDarkMode: true,
          onSaveUsername: (_) async {},
          onThemeChanged: (_) async {},
        ),
      ),
    );

    expect(find.text('Explore Music'), findsOneWidget);
    expect(find.text('Cari judul lagu atau artis...'), findsOneWidget);
    expect(find.text('Belum ada lagu yang dicari'), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
  });
}
