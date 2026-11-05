import 'package:flutter/material.dart';

import '../../models/lyric_line.dart';

class LyricsPanel extends StatelessWidget {
  const LyricsPanel({
    super.key,
    required this.lines,
    required this.isLoading,
    required this.statusMessage,
    required this.activeIndex,
    required this.scrollController,
    required this.accentColor,
  });

  final List<LyricLine> lines;
  final bool isLoading;
  final String statusMessage;
  final int activeIndex;
  final ScrollController scrollController;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isLoading) {
      content = Center(child: CircularProgressIndicator(color: accentColor));
    } else if (lines.isEmpty) {
      content = Center(child: Text(statusMessage));
    } else {
      content = ListView.builder(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final isHighlighted = index == activeIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              lines[index].text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isHighlighted ? 18 : 14,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? accentColor : Colors.grey,
              ),
            ),
          );
        },
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.8),
        ),
      ),
      child: content,
    );
  }
}
