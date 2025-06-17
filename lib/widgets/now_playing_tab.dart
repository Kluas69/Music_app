import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/audio_player_manager.dart';

class NowPlayingTab extends StatefulWidget {
  const NowPlayingTab({super.key});

  @override
  State<NowPlayingTab> createState() => _NowPlayingTabState();
}

class _NowPlayingTabState extends State<NowPlayingTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerManager>(
      builder: (context, audioPlayerManager, child) {
        final currentSong = audioPlayerManager.currentSong;
        if (currentSong == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != '/now_playing') {
              _animationController.forward().then(
                (_) => _animationController.reverse(),
              );
              Navigator.pushNamed(
                context,
                '/now_playing',
                arguments: currentSong,
              );
            }
          },
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) =>
                Transform.scale(scale: _scaleAnimation.value, child: child),
            child: Container(
              height: 80,
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF282828).withOpacity(0.8),
                    const Color(0xFF1DB954).withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: LinearProgressIndicator(
                          value: audioPlayerManager.duration.inSeconds > 0
                              ? (audioPlayerManager.position.inSeconds /
                                        audioPlayerManager.duration.inSeconds)
                                    .clamp(0.0, 1.0)
                              : 0.0,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.green.withOpacity(0.3),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(12.0),
                            ),
                            child: Image.asset(
                              currentSong.images,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[900],
                                    child: const Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentSong.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4.0,
                                        color: Colors.black54,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currentSong.artist,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              audioPlayerManager.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: audioPlayerManager.isFavorite
                                  ? Colors.red
                                  : Colors.grey[400],
                              size: 24,
                            ),
                            onPressed: () {
                              audioPlayerManager.toggleFavorite();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    audioPlayerManager.isFavorite
                                        ? 'Added to favorites'
                                        : 'Removed from favorites',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              audioPlayerManager.isShuffled
                                  ? Icons.shuffle
                                  : Icons.shuffle,
                              color: audioPlayerManager.isShuffled
                                  ? const Color(0xFF1DB954)
                                  : Colors.grey[400],
                              size: 24,
                            ),
                            onPressed: () {
                              audioPlayerManager.toggleShuffle();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              audioPlayerManager.isRepeated
                                  ? Icons.repeat_one
                                  : Icons.repeat,
                              color: audioPlayerManager.isRepeated
                                  ? const Color(0xFF1DB954)
                                  : Colors.grey[400],
                              size: 24,
                            ),
                            onPressed: () {
                              audioPlayerManager.toggleRepeat();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              audioPlayerManager.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              color: const Color(0xFF1DB954),
                              size: 36,
                            ),
                            onPressed: () async {
                              try {
                                await audioPlayerManager.togglePlayPause();
                              } catch (e) {
                                debugPrint('Playback error: $e');
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Playback error: $e'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          const SizedBox(width: 8.0),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
