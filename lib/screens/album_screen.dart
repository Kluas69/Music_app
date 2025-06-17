import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/audio_player_manager.dart';
import '../widgets/song_tile.dart';
import '../widgets/now_playing_tab.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/song.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});

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
            'Album Name',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () => Navigator.pushNamed(context, '/search'),
            splashColor: const Color(0xFF1DB954).withOpacity(0.3),
          ),
          Consumer<AudioPlayerManager>(
            builder: (context, audioPlayerManager, child) => IconButton(
              icon: Icon(
                audioPlayerManager.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: audioPlayerManager.isFavorite
                    ? Colors.red
                    : Colors.white,
                size: 28,
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
              splashColor: const Color(0xFF1DB954).withOpacity(0.3),
            ),
          ),
        ],
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
                      'assets/images/album1.jpg',
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedScale(
                              scale: 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                height: isTablet ? 300 : 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/images/album1.jpg',
                                    ),
                                    fit: BoxFit.cover,
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
                            const SizedBox(height: 20),
                            AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(milliseconds: 800),
                              child: Text(
                                'Tracks',
                                style: TextStyle(
                                  fontSize: isTablet ? 28 : 20,
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
                            const SizedBox(height: 12),
                            Song.mockSongs.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No songs available',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: Song.mockSongs.length,
                                    itemBuilder: (context, index) =>
                                        AnimatedOpacity(
                                          opacity: 1.0,
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          child: SongTile(
                                            song: Song.mockSongs[index],
                                            onTap: () {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((
                                                    _,
                                                  ) async {
                                                    final audioPlayerManager =
                                                        Provider.of<
                                                          AudioPlayerManager
                                                        >(
                                                          context,
                                                          listen: false,
                                                        );
                                                    await audioPlayerManager
                                                        .playSong(
                                                          Song.mockSongs[index],
                                                        );
                                                    if (ModalRoute.of(
                                                          context,
                                                        )?.settings.name !=
                                                        '/now_playing') {
                                                      Navigator.pushNamed(
                                                        context,
                                                        '/now_playing',
                                                        arguments: Song
                                                            .mockSongs[index],
                                                      );
                                                    }
                                                  });
                                            },
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
          const NowPlayingTab(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        onTabChange: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1) Navigator.pushReplacementNamed(context, '/library');
          if (index == 2) Navigator.pushReplacementNamed(context, '/profile');
        },
      ),
    );
  }
}
