import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../widgets/audio_player_manager.dart';

class UploadAudioScreen extends StatefulWidget {
  const UploadAudioScreen({super.key});

  @override
  State<UploadAudioScreen> createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _audioPath;
  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  Future<void> _pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowedExtensions: ['mp3', 'wav', 'm4a'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _audioPath = result.files.single.path;
      });
      debugPrint('Selected audio: $_audioPath');
    }
  }

  Future<void> _uploadAudio() async {
    if (_formKey.currentState!.validate() && _audioPath != null) {
      setState(() {
        _isUploading = true;
      });
      try {
        await Future.delayed(const Duration(seconds: 1)); // Simulate upload
        final newSong = Song(
          title: _titleController.text,
          artist: _artistController.text,
          album: 'User Uploads', // Default album for uploaded songs
          images: 'assets/images/default_song.jpg',
          duration: const Duration(minutes: 3), // Default duration
          audioPath: _audioPath!,
        );
        Song.mockSongs.add(newSong);
        // Notify AudioPlayerManager of new song
        final audioPlayerManager = Provider.of<AudioPlayerManager>(
          context,
          listen: false,
        );
        audioPlayerManager.notifyListeners(); // Trigger UI updates
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Song uploaded successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        debugPrint('Upload error: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    } else if (_audioPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an audio file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

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
        title: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 600),
          child: Text(
            'Upload Audio',
            style: TextStyle(
              fontSize: isTablet ? 28 : 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: const [
                Shadow(
                  blurRadius: 3.0,
                  color: Colors.black54,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1DB954), Color(0xFF080808)],
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
                      child: Container(color: Colors.black.withOpacity(0.3)),
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 32.0 : 24.0,
                        vertical: 16.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AnimatedScale(
                              scale: 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                height: isTablet ? 200 : 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/images/upload.png',
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _titleController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Song Title',
                                  labelStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[900]!.withOpacity(0.8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF1DB954),
                                      width: 2,
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.music_note,
                                    color: Color(0xFF1DB954),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a song title';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _artistController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Artist Name',
                                  labelStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[900]!.withOpacity(0.8),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF1DB954),
                                      width: 2,
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Color(0xFF1DB954),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an artist name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            AnimatedScale(
                              scale: 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: ElevatedButton.icon(
                                onPressed: _isUploading ? null : _pickAudio,
                                icon: Image.asset(
                                  'assets/images/upload.png',
                                  width: 24,
                                  height: 24,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  _audioPath == null
                                      ? 'Select Audio'
                                      : 'Change Audio',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1DB954),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 14,
                                  ),
                                  minimumSize: Size(size.width * 0.8, 50),
                                  elevation: 5,
                                  shadowColor: Colors.black.withOpacity(0.4),
                                ),
                              ),
                            ),
                            if (_audioPath != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 600),
                                  child: Text(
                                    'Selected: ${_audioPath!.split('/').last}',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                      shadows: const [
                                        Shadow(
                                          blurRadius: 3.0,
                                          color: Colors.black54,
                                          offset: Offset(1.0, 1.0),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 32),
                            AnimatedScale(
                              scale: 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: ElevatedButton(
                                onPressed: _isUploading ? null : _uploadAudio,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1DB954),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 14,
                                  ),
                                  minimumSize: Size(size.width * 0.8, 50),
                                  elevation: 5,
                                  shadowColor: Colors.black.withOpacity(0.4),
                                ),
                                child: _isUploading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Upload',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const NowPlayingTab(),
        ],
      ),
      // bottomNavigationBar: BottomNavBar(
      //   onTabChange: (index) {
      //     if (index == 0) Navigator.pushReplacementNamed(context, '/home');
      //     if (index == 1) Navigator.pushReplacementNamed(context, '/library');
      //     if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
      //   },
      // ),
    );
  }
}
