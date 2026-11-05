import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../models/lyric_line.dart';
import '../../services/lyrics_service.dart';
import '../../widgets/player/album_disc.dart';
import '../../widgets/player/lyrics_panel.dart';
import '../../widgets/player/playback_slider.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({
    super.key,
    required this.song,
    required this.audioPlayer,
    required this.isPlaying,
    required this.onPlayToggle,
    required this.onStopAudio,
  });

  final Map<String, dynamic> song;
  final AudioPlayer audioPlayer;
  final bool isPlaying;
  final VoidCallback onPlayToggle;
  final VoidCallback onStopAudio;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  final LyricsService _lyricsService = LyricsService();
  final ScrollController _lyricsScrollController = ScrollController();

  late final AnimationController _rotationController;
  late bool _isPlaying;

  List<LyricLine> _lyrics = <LyricLine>[];
  int _activeLyricIndex = -1;
  bool _lyricsAreLoading = true;
  String _lyricsStatus = 'Memuat lirik...';
  Duration _currentPosition = Duration.zero;
  Duration _trackDuration = Duration.zero;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isPlaying;
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    if (_isPlaying) _rotationController.repeat();
    _loadLyrics();
    _readInitialPlaybackState();
    _watchPlaybackPosition();
    _watchTrackDuration();
  }

  Future<void> _loadLyrics() async {
    final result = await _lyricsService.loadForSong(widget.song);
    if (!mounted) return;

    setState(() {
      _lyrics = result.lines;
      _lyricsStatus = result.statusMessage ?? _lyricsStatus;
      _lyricsAreLoading = false;
    });
  }

  Future<void> _readInitialPlaybackState() async {
    final duration = await widget.audioPlayer.getDuration();
    if (duration != null && mounted) {
      setState(() => _trackDuration = duration);
    }

    final position = await widget.audioPlayer.getCurrentPosition();
    if (position != null && mounted) {
      setState(() => _currentPosition = position);
    }
  }

  void _watchPlaybackPosition() {
    _positionSubscription = widget.audioPlayer.onPositionChanged.listen((pos) {
      if (!mounted) return;
      setState(() => _currentPosition = pos);
      _highlightLyricAt(pos);
    });
  }

  void _watchTrackDuration() {
    _durationSubscription = widget.audioPlayer.onDurationChanged.listen((
      duration,
    ) {
      if (mounted) setState(() => _trackDuration = duration);
    });
  }

  void _highlightLyricAt(Duration position) {
    if (_lyrics.isEmpty) return;

    var nextIndex = -1;
    for (var index = 0; index < _lyrics.length; index++) {
      if (position >= _lyrics[index].time) {
        nextIndex = index;
      } else {
        break;
      }
    }

    if (nextIndex == _activeLyricIndex || nextIndex == -1) return;

    setState(() => _activeLyricIndex = nextIndex);
    if (_lyricsScrollController.hasClients) {
      _lyricsScrollController.animateTo(
        nextIndex * 45.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String _formatDuration(Duration value) {
    String twoDigits(int number) => number.toString().padLeft(2, '0');

    final minutes = twoDigits(value.inMinutes.remainder(60));
    final seconds = twoDigits(value.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<bool> _confirmLeaving() async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Keluar dari Halaman Musik'),
            content: const Text(
              'Apakah kamu ingin menghentikan lagu atau tetap memutarnya di latar belakang?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  widget.onStopAudio();
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'Stop Song',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Continue Song',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _togglePlayback() {
    widget.onPlayToggle();
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    });
  }

  Future<void> _seekTo(Duration position) => widget.audioPlayer.seek(position);

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _lyricsScrollController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;
    final artworkUrl = widget.song['artworkUrl100'] ?? '';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmLeaving() && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Now Playing',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          leading: IconButton(
            tooltip: 'Kembali',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () async {
              if (await _confirmLeaving() && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              children: [
                RotationTransition(
                  turns: _rotationController,
                  child: AlbumDisc(
                    artworkUrl: artworkUrl,
                    isPlaying: _isPlaying,
                    accentColor: accentColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.song['trackName'] ?? '-',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
                Text(
                  widget.song['artistName'] ?? '-',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                PlaybackSlider(
                  position: _currentPosition,
                  duration: _trackDuration,
                  onSeek: _seekTo,
                  formatDuration: _formatDuration,
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _togglePlayback,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor,
                    ),
                    child: Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 30,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: LyricsPanel(
                    lines: _lyrics,
                    isLoading: _lyricsAreLoading,
                    statusMessage: _lyricsStatus,
                    activeIndex: _activeLyricIndex,
                    scrollController: _lyricsScrollController,
                    accentColor: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
