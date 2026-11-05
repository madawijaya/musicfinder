import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../pages/player/now_playing_page.dart';
import '../../pages/profile/profile_settings_page.dart';
import '../../services/music_search_service.dart';
import '../../widgets/home/compact_player.dart';
import '../../widgets/home/home_greeting.dart';
import '../../widgets/home/music_search_field.dart';
import '../../widgets/home/song_result_card.dart';

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({
    super.key,
    required this.username,
    required this.isDarkMode,
    required this.onSaveUsername,
    required this.onThemeChanged,
  });

  final String username;
  final bool isDarkMode;
  final Future<void> Function(String) onSaveUsername;
  final Future<void> Function(bool) onThemeChanged;

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final AudioPlayer _player = AudioPlayer();
  final MusicSearchService _searchService = MusicSearchService();

  List<Map<String, dynamic>> _tracks = <Map<String, dynamic>>[];
  Map<String, dynamic>? _activeTrack;
  String? _activePreviewUrl;
  bool _audioIsPlaying = false;

  @override
  void dispose() {
    _player.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchTracks() async {
    if (_searchController.text.trim().isEmpty) return;

    FocusScope.of(context).unfocus();
    final query = _searchController.text;

    try {
      final tracks = await _searchService.findSongs(query);
      if (mounted && tracks != null) setState(() => _tracks = tracks);
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  Future<void> _playTrack(Map<String, dynamic> track) async {
    final previewUrl = track['previewUrl'];
    if (previewUrl == null || previewUrl.isEmpty) return;

    if (_activePreviewUrl == previewUrl && _audioIsPlaying) {
      await _player.pause();
      if (mounted) setState(() => _audioIsPlaying = false);
      return;
    }

    await _player.stop();
    await _player.play(UrlSource(previewUrl));
    if (!mounted) return;

    setState(() {
      _activeTrack = track;
      _activePreviewUrl = previewUrl;
      _audioIsPlaying = true;
    });
  }

  Future<void> _toggleAudio() async {
    if (_activePreviewUrl == null) return;

    if (_audioIsPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }

    if (mounted) setState(() => _audioIsPlaying = !_audioIsPlaying);
  }

  Future<void> _stopAudio() async {
    await _player.stop();
    if (!mounted) return;

    setState(() {
      _audioIsPlaying = false;
      _activePreviewUrl = null;
      _activeTrack = null;
    });
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileSettingsPage(
          username: widget.username,
          isDarkMode: widget.isDarkMode,
          onSave: widget.onSaveUsername,
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  void _openPlayer(Map<String, dynamic> track, bool isPlaying) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NowPlayingPage(
          song: track,
          audioPlayer: _player,
          isPlaying: isPlaying,
          onPlayToggle: () => _playTrack(track),
          onStopAudio: _stopAudio,
        ),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Music Finder',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Profil dan pengaturan',
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: _openProfile,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeGreeting(username: widget.username),
              const SizedBox(height: 20),
              MusicSearchField(
                controller: _searchController,
                onSearch: _searchTracks,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _tracks.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 60),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.library_music_outlined,
                                size: 48,
                                color: accentColor.withValues(alpha: 0.7),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Belum ada lagu yang dicari',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Masukkan judul lagu atau nama artis di atas.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _tracks.length,
                        itemBuilder: (context, index) {
                          final track = _tracks[index];
                          final isPlaying =
                              _audioIsPlaying &&
                              _activePreviewUrl == track['previewUrl'];

                          return SongResultCard(
                            song: track,
                            isPlaying: isPlaying,
                            accentColor: accentColor,
                            onPlay: () => _playTrack(track),
                            onOpen: () => _openPlayer(track, isPlaying),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _activeTrack == null
          ? null
          : SafeArea(
              top: false,
              child: CompactPlayer(
                song: _activeTrack!,
                isPlaying: _audioIsPlaying,
                accentColor: accentColor,
                onOpen: () => _openPlayer(_activeTrack!, _audioIsPlaying),
                onToggle: _toggleAudio,
              ),
            ),
    );
  }
}
