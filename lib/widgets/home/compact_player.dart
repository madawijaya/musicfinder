import 'package:flutter/material.dart';

class CompactPlayer extends StatelessWidget {
  const CompactPlayer({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.accentColor,
    required this.onOpen,
    required this.onToggle,
  });

  final Map<String, dynamic> song;
  final bool isPlaying;
  final Color accentColor;
  final VoidCallback onOpen;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final playerBackground = theme.cardColor;
    final borderColor = theme.dividerColor.withValues(alpha: 0.8);

    return GestureDetector(
      onTap: onOpen,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: playerBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song['artworkUrl60'] ?? '',
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.music_note),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    song['trackName'] ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    song['artistName'] ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: isPlaying ? 'Jeda lagu' : 'Lanjutkan lagu',
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                size: 36,
              ),
              onPressed: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}
