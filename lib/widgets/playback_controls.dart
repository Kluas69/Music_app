import 'package:flutter/material.dart';

class PlaybackControls extends StatelessWidget {
  final bool isPlaying;
  final bool isShuffled;
  final bool isRepeated;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onShuffle;
  final VoidCallback onRepeat;

  const PlaybackControls({
    super.key,
    required this.isPlaying,
    required this.isShuffled,
    required this.isRepeated,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onShuffle,
    required this.onRepeat,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.shuffle,
            color: isShuffled ? const Color(0xFF1DB954) : Colors.grey[400],
            size: size.width * 0.06,
          ),
          onPressed: onShuffle,
          splashColor: const Color(0xFF1DB954).withOpacity(0.3),
        ),
        SizedBox(width: size.width * 0.02),
        IconButton(
          icon: Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: size.width * 0.09,
          ),
          onPressed: onPrevious,
          splashColor: const Color(0xFF1DB954).withOpacity(0.3),
        ),
        SizedBox(width: size.width * 0.04),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
            size: size.width * 0.16,
            color: const Color(0xFF1DB954),
          ),
          onPressed: onPlayPause,
          splashColor: const Color(0xFF1DB954).withOpacity(0.3),
        ),
        SizedBox(width: size.width * 0.04),
        IconButton(
          icon: Icon(
            Icons.skip_next,
            color: Colors.white,
            size: size.width * 0.09,
          ),
          onPressed: onNext,
          splashColor: const Color(0xFF1DB954).withOpacity(0.3),
        ),
        SizedBox(width: size.width * 0.02),
        IconButton(
          icon: Icon(
            isRepeated ? Icons.repeat_one : Icons.repeat,
            color: isRepeated ? const Color(0xFF1DB954) : Colors.grey[400],
            size: size.width * 0.06,
          ),
          onPressed: onRepeat,
          splashColor: const Color(0xFF1DB954).withOpacity(0.3),
        ),
      ],
    );
  }
}
