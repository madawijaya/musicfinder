import 'package:flutter/material.dart';

class SongResultCard extends StatelessWidget {
  const SongResultCard({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.accentColor,
    required this.onPlay,
    required this.onOpen,
  });

  final Map<String, dynamic> song;
  final bool isPlaying;
  final Color accentColor;
  final VoidCallback onPlay;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    const artworkSize = 50.0;
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: cardShape,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            song['artworkUrl60'] ?? '',
            width: artworkSize,
            height: artworkSize,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.music_note),
          ),
        ),
        title: Text(
          song['trackName'] ?? '-',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song['artistName'] ?? '-',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          tooltip: isPlaying ? 'Jeda lagu' : 'Putar lagu',
          icon: Icon(
            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
            color: accentColor,
            size: 36,
          ),
          onPressed: onPlay,
        ),
        onTap: onOpen,
      ),
    );
  }
}
