import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/bottom_nav_bar.dart';
import '../widgets/playlist_card.dart';
import '../widgets/song_tile.dart';
import '../widgets/now_playing_tab.dart';
import '../models/song.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
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
        title: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 600),
          child: const Text(
            'Your Library',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: [
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
        automaticallyImplyLeading: false,
        leading: null,
        actions: [
          AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 28),
              onPressed: () => Navigator.pushNamed(context, '/search'),
              splashColor: const Color(0xFF1DB954).withOpacity(0.3),
            ),
          ),
          AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 28),
              onPressed: () => Navigator.pushNamed(context, '/create_playlist'),
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
                  colors: [Color(0xFF1DB954), Color(0xFF121212)],
                  stops: [0.0, 0.4],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/4.jpg',
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(context, 'Playlists'),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              itemCount: Song.mockSongs.length,
                              itemBuilder: (context, index) => AnimatedScale(
                                scale: 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(right: 16),
                                  child: PlaylistCard(
                                    title: 'Playlist ${index + 1}',
                                    images: Song.mockSongs[index].images,
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/playlist',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _buildSectionTitle(context, 'Albums'),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              itemCount: Song.mockSongs.length,
                              itemBuilder: (context, index) => AnimatedScale(
                                scale: 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(right: 16),
                                  child: PlaylistCard(
                                    title: 'Album ${index + 1}',
                                    images: Song.mockSongs[index].images,
                                    onTap: () =>
                                        Navigator.pushNamed(context, '/album'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _buildSectionTitle(context, 'Artists'),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              itemCount: Song.mockSongs.length,
                              itemBuilder: (context, index) => AnimatedScale(
                                scale: 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(right: 16),
                                  child: PlaylistCard(
                                    title: 'Artist ${index + 1}',
                                    images: Song.mockSongs[index].images,
                                    onTap: () =>
                                        Navigator.pushNamed(context, '/artist'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _buildSectionTitle(context, 'Songs'),
                          Song.mockSongs.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No songs available',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: Song.mockSongs.length,
                                  itemBuilder: (context, index) =>
                                      AnimatedOpacity(
                                        opacity: 1.0,
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        child: SongTile(
                                          song: Song.mockSongs[index],
                                          onTap: () => Navigator.pushNamed(
                                            context,
                                            '/now_playing',
                                            arguments: Song.mockSongs[index],
                                          ),
                                        ),
                                      ),
                                ),
                          SizedBox(height: size.height * 0.1),
                        ],
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/see_all'),
            child: Text(
              'See All',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
