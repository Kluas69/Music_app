import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';
import 'dart:io';

class AudioPlayerManager extends ChangeNotifier {
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  factory AudioPlayerManager() => _instance;
  AudioPlayerManager._internal() {
    _setupAudioListeners();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  bool _isPlaying = false;
  bool _isFavorite = false;
  bool _isShuffled = false;
  bool _isRepeated = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isNavigating = false;

  // Getters
  AudioPlayer get audioPlayer => _audioPlayer;
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isFavorite => _isFavorite;
  bool get isShuffled => _isShuffled;
  bool get isRepeated => _isRepeated;
  Duration get duration => _duration;
  Duration get position => _position;

  void _setupAudioListeners() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });
    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      notifyListeners();
    });
    _audioPlayer.onPositionChanged.listen((position) {
      _position = position;
      notifyListeners();
    });
    _audioPlayer.onPlayerComplete.listen((_) async {
      if (_isRepeated) {
        await playSong(_currentSong!);
      } else {
        await playNext();
      }
    });
  }

  Future<void> playSong(Song song) async {
    if (_isNavigating || song.audioPath.isEmpty || _currentSong == song) {
      if (!_isPlaying && _currentSong == song) {
        await _audioPlayer.resume();
        _isPlaying = true;
        notifyListeners();
      }
      return;
    }
    _isNavigating = true;
    // Batch state updates
    _currentSong = song;
    _position = Duration.zero;
    _duration = Duration.zero;
    _isPlaying = false;
    try {
      await _audioPlayer.stop();
      String audioUrl = song.audioPath;
      // Normalize file path for Windows
      if (Platform.isWindows && !audioUrl.startsWith('assets/')) {
        audioUrl = audioUrl.replaceAll(r'\', '/');
        if (!File(audioUrl).existsSync()) {
          throw Exception('File not found: $audioUrl');
        }
      }
      Source source;
      if (audioUrl.startsWith('assets/')) {
        source = AssetSource(audioUrl.replaceFirst('assets/', ''));
      } else {
        source = DeviceFileSource(audioUrl);
      }
      await _audioPlayer.setSource(source);
      await _audioPlayer.play(source);
      _isPlaying = true;
    } catch (e, stackTrace) {
      debugPrint('Error playing audio: $e\n$stackTrace');
      _isPlaying = false;
      // Notify UI of error
      notifyListeners();
      rethrow; // Allow callers to handle error
    } finally {
      _isNavigating = false;
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        _isPlaying = false;
      } else {
        await _audioPlayer.resume();
        _isPlaying = true;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Playback error: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      _position = position;
      notifyListeners();
    } catch (e) {
      debugPrint('Seek error: $e');
    }
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeated = !_isRepeated;
    notifyListeners();
  }

  Future<void> playNext() async {
    if (_currentSong == null) return;
    final currentIndex = Song.mockSongs.indexOf(_currentSong!);
    final nextIndex = (currentIndex + 1) % Song.mockSongs.length;
    await playSong(Song.mockSongs[nextIndex]);
  }

  Future<void> playPrevious() async {
    if (_currentSong == null) return;
    final currentIndex = Song.mockSongs.indexOf(_currentSong!);
    final prevIndex =
        (currentIndex - 1 + Song.mockSongs.length) % Song.mockSongs.length;
    await playSong(Song.mockSongs[prevIndex]);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
