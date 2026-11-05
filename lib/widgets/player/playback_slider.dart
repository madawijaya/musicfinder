import 'package:flutter/material.dart';

class PlaybackSlider extends StatelessWidget {
  const PlaybackSlider({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
    required this.formatDuration,
  });

  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;
  final String Function(Duration) formatDuration;

  @override
  Widget build(BuildContext context) {
    final maxSeconds = duration.inSeconds > 0
        ? duration.inSeconds.toDouble()
        : 30.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Slider(
            min: 0,
            max: maxSeconds,
            value: position.inSeconds.toDouble().clamp(0, maxSeconds),
            onChanged: (value) => onSeek(Duration(seconds: value.toInt())),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(position),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  formatDuration(duration),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
