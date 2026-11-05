import 'dart:convert';

import 'package:http/http.dart' as http;

class MusicSearchService {
  Future<List<Map<String, dynamic>>?> findSongs(String query) async {
    final endpoint = Uri.https('itunes.apple.com', '/search', {
      'term': query,
      'entity': 'song',
      'limit': '15',
    });

    final response = await http.get(endpoint);
    if (response.statusCode != 200) return null;

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final results = decoded['results'];
    if (results is! List) return <Map<String, dynamic>>[];

    return results
        .whereType<Map>()
        .map((song) => Map<String, dynamic>.from(song))
        .toList();
  }
}
