import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/lyric_line.dart';

class LyricsResult {
  const LyricsResult({required this.lines, required this.statusMessage});

  final List<LyricLine> lines;
  final String? statusMessage;
}

class LyricsService {
  Future<LyricsResult> loadForSong(Map<String, dynamic> song) async {
    final endpoint = Uri.https('lrclib.net', '/api/get', {
      'track_name': song['trackName'] ?? '',
      'artist_name': song['artistName'] ?? '',
    });

    try {
      final response = await http.get(endpoint);
      if (response.statusCode != 200) {
        return const LyricsResult(
          lines: <LyricLine>[],
          statusMessage: 'Lirik tidak ditemukan.',
        );
      }

      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      final syncedLyrics = payload['syncedLyrics'] as String?;
      final plainLyrics = payload['plainLyrics'] as String?;

      if (syncedLyrics != null && syncedLyrics.trim().isNotEmpty) {
        return LyricsResult(
          lines: _parseSyncedLyrics(syncedLyrics),
          statusMessage: null,
        );
      }

      if (plainLyrics != null && plainLyrics.trim().isNotEmpty) {
        return LyricsResult(
          lines: plainLyrics
              .split('\n')
              .map((line) => LyricLine(time: Duration.zero, text: line.trim()))
              .toList(),
          statusMessage: null,
        );
      }

      return const LyricsResult(
        lines: <LyricLine>[],
        statusMessage: 'Lirik tidak tersedia.',
      );
    } catch (_) {
      return const LyricsResult(
        lines: <LyricLine>[],
        statusMessage: 'Gagal memuat lirik.',
      );
    }
  }

  List<LyricLine> _parseSyncedLyrics(String lyrics) {
    final timestampPattern = RegExp(r'\[(\d+):(\d+\.\d+)\](.*)');

    return lyrics
        .split('\n')
        .map((line) {
          final match = timestampPattern.firstMatch(line.trim());
          if (match == null) return null;

          final minutes = int.tryParse(match.group(1) ?? '0') ?? 0;
          final seconds = double.tryParse(match.group(2) ?? '0.0') ?? 0.0;
          final text = (match.group(3) ?? '').trim();

          return LyricLine(
            time: Duration(
              milliseconds: (minutes * 60 * 1000) + (seconds * 1000).toInt(),
            ),
            text: text.isEmpty ? '\u00e2\u2122\u00aa' : text,
          );
        })
        .whereType<LyricLine>()
        .toList();
  }
}
