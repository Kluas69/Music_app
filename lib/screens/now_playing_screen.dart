import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/audio_player_manager.dart';
import '../models/song.dart';
import '../widgets/playback_controls.dart';

class NowPlayingScreen extends StatefulWidget {
  final Song song;
  const NowPlayingScreen({super.key, required this.song});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayerManager _audioPlayerManager = AudioPlayerManager();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _setupAudioListeners();
    _initPlayer();
  }

  void _setupAudioListeners() {
    _audioPlayerManager.audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {});
      }
    });
    _audioPlayerManager.audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {});
      }
    });
    _audioPlayerManager.audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _initPlayer() async {
    // Only play the song if it's different from the current song or not playing
    if (_audioPlayerManager.currentSong != widget.song) {
      await _audioPlayerManager.playSong(widget.song);
    } else if (!_audioPlayerManager.isPlaying) {
      await _audioPlayerManager.togglePlayPause();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.transparent),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
          splashColor: const Color(0xFF1DB954).withOpacity(0.3),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _audioPlayerManager.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: _audioPlayerManager.isFavorite ? Colors.red : Colors.white,
              size: 28,
            ),
            onPressed: () {
              _audioPlayerManager.toggleFavorite();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _audioPlayerManager.isFavorite
                        ? 'Added to favorites'
                        : 'Removed from favorites',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            splashColor: const Color(0xFF1DB954).withOpacity(0.3),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1DB954), Color(0xFF121212)],
            stops: [0.0, 0.5],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
                color: Colors.black54,
                colorBlendMode: BlendMode.darken,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.black87),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.05),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              widget.song.images,
                              width: size.width * 0.75,
                              height: size.width * 0.75,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: size.width * 0.75,
                                    height: size.width * 0.75,
                                    color: Colors.grey[900],
                                    child: const Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                      size: 80,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          widget.song.title,
                          style: TextStyle(
                            fontSize: size.width * 0.07,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                blurRadius: 6.0,
                                color: Colors.black54,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        widget.song.artist,
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          color: Colors.grey[400],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: size.height * 0.04),
                      Slider(
                        activeColor: const Color(0xFF1DB954),
                        inactiveColor: Colors.grey[600],
                        value: _audioPlayerManager.duration.inSeconds > 0
                            ? (_audioPlayerManager.position.inSeconds
                                  .toDouble()
                                  .clamp(
                                    0,
                                    _audioPlayerManager.duration.inSeconds
                                        .toDouble(),
                                  ))
                            : 0.0,
                        min: 0.0,
                        max: _audioPlayerManager.duration.inSeconds > 0
                            ? _audioPlayerManager.duration.inSeconds.toDouble()
                            : 1.0,
                        onChanged: _audioPlayerManager.duration.inSeconds > 0
                            ? (value) async {
                                final position = Duration(
                                  seconds: value.toInt(),
                                );
                                await _audioPlayerManager.seek(position);
                              }
                            : null,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_audioPlayerManager.position),
                              style: TextStyle(
                                fontSize: size.width * 0.035,
                                color: Colors.grey[400],
                              ),
                            ),
                            Text(
                              _formatDuration(_audioPlayerManager.duration),
                              style: TextStyle(
                                fontSize: size.width * 0.035,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: PlaybackControls(
                          isPlaying: _audioPlayerManager.isPlaying,
                          isShuffled: _audioPlayerManager.isShuffled,
                          isRepeated: _audioPlayerManager.isRepeated,
                          onPlayPause: () async {
                            await _audioPlayerManager.togglePlayPause();
                          },
                          onPrevious: () async {
                            await _audioPlayerManager.playPrevious();
                            Navigator.pushReplacementNamed(
                              context,
                              '/now_playing',
                              arguments: _audioPlayerManager.currentSong,
                            );
                          },
                          onNext: () async {
                            await _audioPlayerManager.playNext();
                            Navigator.pushReplacementNamed(
                              context,
                              '/now_playing',
                              arguments: _audioPlayerManager.currentSong,
                            );
                          },
                          onShuffle: () {
                            _audioPlayerManager.toggleShuffle();
                          },
                          onRepeat: () {
                            _audioPlayerManager.toggleRepeat();
                          },
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
