import 'package:flutter/material.dart';

class AlbumDisc extends StatelessWidget {
  const AlbumDisc({
    super.key,
    required this.artworkUrl,
    required this.isPlaying,
    required this.accentColor,
  });

  final String artworkUrl;
  final bool isPlaying;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    const discSize = 156.0;
    final ringColor = isPlaying
        ? accentColor
        : accentColor.withValues(alpha: 0.35);

    return Container(
      width: discSize,
      height: discSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        border: Border.all(color: ringColor, width: 5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(discSize / 2),
            child: Image.network(
              artworkUrl,
              width: 135,
              height: 135,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.music_note, size: 40),
            ),
          ),
          Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
